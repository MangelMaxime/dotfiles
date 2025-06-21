#!/bin/bash

declare -A known_sinks

# Define a mapping of known sink names to friendly names
known_sinks=(
  ["Logitech A50"]="alsa_output.usb-Logitech_A50-00.analog-stereo"
  ["Edifier Speakers"]="alsa_output.pci-0000_00_1f.3.analog-stereo"
)

# Define a list of sinks to ignore
ignore_sinks=(
    "alsa_output.pci-0000_01_00.1.hdmi-stereo"
)

# Check that fzf is installed
if ! command -v fzf &> /dev/null; then
  echo "❌ fzf is not installed. Install it first."
  exit 1
fi

# Get list of available sinks
sink_list=$(pactl list short sinks)

if [ -z "$sink_list" ]; then
  echo "❌ No sinks found via pactl."
  exit 1
fi

# Keep only the name of each sink
sink_list=$(echo "$sink_list" | awk '{print $2}')

# Remove unwanted sinks
if [ ${#ignore_sinks[@]} -gt 0 ]; then
    sink_list=$(echo "$sink_list" | grep -v -E "$(IFS=\|; echo "${ignore_sinks[*]}")")
fi

# Replace known sink names with more descriptive ones
for name in "${!known_sinks[@]}"; do
  sink_list=$(echo "$sink_list" | sed -e "s/${known_sinks[$name]}/$name/")
done

# Use fzf to select a sink (display sink names, return full line)
selected_line=$(echo "$sink_list" | fzf --prompt="Select sink: ")

if [ -z "$selected_line" ]; then
  echo "❌ No sink selected."
  exit 1
fi

# Extract sink name from selected line
original_sink_name=${known_sinks[$selected_line]:-$selected_line}

# Set the selected sink as default
pactl set-default-sink "$original_sink_name"
echo "✅ Default sink set to: $selected_line"

# Move all current audio streams to the new sink
for input in $(pactl list short sink-inputs | cut -f1); do
  pactl move-sink-input "$input" "$original_sink_name"
done

echo "🔁 Moved active audio streams to: $selected_line"

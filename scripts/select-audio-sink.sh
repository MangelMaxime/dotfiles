#!/bin/bash

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

# Use fzf to select a sink (display sink names, return full line)
selected_line=$(echo "$sink_list" | fzf --prompt="Select sink: ")

if [ -z "$selected_line" ]; then
  echo "❌ No sink selected."
  exit 1
fi

# Extract sink name from selected line
sink_name=$(echo "$selected_line" | awk '{print $2}')

# Set the selected sink as default
pactl set-default-sink "$sink_name"
echo "✅ Default sink set to: $sink_name"

# Move all current audio streams to the new sink
for input in $(pactl list short sink-inputs | cut -f1); do
  pactl move-sink-input "$input" "$sink_name"
done

echo "🔁 Moved active audio streams to: $sink_name"

#!/bin/bash

# Check that fzf is installed
if ! command -v fzf &> /dev/null; then
  echo "❌ fzf is not installed. Install it first."
  exit 1
fi

# Get list of available input sources (only `alsa_input`)
input_list=$(pactl list short sources | grep 'alsa_input')

if [ -z "$input_list" ]; then
  echo "❌ No input sources found via pactl."
  exit 1
fi

# Use fzf to select an input source (display source names, return full line)
selected_line=$(echo "$input_list" | fzf --prompt="Select input source: ")

if [ -z "$selected_line" ]; then
  echo "❌ No input source selected."
  exit 1
fi

# Extract input source name from selected line
input_source=$(echo "$selected_line" | awk '{print $2}')

# Set the selected input source as active
pactl set-default-source "$input_source"
echo "✅ Default input source set to: $input_source"

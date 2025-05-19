#!/usr/bin/env bash

# This script is used to make it possible to move focus between windows in a group
# and outside of the group via the same keybinding.

if [ "$1" == "left" ]; then
    direction="l"
    movefocus_direction="l"
    changegroupactive_direction="b"
elif [ "$1" == "right" ]; then
    direction="r"
    movefocus_direction="r"
    changegroupactive_direction="f"
else
    notify-send "Invalid argument. Use 'left' or 'right'."
    exit 1
fi

focused=$(hyprctl activewindow -j)
grouped=$(echo "$focused" | jq -r '.grouped[]?')

if [ -z "$grouped" ]; then
    # If we are not in a group, just move the focus
    hyprctl dispatch movefocus ${movefocus_direction}
    exit 0
else
    # Otherwise, we need to check the position of the focused window
    focused_addr=$(echo "$focused" | jq -r '.address')
    firstElement=$(echo "$grouped" | head -n 1)
    lastElement=$(echo "$grouped" | tail -n 1)

    # If we requesting direction is "left" and we are the first element of the group
    # we want to move focus to the previous window (outside of the group)
    if [ "$direction" == "l" ]; then
        if [ "$focused_addr" == "$firstElement" ]; then
            hyprctl dispatch movefocus ${movefocus_direction}
            exit 0
        fi
    fi

    # If we requesting direction is "right" and we are the last element of the group
    # we want to move focus to the next window (outside of the group)
    if [ "$direction" == "r" ]; then
        if [ "$focused_addr" == "$lastElement" ]; then
            hyprctl dispatch movefocus ${movefocus_direction}
            exit 0
        fi
    fi

    hyprctl dispatch changegroupactive ${changegroupactive_direction}
    exit 0
fi

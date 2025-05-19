#!/bin/sh

toggleNotifications () {
    # Extract the first number after >>
    state=$(echo "$1" | cut -d'>' -f3 | cut -d',' -f1)

    if [ "$state" -eq 1 ]; then
        echo "🎥 Screencast started"
        swaync-client --inhibitor-add "xdg-desktop-portal-wlr"
        swaync-client --dnd-on
    else
        echo "🛑 Screencast stopped"
        swaync-client --inhibitor-remove "xdg-desktop-portal-wlr"
        swaync-client --dnd-off
    fi
}

handle() {
  case $1 in
    screencast*) toggleNotifications $1 ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done

#!/usr/bin/env bash

# TODO: Look how to set the keyboard shortcut
# defaults write org.p0deje.Maccy KeyboardShortcuts_popup -string "{"carbonKeyCode":9,"carbonModifiers":768}"
defaults write org.p0deje.Maccy SUEnableAutomaticChecks -bool true
defaults write org.p0deje.Maccy popupPosition -string statusItem
defaults write org.p0deje.Maccy searchMode -string fuzzy
defaults write org.p0deje.Maccy pasteByDefault -bool true

killall Maccy &> /dev/null
open /Applications/Maccy.app
#!/usr/bin/env bash

# Ressources:
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# https://macos-defaults.com/

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder                                                                      #
###############################################################################
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" && killall Finder
# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Allow to move winwows using `Ctrl + Cmd` and dragging any part of the Window
defaults write -g NSWindowShouldDragOnGesture -bool true

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Set the icon size of Dock items
defaults write com.apple.dock "tilesize" -int "48"

###############################################################################
# Keyboards					                                                  #
###############################################################################

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain "KeyRepeat" -int "2"

# Allow keyboard navigation in modal dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

###############################################################################
# Mission control					                                                  #
###############################################################################

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Mission Control
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0


###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Messages" \
	"SystemUIServer" \
	"Terminal" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

echo "For iTerm2, you need to manually
	- Import rose-pine themes from iterm2/colors folder
	- Set the font to JetBrainsMonoNF-Regular 16"

echo "Linking LanchAgents"

ln -sf ~/dotfiles/LaunchAgents/mmangel.CapslockBackspace.plist ~/Library/LaunchAgents/mmangel.CapslockBackspace.plist
ln -sf ~/dotfiles/LaunchAgents/mmangel.noTunes.plist ~/Library/LaunchAgents/mmangel.noTunes.plist
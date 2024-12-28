#!/bin/sh

echo "Starting Mac set up"

. scripts/functions.sh

DOTFILES=$(pwd)

info "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

info "Installing XCode command line tools..."
if
    xcode-select --print-path &
    >/dev/null
then
    success "XCode command line tools already installed."
elif
    xcode-select --install &
    >/dev/null
then
    success "Finished installing XCode command line tools."
else
    error "Failed to install XCode command line tools."
fi

info "Installing Rosetta..."
sudo softwareupdate --install-rosetta --agree-to-license

info "Checking for Oh My Zsh..."
if test ! $(which omz); then
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
    success "Finished installing Oh My Zsh."
else
    success "Oh My Zsh already installed."
fi

info "Checking for Homebrew..."
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Finished installing Homebrew."
else
    success "Homebrew already installed."
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
info "Installing dependencies from Brewfile..."
brew tap homebrew/bundle
brew bundle
success "Finished installing dependencies from Brewfile."
info "Cleaning up Homebrew..."
brew bundle cleanup --force

info "Configuring Symlinks..."
# Removes .zshrc from $HOME (if it exists)
rm -rf $HOME/.zshrc

stowFolder() {
    stow -D $1 --dotfiles
    stow $1 --dotfiles
}

stowFolder zsh
stowFolder aerospace
# Don't use stowFolder because we don't want to delete the existing .config folder
stow config --dotfiles

# Remap Capslock to Esc
# hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}'

# Generate auto-completion
info "Generating auto-completion for gh..."
# gh completion -s zsh >/usr/local/share/zsh/site-functions/_gh

. macos/setup.sh

info "Removing custom scripts..."
. scripts/cleanup-functions.sh

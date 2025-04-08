ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if not already installed
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Workaround for ZSH_CACHE_DIR not being set by zinit
# See https://github.com/zdharma-continuum/zinit/pull/708

# Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
fi

# Create "$ZSH_CACHE_DIR/completions" directory
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && command mkdir -p "$ZSH_CACHE_DIR/completions"
# Add "$ZSH_CACHE_DIR/completions" diretory to fpath
[[ -z ${fpath[(re)$ZSH_CACHE_DIR/completions]} ]] && fpath=( "$ZSH_CACHE_DIR/completions" "${fpath[@]}" )

source "${ZINIT_HOME}/zinit.zsh"

# Load completion
# IMPORTANT:
# Order matters here
# 1. First load compinit
# 2. Then load fzf-tab
# 3. Then other plugins which wrap widget
#
# See https://github.com/Aloxaf/fzf-tab/blob/01dad759c4466600b639b442ca24aebd5178e799/README.md#install
autoload -U compinit && compinit

# Add in zsh plugins
# IMPORTANT: If your plugins rely on Homebrew installed packages,
# add then in the next plugins section (after Homebrew is set up)
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Add snippets
zinit snippet OMZP::command-not-found
# Allow ..., ...., navigation
zinit snippet OMZL::directories.zsh

###############
# Keybindings #
###############

# Use emacs keybindings
bindkey -e
# Alt + v - Show key bindings (useful for debugging)
bindkey '^[v' .describe-key-briefly
# Ctrl + Right - Move cursor forward by word
bindkey "^[[1;5C" forward-word
# Ctrl + Left - Move cursor backward by word
bindkey "^[[1;5D" backward-word
# Search history based on current input
bindkey "^[[A" history-beginning-search-backward  # Up
bindkey "^[OA" history-beginning-search-backward  # Up
bindkey "^[[B" history-beginning-search-forward   # Down
bindkey "^[OB" history-beginning-search-forward   # Down
bindkey "^p" history-beginning-search-backward    # Ctrl + p
bindkey "^n" history-beginning-search-forward     # Ctrl + n
bindkey '^w' backward-kill-word
# Move cursor to the beginning of the line
bindkey '^[[H' beginning-of-line        # Home
# Move cursor to the end of the line
bindkey '^[[F' end-of-line              # End

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory            # Append history to the history file (no overwriting)
setopt sharehistory             # Share history between all sessions
setopt incappendhistory         # Immediately append history to the history file, not just on exit
setopt hist_ignore_space        # Ignore commands that start with a space
setopt hist_ignore_all_dups     # Ignore duplicate commands
setopt hist_save_no_dups        # Don't save duplicate commands
setopt hist_ignore_dups         # Don't show duplicate commands in history
setopt hist_find_no_dups        # Don't show duplicate commands in history when searching

# Completion styling
# Case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# Display a preview of the selected directory in fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias la='ls -a'
alias vim='nvim'
alias lg='lazygit'

# Make dotnet-install.sh available in the PATH
DOTNET_INSTALL_SCRIPT_DIR="$HOME/Tools/dotnet-install"
if [ ! -d $DOTNET_INSTALL_SCRIPT_DIR ]; then
    mkdir -p $DOTNET_INSTALL_SCRIPT_DIR

    wget -O $DOTNET_INSTALL_SCRIPT_DIR/dotnet-install.sh \
        https://dot.net/v1/dotnet-install.sh
    chmod +x $DOTNET_INSTALL_SCRIPT_DIR/dotnet-install.sh

    echo "Linking dotnet-install.sh to /usr/local/bin/dotnet-install"
    sudo ln -s $DOTNET_INSTALL_SCRIPT_DIR/dotnet-install.sh /usr/local/bin/dotnet-install
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# Dotnet
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Created by `pipx` on 2025-04-04 09:11:41
export PATH="$PATH:/home/mmangel/.local/bin"
# Add user bin directory to PATH
export PATH="$PATH:$HOME/.local/bin"
# Make nvim available
# Installed using https://github.com/neovim/neovim/blob/master/INSTALL.md#pre-built-archives-2
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export EDITOR=nvim
export FORCE_WEBSHARPERSTANDALONE=true

# Install fzf via Git - https://github.com/junegunn/fzf#using-git
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fnm
FNM_PATH="/home/mmangel/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mmangel/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(starship init zsh)"

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
. "$HOME/.cargo/env"

# ~/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# More plugins relying on Homebrew installed packages
# We need Homebrew to be configured, and also other installed tools like pyenv, etc.
# zinit snippet OMZP::gh
# zinit snippet OMZP::fnm
# zinit snippet OMZP::pyenv
# zinit snippet OMZP::poetry
# zinit snippet OMZP::brew

# Should be at the end of the file
zinit cdreplay -q

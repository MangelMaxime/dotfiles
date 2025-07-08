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
zinit ice depth=1

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
zinit light jeffreytse/zsh-vi-mode

# Add snippets
zinit snippet OMZP::command-not-found
# Allow ..., ...., navigation
zinit snippet OMZL::directories.zsh

###############
# Keybindings #
###############

# Use vim keybindings
bindkey -v
# Alt + v - Show key bindings (useful for debugging)
bindkey '^[v' .describe-key-briefly
# Ctrl + Right - Move cursor forward by word
bindkey "^[[1;5C" forward-word
# Ctrl + Left - Move cursor backward by word
bindkey "^[[1;5D" backward-word

# Search history based on current input
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search      # Up
bindkey "^[OA" up-line-or-beginning-search      # Up
bindkey "^p" up-line-or-beginning-search        # Ctrl + p

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[B" down-line-or-beginning-search    # Down
bindkey "^[OB" down-line-or-beginning-search    # Down
bindkey "^n" down-line-or-beginning-search      # Ctrl + n

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

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Should be moved to a separate script to not impact the zsh startup time
# Install Homebrew if not installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

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

# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet

# Use polling file watcher for .NET Core applications avoid issues with inotify limits on Linux
# export DOTNET_USE_POLLING_FILE_WATCHER=1

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
# eval "$(pyenv virtualenv-init -)"

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
export TERMINAL=kitty

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

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
# . "$HOME/.cargo/env"

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
zinit snippet OMZP::volta

if [ -f "$HOME/.personal.zsh" ]; then
    source $HOME/.personal.zsh
else
    echo "Missing $HOME/.personal.zsh"
fi

# Should be at the end of the file
zinit cdreplay -q

# export PATH="/home/mmangel/.dsm:$PATH"
# eval "`dsm env zsh`"

# # dsm
# if ! command -v dsm &> /dev/null
# then
#     echo "Dsm not found, installing..."
#     /bin/bash -c "$(curl -fsSL https://dsm-vm.vercel.app/install.sh | bash --skip-shell)"
# fi

# Copy and adapt this function in .personal.zsh
# Make it easy to setup monitor after a restart
# function monitor_setup () {
#     xrandr --output DP-1-2 --mode 2560x1440 --rate 143.97 --primary --pos 0x0
#     xrandr --output DP-3 --off
#     xrandr --output DP-3 --mode 1920x1080 --rate 74.97 --pos 2560x0
#     i3-msg focus output DP-1-2 > /dev/null
# }

# dsm
export PATH="/home/mmangel/.dsm:$PATH"
eval "`dsm env zsh`"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/mmangel/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/mmangel/.dart-cli-completion/zsh-config.zsh ]] && . /home/mmangel/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export PATH="/home/mmangel/dotfiles/scripts:$PATH"

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

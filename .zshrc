# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download zinit if it is not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# source and load zinit
source "${ZINIT_HOME}/zinit.zsh"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BUNDLE_FILE="~/.config/homebrew/Brewfile"
export HOMEBREW_NO_ENV_HINTS=true

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab-complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'

# aliases
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls -lah'
alias ~='cd ~'

# git
alias gs='git status'
alias gp='git pull'

# configuration
alias vim='nvim'
alias zshconfig='nvim ~/.zshconfig'
alias update='./update.sh' 

# personal 
alias app='cd ~/code/github.com/hedge-ops/app/'
alias dev='app && nvim'
alias wv='cd ~/vaults/work'
alias work='aerospace move-node-to-workspace P && aerospace workspace P && wv && nvim dashboard.md'
alias people='cd ~/people'
alias dotfiles='cd ~/dotfiles'
alias j='just'
alias lg='lazygit'

# ai
alias chat='ollama run deepseek-r1:7b'

# secrets, see template for details
[ -f "$HOME/.env" ] && source "$HOME/.env"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Bacon
export BACON_CONFIG="$HOME/.config/bacon/prefs.toml" 

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# NeoVim is Editor
export EDITOR=nvim

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

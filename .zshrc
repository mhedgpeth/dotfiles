# Define Oh-My-Zsh location
export ZSH="$HOME/.oh-my-zsh"

# Configure theme and plugins
ZSH_THEME="eastwood"
plugins=(git)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# secrets, see template for details
[ -f "$HOME/.env" ] && source "$HOME/.env"

# homebrew
# allows for `brew bundle install` to be run anywhere
export HOMEBREW_BUNDLE_FILE="~/.config/homebrew/Brewfile"
export HOMEBREW_NO_ENV_HINTS=true

# aliases
alias config='/usr/bin/git --git-dir=/Users/michaelhedgpeth/.cfg/ --work-tree=/Users/michaelhedgpeth'
alias cda='cd ~/code/github.com/hedge-ops/app/'
alias dev='cda && nvim'
alias learn='cd ~/code/github.com/mhedgpeth/learning/ && nvim'
alias j='just'
alias lg='lazygit'
alias deepseek='ollama run deepseek-r1:7b'

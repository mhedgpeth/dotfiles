# Define Oh-My-Zsh location
export ZSH="$HOME/.oh-my-zsh"

# Configure plugins
plugins=(
  git ## included
  brew ## included
  z ## included
  zsh-autosuggestions # https://github.com/zsh-users/zsh-autosuggestions
  zsh-autocomplete # https://github.com/marlonrichert/zsh-autocomplete
  zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting
  history-substring-search # included
  macos ## included  
  fzf ## included
  )

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# secrets, see template for details
[ -f "$HOME/.env" ] && source "$HOME/.env"

# homebrew
# allows for `brew bundle install` to be run anywhere
export HOMEBREW_BUNDLE_FILE="~/.config/homebrew/Brewfile"
export HOMEBREW_NO_ENV_HINTS=true

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
alias reload='source ~./.zshconfig'
alias update='./setup.sh' 

# personal 
alias app='cd ~/code/github.com/hedge-ops/app/'
alias dev='app && nvim'
alias learning='cd ~/code/github.com/mhedgpeth/learning/ '
alias learn='learning && nvim'
alias people='cd ~/people'
alias j='just'
alias lg='lazygit'

# ai
alias chat='ollama run deepseek-r1:7b'

# starship prompt
eval "$(starship init zsh)"

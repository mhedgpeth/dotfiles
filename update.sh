CURRENT_DIR=$(pwd)

echo Ensuring brew is up to date

brew bundle install

echo Removing brew packages no longer needed

brew bundle cleanup

echo Ensuring zsh plugins are installed and up to date

plugins=(
  "zsh-users/zsh-autosuggestions"
  "marlonrichert/zsh-autocomplete"
  "zsh-users/zsh-syntax-highlighting"
)

for plugin in "${plugins[@]}"; do
  name=$(echo $plugin | cut -d'/' -f2)
  if [ ! -d ~/.oh-my-zsh/plugins/$name ]; then
    gh repo clone $plugin ~/.oh-my-zsh/plugins/$name
  else
    cd ~/.oh-my-zsh/plugins/$name && git pull
    cd "$CURRENT_DIR"
  fi
done

echo Linking ~./people to app data directory
if [ ! -d "$HOME/Library/Application Support/io.people-work" ]; then
  mkdir -p "$HOME/Library/Application Support/io.people-work"
  echo "Created io.people-work directory"
fi

# Create the symlink if it doesn't exist
if [ ! -L "$HOME/.people" ]; then
  ln -s "$HOME/Library/Application Support/io.people-work" "$HOME/people"
  echo "Created symlink to ~/.people"
fi

echo Setting up AI

ollama pull deepseek-r1:7b

echo Ensuring settings are linked properly

cd ~/dotfiles
stow . --adopt
cd "$CURRENT_DIR"

echo Done!

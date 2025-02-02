CURRENT_DIR=$(pwd)

echo Ensuring brew is up to date

export HOMEBREW_BUNDLE_FILE="~/dotfiles/.config/homebrew/Brewfile"

brew bundle install

echo Removing brew packages no longer needed

brew bundle cleanup --force

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

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Define files and directories to link
files_to_link=(
  ".zshrc"
  "update.sh"
)

config_dirs_to_link=(
  "nvim"
  "homebrew"
  "ghostty"
  "git"
  "starship"
)

# Link individual files
for file in "${files_to_link[@]}"; do
  if [ ! -L ~/"$file" ]; then
    ln -s ~/dotfiles/"$file" ~/"$file"
    echo "Created symlink for $file"
  fi
done

# Link .config directories
for dir in "${config_dirs_to_link[@]}"; do
  if [ ! -L ~/.config/"$dir" ]; then
    ln -s ~/dotfiles/.config/"$dir" ~/.config/"$dir"
    echo "Created symlink for .config/$dir"
  fi
done

cd "$CURRENT_DIR"

echo Done!

CURRENT_DIR=$(pwd)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

echo "${GREEN}Checking for Apple Software updates${RESET}"

softwareupdate -i -a

echo "${GREEN}Ensuring brew is up to date${RESET}"

export HOMEBREW_BUNDLE_FILE="~/dotfiles/.config/homebrew/Brewfile"

brew bundle install

echo "${GREEN}Removing brew packages no longer needed${RESET}"

brew bundle cleanup --force

echo "${GREEN}Linking ~./people to app data directory${RESET}"
if [ ! -d "$HOME/Library/Application Support/io.people-work" ]; then
  mkdir -p "$HOME/Library/Application Support/io.people-work"
  echo "${BLUE}Created io.people-work directory${RESET}"
fi

# Create the symlink if it doesn't exist
if [ ! -L "$HOME/people" ]; then
  ln -s "$HOME/Library/Application Support/io.people-work" "$HOME/people"
  echo "${BLUE}Created symlink to ~/people${RESET}"
fi

echo "${GREEN}Setting up AI${RESET}"

ollama pull deepseek-r1:7b

echo "${GREEN}Ensuring settings are linked properly${RESET}"

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
    echo "${BLUE}Created symlink for $file${RESET}"
  fi
done

# Link .config directories
for dir in "${config_dirs_to_link[@]}"; do
  if [ ! -L ~/.config/"$dir" ]; then
    ln -s ~/dotfiles/.config/"$dir" ~/.config/"$dir"
    echo "${BLUE}Created symlink for .config/$dir${RESET}"
  fi
done

cd "$CURRENT_DIR"

echo "${GREEN}Done!${RESET}"

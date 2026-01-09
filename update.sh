set -euo pipefail

CURRENT_DIR=$(pwd)
# RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

echo "${GREEN}Checking for Apple Software updates${RESET}"

softwareupdate -i -a

echo "${GREEN}Ensuring brew is up to date${RESET}"

export HOMEBREW_BUNDLE_FILE="$HOME/dotfiles/.config/homebrew/Brewfile"

brew bundle install

echo "${GREEN}Removing brew packages no longer needed${RESET}"

brew bundle cleanup --force

# Check if ~/.cargo directory exists
if [ ! -d "$HOME/.cargo" ]; then
  echo "${BLUE}Cargo directory not found. Installing Rust...${RESET}"
  # Run rustup-init
  rustup-init
fi

echo "${GREEN}Ensuring rust toolchain is up to date${RESET}"

rustup install stable

echo "${GREEN}Ensuring required cargo packages are installed${RESET}"

# Check if mdbook-admonish is installed
if ! cargo install --list | grep -q "^mdbook-admonish"; then
  echo "${BLUE}Installing mdbook-admonish...${RESET}"
  cargo install --locked mdbook-admonish
else
  echo "${GREEN}mdbook-admonish is already installed${RESET}"
fi

# Check if semantic-release-cargo is installed
if ! cargo install --list | grep -q "^semantic-release-cargo"; then
  echo "${BLUE}Installing semantic-release-cargo...${RESET}"
  cargo install --locked semantic-release-cargo
else
  echo "${GREEN}semantic-release-cargo is already installed${RESET}"
fi

echo "${GREEN}Ensuring yazi flavors are installed${RESET}"

ya pkg add yazi-rs/flavors:catppuccin-frappe

echo "${GREEN}Ensuring repositories are cloned${RESET}"

# Function to create directory if it doesn't exist
create_directory() {
  if [ ! -d "$1" ]; then
    echo "${BLUE}Creating directory: $1${RESET}"
    mkdir -p "$1"
  fi
}

# Function to clone repository if it doesn't exist
clone_if_not_exists() {
  local repo_path="$1"
  local repo_url="$2"

  if [ ! -d "$repo_path" ]; then
    echo "${BLUE}Cloning repository: $repo_url${RESET}"
    gh repo clone "$repo_url" "$repo_path"
  else
    echo "${GREEN}Repository already exists: $repo_path${GREEN}"
  fi
}

# Base directory for code repositories
CODE_DIR="$HOME/code/github.com"

# Create base directory
create_directory "$CODE_DIR"

# Change to code directory
cd "$CODE_DIR" || {
  echo "Error: Could not change to directory $CODE_DIR"
  exit 1
}

# List of repositories to clone
repositories=(
  "hedge-ops/app"
  "hedge-ops/product-website"
  "hedge-ops/company-website"
  "hedge-ops/prototyping"
  "redbadger/crux"
  "mhedgpeth/personal-vault"
  "mhedgpeth/work-vault"
)

# Create necessary parent directories and clone repositories
for repo_url in "${repositories[@]}"; do
  repo_path="$CODE_DIR/$repo_url"
  parent_dir=$(dirname "$repo_path")

  # Create parent directory
  create_directory "$parent_dir"

  # Clone repository if it doesn't exist
  clone_if_not_exists "$repo_path" "$repo_url"
done

echo "${GREEN}Setting up vaults...${RESET}"

VAULT_DIR="$HOME/vaults"
create_directory "$VAULT_DIR"
if [ ! -L "$VAULT_DIR/work" ]; then
  ln -s "$CODE_DIR/mhedgpeth/work-vault" "$VAULT_DIR/work"
  echo "${BLUE}Linked work vault${RESET}"
fi

if [ ! -L "$VAULT_DIR/personal" ]; then
  ln -s "$CODE_DIR/mhedgpeth/personal-vault" "$VAULT_DIR/personal"
  echo "${BLUE}Linked personal vault${RESET}"
fi

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

echo "${GREEN}Ensuring settings are linked properly${RESET}"

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Define files and directories to link
files_to_link=(
  ".zshrc"
  "update.sh"
  ".config/yazi/theme.toml"
  ".config/yazi/keymap.toml"
  ".config/yazi/yazi.toml"
)

config_dirs_to_link=(
  "aerospace"
  "bacon"
  "ghostty"
  "git"
  "homebrew"
  "leader-key"
  "nvim"
  "starship"
  "zed"
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

cd "$CURRENT_DIR" || exit

echo "${GREEN}Done!${RESET}"

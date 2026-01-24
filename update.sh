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

echo "${GREEN}Upgrading outdated packages${RESET}"

brew upgrade

echo "${GREEN}Removing brew packages no longer needed${RESET}"

brew bundle cleanup --force

echo "${GREEN}Ensuring colima is running${RESET}"
if command -v colima &>/dev/null; then
  if ! colima status &>/dev/null; then
    echo "${BLUE}Starting colima...${RESET}"
    colima start
  fi
  brew services start colima 2>/dev/null || true
fi

echo "${GREEN}Ensuring bv (beads viewer) is installed${RESET}"
if ! command -v bv &>/dev/null; then
  echo "${BLUE}Installing bv...${RESET}"
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
else
  echo "${GREEN}bv is already installed${RESET}"
fi

echo "${GREEN}Ensuring yazi flavors are installed${RESET}"
ya pkg add yazi-rs/flavors:catppuccin-frappe || true

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
  "hedge-ops/people"
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

# Create ~/.claude directory if it doesn't exist
mkdir -p ~/.claude

# Define files and directories to link
files_to_link=(
  ".zshrc"
  "update.sh"
  ".config/yazi/theme.toml"
  ".config/yazi/keymap.toml"
  ".config/yazi/yazi.toml"
  ".config/deskflow/deskflow.conf"
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

# Link individual files (force recreates broken/wrong symlinks)
for file in "${files_to_link[@]}"; do
  # Create parent directory if needed
  parent_dir=$(dirname ~/"$file")
  mkdir -p "$parent_dir"
  ln -sf ~/dotfiles/"$file" ~/"$file"
done
echo "${GREEN}Linked individual files${RESET}"

# Link .config directories (force recreates broken/wrong symlinks)
for dir in "${config_dirs_to_link[@]}"; do
  ln -sfn ~/dotfiles/.config/"$dir" ~/.config/"$dir"
done
echo "${GREEN}Linked .config directories${RESET}"

# Link Claude Code settings and commands
if [ -f ~/dotfiles/.config/claude/settings.json ]; then
  ln -sf ~/dotfiles/.config/claude/settings.json ~/.claude/settings.json
fi
if [ -d ~/dotfiles/.config/claude/commands ]; then
  ln -sfn ~/dotfiles/.config/claude/commands ~/.claude/commands
fi
echo "${GREEN}Linked Claude Code config${RESET}"

echo "${GREEN}Starting Deskflow (if not running)${RESET}"
if pgrep -f "Deskflow" > /dev/null; then
  echo "${GREEN}Deskflow is already running${RESET}"
else
  open -a Deskflow
  echo "${BLUE}Started Deskflow${RESET}"
fi

echo "${GREEN}Done!${RESET}"
cd "$CURRENT_DIR" || exit

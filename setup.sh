RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

echo "${GREEN}Ensuring Homebrew is installed${GREEN}"
if ! command -v brew &>/dev/null; then
  echo "${BLUE}Homebrew not found. Installing Homebrew...${RESET}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>/Users/anniehedgpeth/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/anniehedgpeth/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "${GREEN}Homebrew is already installed.${RESET}"
fi

echo "${GREEN}Ensuring GitHub (gh) is installed${RESET}"
brew install gh

echo "${GREEN}Ensuring GitHub is Authenticated${RESET}"
gh auth login

echo "${GREEN}Cloning dotfiles repo${RESET}"
gh repo clone mhedgpeth/dotfiles

echo "${GREEN}Complete! Now go to ~/dotfiles and run update.sh${RESET}"

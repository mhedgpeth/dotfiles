if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>/Users/anniehedgpeth/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/anniehedgpeth/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

echo "Installing GH"
brew install gh

echo "Logging into GH"
gh auth login

gh repo clone mhedgpeth/dotfiles

#!/bin/bash
set -euo pipefail

echo "Configuring macOS defaults..."

# 24-hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Mission Control: group windows by application
defaults write com.apple.dock expose-group-apps -bool true

# Xcode command line tools (if Xcode is installed)
if [[ -d "/Applications/Xcode.app" ]]; then
  echo "Setting Xcode developer directory..."
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
fi

# Restart Dock to apply changes
killall Dock || true

echo "macOS defaults configured."

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

echo "${GREEN}Configuring...${RESET}"

echo "${GREEN}Configuring Operating System${RESET}"

# 24-hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Dock auto-hide
defaults write com.apple.dock autohide -bool true

# Trackpad speed (range from 0 to 3.0)
defaults write -g com.apple.trackpad.scaling -float 2.0

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Show volume in menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true

echo "${GREEN}Configuration complete. Restart to ensure all settings are in effect.${RESET}"

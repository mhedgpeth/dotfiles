# Dotfiles management
# Bootstrap: brew/scoop install aqua && aqua install

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Show available commands
default:
    @just --list

# Install global packages via native package manager
install:
    @just _install-{{os()}}

_install-macos:
    brew bundle --file=packages/Brewfile

_install-windows:
    @echo "Installing packages via scoop..."
    @if (Test-Path packages/scoopfile.json) { scoop import packages/scoopfile.json }

_install-linux:
    @echo "Installing packages via pacman/yay..."
    @if [ -f packages/archlinux.txt ]; then yay -S --needed - < packages/archlinux.txt; fi

# Initialize chezmoi (run once after clone)
init:
    chezmoi init --source=home

# Apply dotfiles via chezmoi
apply:
    chezmoi apply --source=home

# Preview what chezmoi would change
diff:
    chezmoi diff --source=home

# Add a file to chezmoi management
add file:
    chezmoi add --source=home {{file}}

# Upgrade installed packages
upgrade:
    @just _upgrade-{{os()}}

_upgrade-macos:
    brew upgrade

_upgrade-windows:
    scoop update *

_upgrade-linux:
    yay -Syu

# Remove packages not in manifest
cleanup:
    @just _cleanup-{{os()}}

_cleanup-macos:
    brew bundle cleanup --force --file=packages/Brewfile

_cleanup-windows:
    @echo "Scoop doesn't have automatic cleanup of unlisted packages"

_cleanup-linux:
    @echo "Manual cleanup: pacman -Qdtq | pacman -Rns -"

# Full setup: init + install packages + apply dotfiles (first time)
setup: init install apply

# Regular dev workflow: install, upgrade, cleanup, apply
dev: install upgrade cleanup apply

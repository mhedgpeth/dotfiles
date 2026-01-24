# Dotfiles management
# Bootstrap: brew/scoop install aqua && aqua install

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Show available commands
default:
    @just --list

# Install global packages via native package manager
install:
    @echo '{{ style("command") }}install:{{ NORMAL }}'
    @just _install-{{os()}}

_install-macos:
    brew bundle --file=packages/Brewfile

_install-windows:
    @if (Test-Path packages/scoopfile.json) { scoop import packages/scoopfile.json }

_install-linux:
    @if [ -f packages/archlinux.txt ]; then yay -S --needed - < packages/archlinux.txt; fi

# Initialize chezmoi + extras (run once after clone)
init:
    @echo '{{ style("command") }}init:{{ NORMAL }}'
    chezmoi init --source=home
    -ya pkg add yazi-rs/flavors:catppuccin-frappe

# Apply dotfiles via chezmoi
apply:
    @echo '{{ style("command") }}apply:{{ NORMAL }}'
    chezmoi apply --source=home

# Preview what chezmoi would change
diff:
    @echo '{{ style("command") }}diff:{{ NORMAL }}'
    chezmoi diff --source=home

# Add a file to chezmoi management
add file:
    chezmoi add --source=home {{file}}

# Upgrade installed packages
upgrade:
    @echo '{{ style("command") }}upgrade:{{ NORMAL }}'
    @just _upgrade-{{os()}}

_upgrade-macos:
    brew upgrade

_upgrade-windows:
    scoop update *

_upgrade-linux:
    yay -Syu

# Remove packages not in manifest
cleanup:
    @echo '{{ style("command") }}cleanup:{{ NORMAL }}'
    @just _cleanup-{{os()}}

_cleanup-macos:
    brew bundle cleanup --force --file=packages/Brewfile

_cleanup-windows:
    @echo "Scoop doesn't have automatic cleanup of unlisted packages"

_cleanup-linux:
    @echo "Manual cleanup: pacman -Qdtq | pacman -Rns -"

# OS-specific configuration (services, apps)
configure:
    @echo '{{ style("command") }}configure:{{ NORMAL }}'
    @just _configure-{{os()}}

_configure-macos: _colima-macos _deskflow-macos

_configure-windows: _deskflow-windows

_configure-linux: _deskflow-linux

_colima-macos:
    @echo '{{ style("command") }}colima:{{ NORMAL }}'
    @./scripts/configure-colima.sh

_deskflow-macos:
    @echo '{{ style("command") }}deskflow:{{ NORMAL }}'
    @./scripts/configure-deskflow.sh

_deskflow-windows:
    @echo '{{ style("command") }}deskflow:{{ NORMAL }}'
    @powershell -ExecutionPolicy Bypass -File scripts/configure-deskflow.ps1

_deskflow-linux:
    @echo '{{ style("command") }}deskflow:{{ NORMAL }}'
    @./scripts/configure-deskflow.sh

# Full setup: init + install packages + apply dotfiles (first time)
setup: init install apply

# Regular dev workflow: install, upgrade, cleanup, apply, configure
dev: install upgrade cleanup apply configure

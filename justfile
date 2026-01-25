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
    scoop import packages/scoopfile.json
    winget import -i packages/winget.json --ignore-unavailable --accept-source-agreements --accept-package-agreements

_install-linux:
    yay -S --needed - < packages/archlinux.txt

# Initialize chezmoi (run once after clone)
init:
    @echo '{{ style("command") }}init:{{ NORMAL }}'
    chezmoi init --source=home
    @just _init-{{os()}}

_init-macos:
    @true

_init-windows:
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add versions

_init-linux:
    @true

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

# One-time finishing touches (after packages installed)
finish:
    @echo '{{ style("command") }}finish:{{ NORMAL }}'
    -ya pkg add yazi-rs/flavors:catppuccin-frappe

# Full setup: init + install + apply + finish (first time)
setup: init install apply finish

# Regular update workflow: install, upgrade, cleanup, apply, configure
update: install upgrade cleanup apply configure

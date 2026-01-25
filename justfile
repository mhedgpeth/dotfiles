# Dotfiles management
# Bootstrap: brew/scoop install aqua && aqua install

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Default: keep everything up to date
default: update

# First-time setup: init then update
init: _init update

# Keep everything up to date (run anytime)
update: install upgrade cleanup apply repos finish configure

# === Internal recipes ===

# One-time chezmoi and OS setup
_init:
    @echo '{{ style("command") }}init:{{ NORMAL }}'
    chezmoi init --source=home
    @just _init-{{os()}}

_init-macos:
    curl -fsSL https://claude.ai/install.sh | bash

_init-windows:
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add versions
    powershell -Command "irm https://claude.ai/install.ps1 | iex"

_init-linux:
    curl -fsSL https://claude.ai/install.sh | bash

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

# Apply dotfiles via chezmoi
apply:
    @echo '{{ style("command") }}apply:{{ NORMAL }}'
    chezmoi apply --source=home

# Clone/update repositories via ghq
repos:
    @echo '{{ style("command") }}repos:{{ NORMAL }}'
    ghq get hedge-ops/people
    ghq get redbadger/crux
    ghq get steveyegge/beads
    ghq get mhedgpeth/facet-generate

# One-time finishing touches (idempotent)
finish:
    @echo '{{ style("command") }}finish:{{ NORMAL }}'
    -ya pkg add yazi-rs/flavors:catppuccin-frappe

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

# === Utility recipes ===

# Preview what chezmoi would change
diff:
    @echo '{{ style("command") }}diff:{{ NORMAL }}'
    chezmoi diff --source=home

# Add a file to chezmoi management
add file:
    chezmoi add --source=home {{file}}

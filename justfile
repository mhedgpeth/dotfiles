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
    @just _rustup-install
    curl -fsSL https://claude.ai/install.sh | bash

_init-windows:
    Write-Host "Enabling Developer Mode..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
    Write-Host "Adding scoop buckets..."
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add versions
    just _rustup-install-windows
    Write-Host "Installing Claude Code..."
    powershell -Command "irm https://claude.ai/install.ps1 | iex"

_init-linux:
    @just _rustup-install
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
    chezmoi apply --source=home --force

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
    rustup default stable
    rustup component add rust-analyzer
    -ya pkg add yazi-rs/flavors:catppuccin-frappe

# Install rustup via official installer (creates proper proxy binaries in ~/.cargo/bin)
_rustup-install:
    #!/usr/bin/env bash
    if command -v ~/.cargo/bin/rustup &> /dev/null; then
        echo "rustup already installed via official installer"
    else
        echo "Installing rustup via official installer..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

_rustup-install-windows:
    if (Get-Command "$env:USERPROFILE\.cargo\bin\rustup.exe" -ErrorAction SilentlyContinue) { Write-Host "rustup already installed" } else { Write-Host "Installing rustup..."; $rustupInit = "$env:TEMP\rustup-init.exe"; Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $rustupInit; & $rustupInit -y }

# OS-specific configuration (services, apps)
configure:
    @echo '{{ style("command") }}configure:{{ NORMAL }}'
    @just _configure-{{os()}}

_configure-macos: _colima-macos _macos-defaults

_macos-defaults:
    @./scripts/configure-macos-defaults.sh

_configure-windows:
    if (-not (Get-Module -ListAvailable -Name PSFzf)) { Install-Module -Name PSFzf -Scope CurrentUser -Force }

_configure-linux:
    true

_colima-macos:
    @echo '{{ style("command") }}colima:{{ NORMAL }}'
    @./scripts/configure-colima.sh

# === Utility recipes ===

# Preview what chezmoi would change
diff:
    @echo '{{ style("command") }}diff:{{ NORMAL }}'
    chezmoi diff --source=home

# Add a file to chezmoi management
add file:
    chezmoi add --source=home {{file}}

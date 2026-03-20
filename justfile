# Dotfiles management
# Bootstrap: brew/scoop install aqua && aqua install

set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

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
    Write-Host "Remapping Caps Lock to Backspace..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Value ([byte[]](0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x02,0x00,0x00,0x00, 0x0E,0x00,0x3A,0x00, 0x00,0x00,0x00,0x00)) -Type Binary
    Write-Host "Creating XDG cache directories..."
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cache\direnv" | Out-Null
    Write-Host "Installing winget from GitHub releases..."
    pwsh.exe -ExecutionPolicy Bypass -File scripts/install-winget.ps1
    Write-Host "Adding scoop buckets..."
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add versions
    scoop bucket add java
    just _rustup-install-windows
    Write-Host "Enabling SSH Agent service..."
    Get-Service ssh-agent | Set-Service -StartupType Automatic
    Start-Service ssh-agent
    $sshKey = Get-ChildItem "$env:USERPROFILE\.ssh" -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^id_" -and $_.Extension -ne ".pub" } | Select-Object -First 1
    if ($sshKey) { Write-Host "Adding SSH key: $($sshKey.Name)..."; ssh-add $sshKey.FullName } else { Write-Host "No SSH key found in ~/.ssh - generate one and run: ssh-add ~/.ssh/<key>" }
    Write-Host "Installing Claude Code..."
    irm https://claude.ai/install.ps1 | iex
    @just _docker-windows

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

# Install Docker Desktop directly (winget hangs due to UAC/installer detach)
_docker-windows:
    if (Get-Command "Docker Desktop" -ErrorAction SilentlyContinue) { Write-Host "Docker Desktop already installed" } elseif (Test-Path "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe") { Write-Host "Docker Desktop already installed" } else { Write-Host "Downloading Docker Desktop installer..."; $installer = "$env:TEMP\DockerDesktopInstaller.exe"; Invoke-WebRequest -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -OutFile $installer; Write-Host "Installing Docker Desktop (silent)..."; Start-Process -FilePath $installer -ArgumentList "install","--quiet","--accept-license" -Wait; Remove-Item $installer -ErrorAction SilentlyContinue; Write-Host "Docker Desktop installed. Restart may be required." }

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
    ya pkg list 2>/dev/null | grep -q catppuccin-frappe || ya pkg add yazi-rs/flavors:catppuccin-frappe

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

_configure-macos: _colima-macos _android-sdk-macos _macos-defaults

# Install Android SDK components and Rust cross-compilation targets
_android-sdk-macos:
    @./scripts/install-android-sdk-macos.sh

_macos-defaults:
    @./scripts/configure-macos-defaults.sh

_configure-windows: _gradle-shim-windows _android-sdk-windows
    @echo "Configuring Windows Terminal..."
    pwsh.exe -ExecutionPolicy Bypass -File scripts/configure-windows-terminal.ps1

# Install Android SDK command-line tools and NDK
_android-sdk-windows:
    pwsh.exe -ExecutionPolicy Bypass -File scripts/install-android-sdk.ps1

# Create gradle.exe shim so Rust's Command::new("gradle") can find it
# Scoop only generates .cmd shims for batch-based tools, but Rust needs .exe
_gradle-shim-windows:
    $shimSrc = "$env:USERPROFILE\scoop\apps\scoop\current\supporting\shims\kiennq\shim.exe"; $shimDir = "$env:USERPROFILE\scoop\shims"; $target = "$shimDir\gradle.exe"; if (Test-Path "$shimDir\gradle.cmd") { if (-not (Test-Path $target)) { Write-Host "Creating gradle.exe shim..."; Copy-Item $shimSrc $target; Set-Content "$shimDir\gradle.shim" "path = `"$env:USERPROFILE\scoop\apps\gradle\current\bin\gradle.bat`"" } else { Write-Host "gradle.exe shim already exists" } } else { Write-Host "Gradle not installed via scoop, skipping shim" }

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

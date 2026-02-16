# Setup WSL2 with Arch Linux
# Run as Administrator. Idempotent — safe to re-run.

$ErrorActionPreference = "Stop"

$DistroName = "archlinux"
$Username = "micha"

# --- Phase 1: Ensure WSL is installed ---

$wslInstalled = Get-Command wsl.exe -ErrorAction SilentlyContinue
if (-not $wslInstalled) {
    Write-Host "Installing WSL..."
    wsl --install --no-distribution
    Write-Host ""
    Write-Host "WSL installed. A REBOOT is required before Arch Linux can be installed."
    Write-Host "After rebooting, run this script again to continue setup."
    exit 0
}

# --- Phase 2: Install Arch Linux ---

$existing = wsl --list --quiet 2>$null | Where-Object { $_ -match $DistroName }
if ($existing) {
    Write-Host "WSL distro '$DistroName' already installed — skipping install"
} else {
    Write-Host "Installing Arch Linux WSL..."
    wsl --install $DistroName --no-launch

    # Workaround: --no-launch can fail to register (microsoft/WSL#10646)
    $registered = wsl --list --quiet 2>$null | Where-Object { $_ -match $DistroName }
    if (-not $registered) {
        Write-Host "  Retrying with interactive launch..."
        $proc = Start-Process -FilePath "wsl.exe" -ArgumentList "--install", $DistroName -PassThru
        Start-Sleep -Seconds 10
        wsl --terminate $DistroName 2>$null
        if (-not $proc.HasExited) { $proc.Kill() }
    }
}

# --- Phase 3: Configure the distro ---

function Invoke-ArchRoot {
    param([string]$Command)
    wsl -d $DistroName -u root -- bash -c $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed (exit $LASTEXITCODE): $Command"
    }
}

Write-Host "Configuring Arch Linux..."

# Run official first-setup script if present
Invoke-ArchRoot "test -f /usr/lib/wsl/first-setup.sh && /usr/lib/wsl/first-setup.sh || true"

# Initialize pacman keyring
Write-Host "  Initializing pacman keyring..."
Invoke-ArchRoot "pacman-key --init && pacman-key --populate archlinux"

# Full system update
Write-Host "  Running system update..."
Invoke-ArchRoot "pacman -Sy --noconfirm archlinux-keyring && pacman -Su --noconfirm"

# Install essentials
Write-Host "  Installing base-devel and essentials..."
Invoke-ArchRoot "pacman -S --needed --noconfirm base-devel git curl jq openssh openssl pkg-config"

# Create user (idempotent)
Write-Host "  Setting up user '$Username'..."
Invoke-ArchRoot "id -u $Username &>/dev/null || useradd -m -G wheel -s /bin/bash $Username"
Invoke-ArchRoot "echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel && chmod 440 /etc/sudoers.d/wheel"

# Write wsl.conf (systemd + default user)
Write-Host "  Configuring wsl.conf (systemd + default user)..."
Invoke-ArchRoot @"
cat > /etc/wsl.conf << 'EOF'
[boot]
systemd=true

[user]
default=$Username
EOF
"@

# Set as default distro
Write-Host "  Setting $DistroName as default WSL distro..."
wsl --set-default $DistroName

# Restart to pick up wsl.conf changes
Write-Host "  Restarting WSL to apply configuration..."
wsl --terminate $DistroName

Write-Host "WSL Arch Linux setup complete."
Write-Host "  Run 'wsl' to enter your Arch Linux environment."

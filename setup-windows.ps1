#Requires -RunAsAdministrator

# Dotfiles symlink script for Windows

$ErrorActionPreference = "Stop"

$dotfilesPath = "$env:USERPROFILE\dotfiles\.config"

# Define where each config should be symlinked
$links = @{
    "nvim"     = "$env:LOCALAPPDATA\nvim"
    "yazi"     = "$env:APPDATA\yazi\config"
    "zed"      = "$env:APPDATA\Zed"
    "bacon"    = "$env:APPDATA\bacon"
}

Write-Host "Symlinking dotfiles from $dotfilesPath" -ForegroundColor Cyan
Write-Host ""

foreach ($config in $links.Keys) {
    $source = Join-Path $dotfilesPath $config
    $target = $links[$config]
    
    Write-Host "=> $config" -ForegroundColor Yellow
    
    # Check if source exists
    if (-not (Test-Path $source)) {
        Write-Host "  Source not found, skipping" -ForegroundColor Gray
        continue
    }
    
    # Backup existing config
    if (Test-Path $target) {
        $backup = "$target.backup"
        Write-Host "  Backing up existing config to $backup" -ForegroundColor Gray
        if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
        Move-Item $target $backup -Force
    }
    
    # Create parent directory if needed
    $parent = Split-Path $target -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    
    # Create symlink
    New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
    Write-Host "  [OK] Linked to $target" -ForegroundColor Green
}

# Handle starship separately (it's a file, not a directory)
$starshipSource = Join-Path $dotfilesPath "starship.toml"
if (Test-Path $starshipSource) {
    $starshipTarget = "$env:USERPROFILE\.config\starship.toml"
    
    Write-Host "=> starship" -ForegroundColor Yellow
    
    $parent = Split-Path $starshipTarget -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    
    if (Test-Path $starshipTarget) {
        $backup = "$starshipTarget.backup"
        if (Test-Path $backup) { Remove-Item $backup -Force }
        Move-Item $starshipTarget $backup -Force
    }
    
    New-Item -ItemType SymbolicLink -Path $starshipTarget -Target $starshipSource -Force | Out-Null
    Write-Host "  [OK] Linked to $starshipTarget" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done! Restart your applications to use the new configs." -ForegroundColor Cyan
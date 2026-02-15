# Configure Windows Terminal settings
# Adds shift+enter keybinding for Claude Code newline support (issue #8208)

$ErrorActionPreference = "Stop"

$settingsPaths = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
)

$settingsFile = $settingsPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $settingsFile) {
    Write-Host "Windows Terminal settings.json not found - skipping"
    exit 0
}

Write-Host "Configuring Windows Terminal: $settingsFile"

$settings = Get-Content $settingsFile -Raw | ConvertFrom-Json

if (-not ($settings.PSObject.Properties.Name -contains "actions")) {
    $settings | Add-Member -NotePropertyName "actions" -NotePropertyValue @()
}

$hasShiftEnter = $settings.actions | Where-Object { $_.keys -eq "shift+enter" }

if ($hasShiftEnter) {
    Write-Host "  shift+enter binding already configured"
    exit 0
}

$newAction = [PSCustomObject]@{
    command = [PSCustomObject]@{
        action = "sendInput"
        input = "`n"
    }
    keys = "shift+enter"
}

$settings.actions = @($settings.actions) + $newAction
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8

Write-Host "  Added shift+enter keybinding for newline"

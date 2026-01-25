# PowerShell Profile
# Equivalent to ~/.zshrc for Windows

# ===== Aliases =====

# Clear
Set-Alias -Name c -Value Clear-Host

# Editors
Set-Alias -Name vim -Value nvim

# Tools
Set-Alias -Name b -Value bacon
Set-Alias -Name j -Value just
Set-Alias -Name lg -Value lazygit

# ===== Functions (for commands with arguments) =====

# Git shortcuts
function gs { git status }
function gp { git pull }

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function ~ { Set-Location ~ }

# Directory shortcuts (adjust paths as needed)
function pw { Set-Location ~/code/github.com/hedge-ops/people }
function df { Set-Location ~/dotfiles }

# eza replacements (if installed via scoop)
function ls { eza -lah --icons --git @args }
function tree { eza --tree --icons @args }

# Use bat for cat (if installed)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Alias -Name cat -Force -ErrorAction SilentlyContinue
    function cat { bat @args }
}

# Yazi with directory change on exit (like the zsh version)
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content $tmp -ErrorAction SilentlyContinue
    if ($cwd -and $cwd -ne $PWD.Path) {
        Set-Location $cwd
    }
    Remove-Item $tmp -ErrorAction SilentlyContinue
}

# ===== Environment =====

# Editor
$env:EDITOR = "nvim"

# Starship config location
$env:STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml"

# Bacon config
$env:BACON_CONFIG = "$HOME/.config/bacon/prefs.toml"

# ===== Shell Integrations =====

# Zoxide (cd replacement)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell --cmd z | Out-String)
}

# Fzf
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    # PSFzf module for better integration
    if (Get-Module -ListAvailable -Name PSFzf) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}

# Starship prompt (must be last)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

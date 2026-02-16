# PowerShell Profile
# Equivalent to ~/.zshrc for Windows
# Works in both Windows PowerShell 5.1 and PowerShell 7+

# ===== Aliases =====

# Clear
Set-Alias -Name c -Value Clear-Host

# Editors
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim
}

# Tools (only if installed)
if (Get-Command bacon -ErrorAction SilentlyContinue) {
    Set-Alias -Name b -Value bacon
}
if (Get-Command just -ErrorAction SilentlyContinue) {
    Set-Alias -Name j -Value just
}
if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    Set-Alias -Name lg -Value lazygit
}

# ===== Functions (for commands with arguments) =====

# Git shortcuts (remove built-in aliases that conflict)
Remove-Item Alias:gp -Force -ErrorAction SilentlyContinue
Remove-Item Alias:gs -Force -ErrorAction SilentlyContinue
Remove-Item Alias:gc -Force -ErrorAction SilentlyContinue
function gs { git status }
function gp { git pull }
function gco { git checkout @args }

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function ~ { Set-Location ~ }

# Directory shortcuts
function pw { Set-Location ~/code/github.com/hedge-ops/people }
function df { Set-Location ~/dotfiles }

# eza (modern ls/tree replacement)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza -lah --icons --git @args }
    function tree { eza --tree --icons @args }
}

# Use bat for cat (if installed)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue
    function cat { bat @args }
}

# Yazi with directory change on exit (like the zsh version)
if (Get-Command yazi -ErrorAction SilentlyContinue) {
    function y {
        $tmp = [System.IO.Path]::GetTempFileName()
        yazi $args --cwd-file="$tmp"
        $cwd = Get-Content $tmp -ErrorAction SilentlyContinue
        if ($cwd -and $cwd -ne $PWD.Path) {
            Set-Location $cwd
        }
        Remove-Item $tmp -ErrorAction SilentlyContinue
    }
}

# ===== Environment =====

# XDG directories (must be set before PATH since aqua uses XDG_DATA_HOME)
$env:XDG_CONFIG_HOME = "$HOME/.config"
$env:XDG_CACHE_HOME = "$HOME/.cache"
$env:XDG_DATA_HOME = "$HOME/.local/share"

# PATH additions (order matters: later entries take priority)
$env:PATH = "$HOME/.cargo/bin;$env:PATH"
$env:PATH = "$env:XDG_DATA_HOME/aquaproj-aqua/bin;$env:PATH"
$env:PATH = "$HOME/.local/bin;$env:PATH"
$env:PATH = "$HOME/scoop/shims;$env:PATH"

# Ensure XDG directories exist (direnv needs these on Windows)
@("$env:XDG_CACHE_HOME/direnv", "$env:XDG_DATA_HOME/direnv") | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
}

# Editor
$env:EDITOR = "nvim"

# Starship config location
$env:STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml"

# Bacon config
$env:BACON_CONFIG = "$HOME/.config/bacon/prefs.toml"

# ===== Shell Integrations =====

# Zoxide (better cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell --cmd z | Out-String)
}

# Fzf (fuzzy finder)
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    if (Get-Module -ListAvailable -Name PSFzf) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}

# Direnv (per-directory env vars)
if (Get-Command direnv -ErrorAction SilentlyContinue) {
    Invoke-Expression (& direnv hook pwsh | Out-String)
}

# Mise (polyglot version manager)
if (Get-Command mise -ErrorAction SilentlyContinue) {
    Invoke-Expression (& mise activate pwsh | Out-String)
}

# Starship prompt (must be last)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}

# PowerShell profile for Windows
# Minimal setup for PeopleWork development

# Initialize starship prompt
Invoke-Expression (&starship init powershell)

# Aliases for Unix-like commands
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name which -Value Get-Command

# Helper to reload profile
function Reload-Profile { . $PROFILE }

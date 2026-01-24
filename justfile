# Dotfiles management with just
# Run `aqua install` once first to get just

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Install aqua-managed tools
install:
    aqua install

# Apply configuration (installs tools and runs comtrya)
apply:
    aqua install
    comtrya apply

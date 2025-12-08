1. Set up Chocolatey

From Administrative PowerShell, Run:
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

And powershell to run scripts:
`Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

2. Set up git

```
choco install git vscode gh
```

Other things I'm installing:
* rust then `cargo install cargo-nextest`
* claude
* nerd-fonts-firacode
* nerd-fonts-jetbrainsmono

from claude:
choco install ripgrep luarocks fd fzf gh github-desktop git delta lazygit wget neovim starship zoxide cloc watchman ffmpeg 7zip jq poppler imagemagick yazi tree firacode firacodenf jetbrainsmono nerd-fonts-meslo ollama rustup.install just terraform tflint doctl kubernetes-cli kustomize pgadmin4 k9s docker-desktop postman ngrok nodejs pnpm bun powertoys anki vscode zed slack googlechrome discord -y

not installed - ghostty (no windows), balenetcher, doctl


3. Clone dotfiles:

```
mkdir dotfiles
```

4. Install Visual Studio: https://visualstudio.microsoft.com/vs/community/
It downloads an exe that you go through.
Select WinUI Development
Select Desktop Development with C++

Install rust on their website: https://rust-lang.org/tools/install/?platform_override=win (after visual studio)

X. Windows Store Apps

- Apple TV
- Apple Music


Studio Brightness Plus Plus: https://github.com/LitteRabbit-37/Studio-Brightness-PlusPlus

4. Chocolatey

export config: choco export packages.config
install config: choco install packages.config -y
update config: choco upgrade packages.config -y

Git:
git config --global user.name "Michael Hedgpeth"
git config --global user.email "your.email@example.com"
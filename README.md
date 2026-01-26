# dotfiles

Configuration for macOS, Windows, and Linux development machines.

## New Machine Setup

### 1. Bootstrap

Install the package manager, aqua, and gh:

**macOS:**

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After Homebrew installs, it displays commands to add `brew` to your PATH. Run
those commands before continuing.

```sh
brew install aqua git gh
```

Then open **App Store** and sign in with your Apple ID (required for `mas` CLI
to install apps during setup).

**Windows** (run PowerShell as Administrator):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install aqua git gh
```

Note: After Scoop installs, you may need to restart your terminal for `scoop`
to be available in PATH.

**Arch Linux:**

```sh
sudo pacman -S aqua git github-cli
```

### 2. Authenticate

```sh
gh auth login
gh auth setup-git    # configures git to use gh for credentials
```

### 3. Clone and Initialize

```sh
cd ~
gh repo clone mhedgpeth/dotfiles dotfiles
cd dotfiles
aqua policy allow
aqua install    # installs just, chezmoi
```

After `aqua install`, add the aqua bin directory to your PATH for this session:

**macOS/Linux:**

```sh
export PATH="$HOME/.local/share/aquaproj-aqua/bin:$PATH"
```

**Windows:**

```powershell
$env:PATH = "$env:LOCALAPPDATA\aquaproj-aqua\bin;$env:PATH"
```

Then run initialization:

```sh
just init       # one-time setup, then runs update
```

Note: You may see a warning about `~/.local/bin` not being in PATH. This is
expected and will resolve once shell configuration is applied.

## Regular Updates

```sh
just    # or `just update` - install, upgrade, cleanup, apply, finish, configure
```

## Reset

**macOS:** See [Apple's guide](https://support.apple.com/en-us/102664)

**Windows:** Settings → System → Recovery → Reset this PC → Remove everything

**Arch Linux:** See [omarchy](https://omarchy.org/) for installation

## Post Setup

### macOS

#### Verify Automation (test on fresh install)

- [ ] App Store apps installed (Kindle, Day One, Todoist, Keymapp, Apple Developer)
- [ ] 24-hour time enabled
- [ ] Dark mode enabled
- [ ] Mission Control groups windows by application
- [ ] Xcode developer directory set (if Xcode installed)

#### XCode

After initial setup, XCode needs to be updated from the App Store and started.
The `just update` command will run `xcode-select` automatically if Xcode is present.

#### Manual Configuration

Set up accounts:

1. Open Passwords, from which you will get credentials.
2. Open Safari and log into the accounts in their associated profiles.
3. Add internet accounts (work, home, family).
4. Open Slack and add accounts to it.

Configure apps:

- Safari → Settings → Tabs → Tab layout: Compact
- Messages → Settings → iMessage → Enable Messages in iCloud
- Photos → Settings → iCloud → iCloud Photos → Optimize Mac Storage
- Music → Settings → General → Automatic Downloads, Download Dolby Atmos, Star Ratings
- Music → Settings → Playback → Lossless Audio → Enable
- Podcasts → Settings → Automatically Download: Off
- Calendar → Settings → Advanced → Time zone support, Show week numbers
- Mail → Settings → Junk Mail → Enable junk mail filtering
- Mail → Settings → Viewing → Summarize Message Previews: Off, Move discarded to Archive

Configure System Settings:

- Control Center → Focus: Always Show, Sounds: Always Show
- Trackpad → Tracking Speed: 8/10
- Printers & Scanners → Add printer

### Windows

#### Visual Studio Workloads

Open Visual Studio Installer, modify your installation, and add these workloads:

- **Desktop development with C++** - required for Rust and nvim-treesitter
- **.NET desktop development** - required for C# development
- **WinUI application development** - required for WinUI 3 apps

### Linux

See [omarchy](https://omarchy.org/) for Arch Linux setup.

TODO: Document post-omarchy configuration

## Issue Tracking

This repo uses [beads](https://github.com/steveyegge/beads) for issue tracking.
Issues are stored on a separate `beads-sync` branch to keep `main` clean.

### Fresh Clone Setup

After cloning, fetch the sync branch and import issues:

```sh
git fetch origin beads-sync
bd sync --no-push
```

### Daily Workflow

```sh
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with remote (run at session start/end)
```

### How It Works

- The daemon auto-commits issue changes to `beads-sync` branch
- Run `bd sync` to push/pull changes with collaborators
- The `main` branch stays clean (code changes only)

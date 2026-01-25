# dotfiles

Configuration for macOS, Windows, and Linux development machines.

## New Machine Setup

### 1. Bootstrap

Install the package manager, aqua, and gh:

**macOS:**

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install aqua git gh
```

**Windows** (run PowerShell as Administrator):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install aqua git gh
```

**Arch Linux:**

```sh
sudo pacman -S aqua git github-cli
```

### 2. Authenticate

```sh
gh auth login
```

### 3. Clone and Initialize

```sh
gh repo clone mhedgpeth/dotfiles ~/dotfiles
cd ~/dotfiles
aqua install    # installs just, chezmoi
just init       # one-time setup, then runs update
```

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

#### XCode

After initial setup, XCode needs to be updated from the App Store and started.
Then run:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

#### App Store Apps

Install these apps from the App Store:

- Amazon Kindle
- Day One
- Todoist
- ZSA Keybindings
- Apple Developer

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

- General → Date & Time → 24-hour time (both settings)
- Appearance → Dark
- Control Center → Focus: Always Show, Sounds: Always Show
- Desktop & Dock → Mission Control → Group windows by application
- Trackpad → Tracking Speed: 8/10
- Printers & Scanners → Add printer

### Windows

#### Visual Studio for Rust

1. Install Visual Studio 2022 with "Desktop development with C++" workload
2. Ensure Windows SDK is included
3. Rust toolchain uses MSVC by default on Windows

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

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

**Windows:**

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

### 3. Clone and Setup

```sh
gh repo clone mhedgpeth/dotfiles ~/dotfiles
cd ~/dotfiles
aqua install    # installs just, chezmoi
just setup      # installs packages, applies dotfiles, clones work repos
```

## Regular Updates

```sh
just update    # install, upgrade, cleanup, apply, configure
```

## Reset Mac

See [this article](https://support.apple.com/en-us/102664)

## XCode

After initial setup, XCode needs to be updated from the App Store and started.

After it is started, run this command to ensure Swift tools are available on
the terminal:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

```

## Secrets

Copy `.env.template` to `~/.env` and add the appropriate values.

## Other AppStore Apps

Install these apps from the App Store:

- Amazon Kindle  
- Day One
- Todoist
- ZSA Keybindings
- Apple Developer

## Manual Configuration

First, set up accounts on the computer:

1. Open Passwords, from which you will get credentials.
2. Open Safari and log into the accounts in their associated profiles.
3. Add internet accounts (work, home, family).
4. Open slack and add accounts to it.

Then, open and configure these apps:

- Safari -> Settings -> Tabs -> Tab layout: Compact
- Messages -> Settings -> iMessage -> Enable Messages in iCloud checked
- Photos -> Settings -> iCloud -> iCloud Photos -> Optimize Mac Storage selected
- Music -> Settings -> General -> Automatic Downloads checked
- Music -> Settings -> General -> Download Dolby Atmos
- Music -> Settings -> General -> Show: -> Star Ratings checked
- Music -> Settings -> Playback -> Lossless Audio -> Enable Lossless Audio checked
- Podcasts -> Settings -> Automatically Download set to off
- Calendar -> Settings -> Advanced -> Turn on time zone support checked
- Calendar -> Settings -> Advanced -> Show week numbers checked
- Mail -> Settings -> Junk Mail -> Junk Mail Behaviors -> Enabled junk mail
  filtering checked
- Mail -> Settings -> Viewing -> Summarize Message Previews unchecked
- Mail -> Settings -> Viewing -> Move discarded messages into: -> Archive

Finally, open System Settings and configure the mac:

- General -> Date & Time -> 24-hour time checked
- General -> Date & Time -> Show 24-hour time on Lock Screen checked
- Appearance -> Appearance -> Dark
- Control Center -> Control Center Modules -> Focus -> Always Show
- Control Center -> Control Center Modules -> Sounds -> Always Show
- Desktop & Dock -> Mission Control -> Group windows by application checked
- Screen Saver -> (you choose)
- Trackpad -> Tracking Speed -> 8/10
- Printers & Scanners -> Add Printer, Scanner or Fax... (follow prompts)

## Testing

- Build `app` with `just i`
- Open XCode and run the `app`

## Windows Notes

**Enable Developer Mode** (required for symlinks):

- Search "Developer settings" in Start menu, or run `start ms-settings:developers`
- Turn on "Developer Mode"

## Deskflow (Software KVM)

Deskflow shares keyboard/mouse across machines. The Mac Mini is the server.

### Server Setup (Mac Mini)

1. Open Deskflow
2. Change "This computer's name" to `mac-mini`
3. Select "Use this computer's keyboard and mouse" (server mode)
4. Start the server

### Client Setup (MacBook Air, Windows, Arch)

1. Install Deskflow on the client machine
2. Change "This computer's name" to match the config (`macbook-air`, `windows`, or `arch`)
3. Select "Use another computer's mouse and keyboard" (client mode)
4. Enter the Mac Mini's IP address
5. Start the client

### Screen Layout

```
MacBook Air <-> Mac Mini <-> Windows
                              ↕
                            Arch
```

The config is at `~/.config/deskflow/deskflow.conf` (symlinked from dotfiles).

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

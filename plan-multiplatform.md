# Multiplatform Dotfiles Configuration

**Source:** N/A (infrastructure)
**Description:** Extend dotfiles management from Mac-only to support Windows and Arch Linux desktops.
**Status:** in-progress

## Why

The development environment is expanding from a pure Mac ecosystem to include Windows and Arch Linux desktops. Need a cross-platform configuration management approach that handles dotfiles and package installation.

## What

- Use **chezmoi** for cross-platform dotfiles management
- Use **native package managers** for packages (Homebrew, Scoop, pacman)
- Unified entry point via **justfile**

## Why Not Comtrya?

Comtrya was initially chosen but has critical issues:
- Package idempotency broken on Windows (winget returns error for already-installed packages)
- Upstream issues open since 2021 with no fix ([#26](https://github.com/comtrya/comtrya/issues/26), [#277](https://github.com/comtrya/comtrya/issues/277))
- See `package-issue.md` for details

## Tool Selection

### Dotfiles: chezmoi

**Decision:** Use [chezmoi](https://www.chezmoi.io/)

**Rationale:**
- Battle-tested (17k+ GitHub stars)
- Single binary, no dependencies
- Templating for OS-specific config sections
- Built-in secrets management (1Password integration)
- Handles edge cases (file permissions, encrypted files, scripts)

### Packages: Native Package Managers

| Platform | Package Manager | Why |
|----------|----------------|-----|
| macOS | Homebrew (Brewfile) | Native, mature, idempotent |
| Windows | Scoop (primary) | No admin required, dev-focused, clean |
| Windows | Winget (optional) | GUI apps needing Windows integration |
| Arch | pacman/yay | Native, AUR access |

**Why Scoop over Winget/Chocolatey?**
- No admin privileges required (installs to `~/scoop/`)
- Portable installs, clean uninstalls
- Developer-focused package selection
- Stable since 2014, predictable behavior

## Package Management Layers

| Layer | Tool | Installs | Purpose |
|-------|------|----------|---------|
| **Repo-specific** | aqua | beads, just, chezmoi | Dotfiles repo workflow tools |
| **Global** | Brew/Scoop/pacman | gh, neovim, fzf, starship, etc. | Dev environment |

**Why this split?**
- aqua.yaml travels with the repo, ensuring consistent tooling versions
- Global packages are your actual dev environment, managed natively
- Clean separation of concerns

## Machine Setup Flow

```bash
# 1. Install package manager (one-time, platform-specific)
# macOS:   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Windows: irm get.scoop.sh | iex
# Arch:    (pacman pre-installed, install yay for AUR)

# 2. Clone dotfiles
git clone https://github.com/mhedgpeth/dotfiles ~/dotfiles
cd ~/dotfiles

# 3. Bootstrap aqua
# macOS:   brew install aqua
# Windows: scoop install aqua
# Arch:    yay -S aqua-bin

# 4. Install repo tools
aqua install          # → beads, just, chezmoi

# 5. Initialize chezmoi (first time only)
just init             # → chezmoi init --source=home

# 6. Apply everything
just install          # → global packages (Brewfile/scoopfile)
just apply            # → dotfiles via chezmoi
```

## Structure

```
~/dotfiles/
├── aqua.yaml                    # repo tools: beads, just, chezmoi
├── justfile                     # unified entry point
├── home/                        # chezmoi source directory
│   ├── .chezmoi.yaml.tmpl      # chezmoi config with OS detection
│   ├── dot_zshrc               # → ~/.zshrc
│   ├── dot_config/             # → ~/.config/*
│   │   ├── nvim/
│   │   ├── ghostty/
│   │   ├── starship.toml
│   │   └── ...
│   └── ...
├── packages/
│   ├── Brewfile                # macOS: global dev packages
│   ├── scoopfile.json          # Windows: scoop export format
│   └── archlinux.txt           # Arch: package list
├── .config/                    # REMOVED (moves to home/dot_config/)
└── .zshrc                      # REMOVED (moves to home/dot_zshrc)
```

## Tasks

### Phase 1: Restructure for chezmoi (Mac)
- [ ] Update aqua.yaml: remove comtrya, add chezmoi
- [ ] Move dotfiles to chezmoi source directory (`home/`)
- [ ] Create `.chezmoi.yaml.tmpl` with OS detection
- [ ] Update justfile with `install` and `apply` targets
- [ ] Move Brewfile to `packages/Brewfile`, add gh (move from aqua to global)
- [ ] Remove comtrya manifests and config
- [ ] Test `aqua install && just install && just apply` on Mac

### Phase 2: Windows Support
- [ ] Create `packages/scoopfile.json` with dev tools (scoop export format)
- [ ] Add Windows-specific chezmoi templates (if needed)
- [ ] Test on Windows Desktop

### Phase 3: Arch Linux Support
- [ ] Create `packages/archlinux.txt`
- [ ] Test on Arch Desktop

### Phase 4: Cleanup
- [ ] Remove `package-issue.md` (no longer relevant)
- [ ] Update README.md with new setup instructions
- [ ] Test fresh clone → setup on each platform

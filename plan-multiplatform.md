# Multiplatform Dotfiles Configuration

**Source:** N/A (infrastructure)
**Description:** Extend dotfiles management from Mac-only to support Windows and Arch Linux desktops using comtrya for declarative configuration management.
**Status:** in-progress

## Why

The development environment is expanding from a pure Mac ecosystem to include Windows and Arch Linux desktops. Need a cross-platform configuration management approach that handles both dotfiles AND package installation declaratively.

## What

- Use comtrya for declarative dotfiles and package management
- Single source of truth for all platforms
- Replace Brewfile with comtrya package manifests

## Tool Selection: comtrya

**Decision:** Use [comtrya](https://github.com/comtrya/comtrya) (Rust)

**Rationale:**
- Rust-based, single binary
- Declarative package management (like Chef's `package` resource)
- Cross-platform file management (copy, symlink, template)
- Auto-detects OS and uses appropriate package manager
- YAML manifests

## Machine Setup Flow

```bash
# 1. Clone dotfiles
git clone https://github.com/mhedgpeth/dotfiles ~/dotfiles
cd ~/dotfiles

# 2. Install aqua (only manual platform-specific step)
# macOS:   brew install aqua
# Windows: scoop install aqua
# Arch:    yay -S aqua-bin

# 3. Install dotfiles tools
aqua install    # → gh, beads, comtrya

# 4. Apply machine config
comtrya apply   # → dotfiles + packages
```

## Structure

```
~/dotfiles/
├── aqua.yaml                    # gh, beads, comtrya
├── manifests/                   # comtrya manifests
│   ├── packages/
│   │   ├── cli-tools.yaml      # fzf, zoxide, starship, etc.
│   │   ├── dev-tools.yaml      # neovim, git, etc.
│   │   └── gui-apps.yaml       # vscode, ghostty, etc.
│   └── dotfiles/
│       ├── shell.yaml          # .zshrc
│       └── config.yaml         # .config/*
├── .config/                     # actual config files
└── .zshrc                       # actual shell config
```

## Tasks

### Phase 1: Local (Mac Desktop)
- [x] Add comtrya to aqua.yaml
- [ ] Create basic manifest structure
- [ ] Migrate .zshrc to comtrya
- [ ] Migrate packages to comtrya (replace Brewfile)
- [ ] Verify `comtrya apply` works

### Phase 2: Mac
- [ ] Test on MacBook Air

### Phase 3: Windows
- [ ] Test on Windows Desktop

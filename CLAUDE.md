# CLAUDE.md

This is a repository for managing my dotfiles on both my macOS and Windows
machines, primarily used as development machines for PeopleWork.

Tasks within this repository will be focused on ensuring the right configuration
exists in order to maximize efficiency and fit the style of a terminal-first
NeoVim rust and swift developer.

## Background

I am a co-founder of a startup called PeopleWork, and am the CTO and primary
technical contributor of that company. I spend most of my time in terminals
developing our app primarily in rust, using the crux framework, but also in
native platform UI, which includes SwiftUI, Kotlin (Android) and C# (WINUI).

It's important to me that tooling be simple, terminal-driven, and the
configuration is clear and streamlined.

## Workflow

The repo uses a modern cross-platform stack:
- **chezmoi** - manages dotfiles (templating, OS detection, symlinks)
- **just** - unified task runner for all platforms
- **aqua** - pins tool versions (just, chezmoi)

Clone to `~/dotfiles`, run `aqua install` to get tools, then `just init` for
first-time setup or `just` for regular updates.

## macOS

On a macOS machine, run `just` regularly to keep everything configured.

To set up a fresh machine, follow README.md steps: install Homebrew, aqua, gh,
then run `just init` which does one-time setup followed by a full update.

## Windows

Windows support is functional with Scoop and winget for packages. Run `just init`
for first-time setup. System defaults automation is not yet implemented.

## Linux

Arch Linux is supported via pacman/yay. See README.md for setup details.

## Structure

`justfile` - unified task runner (replaces old setup.sh/update.sh)
`aqua.yaml` - pins versions of just, chezmoi
`home/` - chezmoi source directory (all dotfiles)
`packages/` - package manifests (Brewfile, scoopfile.json, archlinux.txt)
`scripts/` - platform-specific configuration scripts
`.zshrc` - shell configuration
`.config/aerospace` - for macOS window management
`.config/bacon` - for continuous testing while developing
`.config/homebrew` - macOS package manager (Brewfile)
`.config/ghostty` - configures the Ghostty terminal
`.config/git` - configures git
`.config/nvim` - my primary text editor
`.config/nvim-debug` - for debugging NeoVim while making issues
`.config/starship` - terminal prompt
`.config/yazi` - file explorer
`.config/moonlander` - ZSA Moonlander keyboard (QMK source from Oryx)

## Keyboard

The user has a ZSA Moonlander split keyboard. Config is in `.config/moonlander/keymap.c`.
Oryx URL: https://configure.zsa.io/moonlander/layouts/p6XyD/latest/0

When suggesting keybindings or shortcuts, read `keymap.c` first to understand:
- What keys are available on each layer
- Existing modifier combinations (Hyper keys on Layer 2)
- Thumb cluster layout (Esc/Ctrl/Cmd left, Space/Tab/Layer right)

## Working with Claude

Claude should help configure this repository by suggesting and making changes
to configuration files. Do not run or test configurations; the user will run
scripts separately to avoid chicken-and-egg situations. Suggest what should be
run next in another terminal.

## Source Control

The repo is hosted on GitHub, utilize `gh` when possible to simplify, and `git`
when needed.

Run all commands from the root of this repository, to enable allow listing.

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT
complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **Run quality gates** - Ask the user to run quality gates outside the claude session to avoid a chicken-and-egg issue
2. **PUSH TO REMOTE** - This is MANDATORY:

   ```bash
   git pull --rebase
   git push
   git status  # MUST show "up to date with origin"
   ```

3. **Clean up** - Clear stashes, prune remote branches
4. **Verify** - All changes committed AND pushed
5. **Hand off** - Provide context for next session

**CRITICAL RULES:**

- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

## Commit Conventions

Use Conventional Commits:

- `feat:` - new feature or capability
- `fix:` - bug fix
- `chore:` - maintenance, dependencies, tooling
- `docs:` - documentation only
- `refactor:` - code change that neither fixes a bug nor adds a feature

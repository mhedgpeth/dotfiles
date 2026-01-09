# CLAUDE.md

This is a repository for managing my dotfiles on both my macOS and Windows
machines, primarily used as development machines for PeopleWork.

Tasks within this repository will be focused on ensuring the right configuration
exists in order to maximize efficiency and fit the style of a terminal-first NeoVim rust and swift developer.

## Background

I am a co-founder of a startup called PeopleWork, and am the CTO and primary
technical contributor of that company. I spend most of my time in terminals
developing our app primarily in rust, using the crux framework, but also in
native platform UI, which includes SwiftUI, Kotlin (Android) and C# (WINUI).

It's important to me that tooling be simple, terminal-driven, and the
configuration is clear and streamlined.

## Workflow

The repo is designed to be cloned to `~/dotfiles` and symlinked to the home
folder. Symlinking is handled by `update.sh`, which links individual files
(`.zshrc`, yazi configs) and entire `.config/` subdirectories.

## macOS

On a macOS machine, the user should regularly run the `update.sh` script.

To set up, the user will view this repository README.md, run the appropriate steps, then run `setup.sh`, which is meant to be only ran once.

## Windows

Windows support is minimal but actively being developed. Help build out
Windows equivalents for macOS configurations when requested.

## Structure

`setup.sh` - to set things up for the first time.
`update.sh` - regularly ran to keep everything configured and up to date
`configure.sh` - intended to configure macOS defaults (not currently functional)
`.zshrc` - shell configuration
`.config/aerospace` - for macOS window management
`.config/bacon` - for continuous testing while developing
`.config/homebrew` - macOS package manager (Brewfile)
`.config/ghostty` - configures the Ghostty terminal
`.config/git` - configures git
`.config/nvim` - my primary text editor
`.config/nvim-debug` - for debugging NeoVim while making issues
`.config/starship` - terminal prompt
`.config/tmux` - terminal multiplexer
`.config/yazi` - file explorer

## Working with Claude

Claude should help configure this repository by suggesting and making changes
to configuration files. Do not run or test configurations; the user will run
scripts separately to avoid chicken-and-egg situations. Suggest what should be run next in another terminal.

## Commit Conventions

Use Conventional Commits:

- `feat:` - new feature or capability
- `fix:` - bug fix
- `chore:` - maintenance, dependencies, tooling
- `docs:` - documentation only
- `refactor:` - code change that neither fixes a bug nor adds a feature

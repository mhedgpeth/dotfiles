# CLAUDE.md

This is a repository for managing my dotfiles on both my MacOS and Windows
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

The repo is designed to be cloned anywhere and symlinked to the user folder.

## MacOS

On a MacOS machine, the user should regularly run the `update.sh` script.

To set up, the user will view this repository README.md, run the appropriate steps, then run `setup.sh`, which is meant to be only ran once.

## Windows

I recently started developing in Windows, and the support for that here is
minimal, this is a goal of the repository but you won't find much evidence for
that. I am just starting to support Windows as a shell for People Work.

## Structure

`setup.sh` - to set things up for the first time.
`update.sh` - regularly ran to keep everything configured and up to date
`configure.sh` - to configure MacOS settings, honestly this doesn't work very well
`.zshrc` - shell configuration
`.config/aerospace` - for MacOS window management
`.config/bacon` - for continuous testing while developing
`.config/homebrew` - MacOS package manager, utilizing
  the [Brewfile](.config/homebrew/Brewfile) for updates
`.config/ghostty` - configures the Ghostty terminal
`.config/git` - configures git
`.config/nvim` - my primary text editor
`.config/nvim-debug` - for debugging NeoVim while making issues
`.config/starship` - terminal prompt
`.config/tmux` - terminal multiplexer
`.config/yazi` - file explorer

# dotfiles

This repository manages the dotfiles for Michael Hedgpeth.

## New Machine

When setting up a new machine, get the `setup.sh` from GitHub and run it from
the home directory. This will:

- Install brew
- Install gh and authenticate
- Clone this repository to `~/dotfiles`

## Initial Setup

Once this repository is cloned with the above process, navigate to `~/dotfiles`
and run `./update.sh`, which:

- Installs all brew packages
- Installs all zsh plugins
- Creates symlinks for dotfiles to their normal locations

## Update

From here to ensure everything is proper, run `update`. It's meant to be run
as many times as you want.

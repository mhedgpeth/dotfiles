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

- Ensures all Apple updates are completed
- Installs all brew packages
- Creates symlinks for dotfiles to their normal locations
- Sets up AI

## Update

From here to ensure everything is proper, run `update`. It's meant to be run
as many times as you want.

## Configure

To configure settings, run `configure.sh` and restart your mac.

## Manual

Despite all this automation, there are still manual things to do:

1. Install Amazon Kindle from the App Store
2. Install Day One from the App Store
3. Install Todoist from the App Store
4. Install ZSA Keymap from the App Store
5. Set up Internet Accounts (personal, work, family, assistant)
6. Configure profiles via Safari (?)
7. Set up Messages for iCloud
8. Set up Photos and disk limits
9. Set up Music and disk limits
10. Set up calendars
11. Set up printers and scanners

Finally, set up XCode development:

1. Install XCode from the App Store
2. Install Apple Developer from the App Store
3. Generate the XCode project by running `xcodegen`
4. Open XCode from the App Store and build
5. To make sure swift can run, run:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

After this you should be able to build with `just cs`

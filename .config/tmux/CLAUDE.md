# tmux

Terminal multiplexer for persistent, project-based development environments.

## Philosophy

One tmux session per project, defined declaratively in tmuxinator YAML files. Sessions are "config as code" - version controlled with their respective repos.

No session persistence plugins (resurrect/continuum). Instead, `tmuxinator start <session>` recreates the exact layout every time. Deterministic > magical.

## Windowing

Here are the roles:

- [Aerospace](../aerospace/) - for navigating workspaces, `Alt-O` is the terminal workspace, we are meant to only have one terminal session in this window.
- [Ghostty](../ghostty/) - renders the terminal service, in a full window
- tmux - what runs in the terminal, in a full Ghostty window, on the `o` aerospace worksapce, with defined `tmuxinator` sessions.

## Runtime

The user should run `tmuxinator` with the alias `t`.

## Session Organization

```
~/.config/tmuxinator/
  dotfiles.yml    ← symlinked from this repo
  dev.yml         ← symlinked from private app repo
  ...
```

Each repo owns its session configs. This repo's `update.sh` creates the directory and symlinks its configs. Private repos add their own symlinks.

## Plugins

- **vim-tmux-navigator**: Seamless C-h/j/k/l between nvim splits and tmux panes
- **catppuccin**: Theme consistency with nvim/ghostty
- **tmux-sensible**: Reasonable defaults

TPM manages plugins. Install with `C-Space I`.

## First-time Setup

1. Run `update.sh` (installs TPM, creates symlinks)
2. Open tmux: `tmux`
3. Install plugins: `C-Space I`
4. Start a session: `tmuxinator start dotfiles`

## Daily Workflow

```bash
t start dotfiles   # or dev, etc.
# work...
# C-Space s to switch sessions
# C-Space d to detach
```

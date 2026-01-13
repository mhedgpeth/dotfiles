# tmux

## The Perfect Start

You already have a solid tmux config. Here's what to do:

1. Open a terminal and run `tmux`
2. Press `C-Space I` (Ctrl+Space, then Shift+i) to install plugins
3. Press `C-Space r` to reload config
4. You now have catppuccin, vim navigation, and sensible defaults

Your prefix is `C-Space`. All commands start with that.

## What's Already Configured (HERO Status)

Your current setup includes:
- [x] Install tmux
- [x] C-Space as prefix (ergonomic for Moonlander)
- [x] True color support for Ghostty
- [x] Undercurl support for nvim diagnostics
- [x] NeoVim compatibility (escape-time 0)
- [x] Mouse support
- [x] Vim-style pane navigation (prefix + hjkl)
- [x] Seamless nvim/tmux navigation with C-h/j/k/l
- [x] Catppuccin mocha theme with custom status bar
- [x] Status bar on top (directory, session, date/time)
- [x] Intuitive splits with | and -
- [x] Cmd+S works (Ghostty passes through to nvim)
- [x] nvim integration (both ways - vim-tmux-navigator on both sides)
- [x] System clipboard integration (y copies to macOS clipboard)
- [x] fzf session switcher (C-Space s)
- [x] Session persistence (resurrect + continuum)
- [x] Auto window naming (shows current directory)
- [x] JetBrains Mono Nerd Font (icons work)

## Basics to Learn

### Session Management
- [ ] Create a named session: `tmux new -s myproject`
- [ ] Detach from session: `C-Space d`
- [ ] List sessions: `tmux ls`
- [ ] Attach to session: `tmux attach -t myproject`
- [ ] Kill session: `tmux kill-session -t myproject`

### Window Management
- [ ] Create window: `C-Space c`
- [ ] Next window: `C-Space n`
- [ ] Previous window: `C-Space p`
- [ ] Rename window: `C-Space ,`
- [ ] Close window: `C-Space &`

### Pane Management
- [ ] Split vertical: `C-Space |`
- [ ] Split horizontal: `C-Space -`
- [ ] Navigate panes: `C-h/j/k/l` (works in nvim too!)
- [ ] Resize panes: `C-Space C-h/j/k/l`
- [ ] Close pane: `C-Space x`

### Copy Mode (vim-style)
- [ ] Enter copy mode: `C-Space [`
- [ ] Start selection: `v`
- [ ] Copy and exit: `y`
- [ ] Paste: `C-Space ]`

## Session Persistence

Already configured! Just use:

- Save session: `C-Space C-s`
- Restore session: `C-Space C-r`
- Continuum auto-saves every 15 minutes

## Dev Mode with tmuxinator

tmuxinator lets you define project layouts in YAML files that can live in your repo.

### Setup

- [ ] Install: `brew install tmuxinator`
- [ ] Create first config: `tmuxinator new peopleofnow`
- [ ] Test it: `tmuxinator start peopleofnow`

### Example Config

`~/.config/tmuxinator/peopleofnow.yml` (or `.tmuxinator.yml` in your monorepo):

```yaml
name: peopleofnow
root: ~/Projects/peopleofnow

windows:
  - app:
      root: ~/Projects/peopleofnow/app
      layout: main-vertical
      panes:
        - nvim .
        - bacon
  - api:
      root: ~/Projects/peopleofnow/api
      layout: main-vertical
      panes:
        - nvim .
        - bacon
  - lib:
      root: ~/Projects/peopleofnow/lib
      layout: main-vertical
      panes:
        - nvim .
        - bacon
```

### Commands

- `tmuxinator start peopleofnow` - Start the session
- `tmuxinator stop peopleofnow` - Stop the session
- `tmuxinator edit peopleofnow` - Edit the config
- `mux start peopleofnow` - Short alias (add `alias mux=tmuxinator` to .zshrc)

### Project-local configs

You can put `.tmuxinator.yml` in your monorepo root:
- [ ] Create `.tmuxinator.yml` in peopleofnow repo
- [ ] Run `tmuxinator local` from that directory to use it

This is the "config as code" approach - your terminal layout is version controlled with your project.

## Quick Reference (Your Keybindings)

| Key | Action |
|-----|--------|
| `C-Space` | Prefix (all commands start with this) |
| `C-h/j/k/l` | Navigate between panes AND nvim splits |
| `C-Space \|` | Split vertical |
| `C-Space -` | Split horizontal |
| `C-Space c` | New window |
| `C-Space n/p` | Next/previous window |
| `C-Space s` | fzf session switcher popup |
| `C-Space S` | Create new named session |
| `C-Space d` | Detach from session |
| `C-Space X` | Kill current session |
| `C-Space [` | Enter copy mode |
| `v` / `y` | Select / copy (in copy mode) |
| `C-Space p` | Paste from clipboard |
| `C-Space C-s` | Save session (resurrect) |
| `C-Space C-r` | Restore session (resurrect) |
| `C-Space r` | Reload config |
| `C-Space I` | Install plugins (TPM) |

## Customization Ideas

Once comfortable, consider:
- [x] Customize catppuccin status bar modules
- [x] Add session switcher keybinding (C-Space s)
- [ ] Add tmux-fzf for fuzzy finding windows/panes
- [ ] Create project-specific tmuxinator configs

## Socratic Tango

Things to explore as you use tmux:
- When do I use tmux windows vs Aerospace windows?
- Should I run one tmux session per project or one big session?
- How do I quickly switch between projects?
- What belongs in my status bar?

---

## Notes from Typecraft Videos

### Flow State Video

[Source](https://www.youtube.com/watch?v=jcrE1qrm_e8)

The mental state in which a person is fully immersed in energized focus.

"Clear the Mechanism" - best way of saying flow state. Angry bots not yelling at me. Best sensation in the world.

Example: RoR ->

1. open tmux
2. open neovim in code
3. open a new pane and look at mail server
4. run a test to create something below, go back to neovim - perfect flow state

(My thoughts): this is how it would be great to look at neovim and bacon together, with easy pane switching.

vim-tmux-navigator has a vim plugin to get out of nvim to a tmux pane.

- [Typecraft tmux config](https://github.com/typecraft-dev/dotfiles/blob/master/tmux/.tmux.conf)
- [Typecraft nvim tmux nav](https://github.com/typecraft-dev/dotfiles/blob/master/nvim/.config/nvim/lua/plugins/nvim-tmux-navigation.lua)

He uses vimtest and vimux but bacon is better.

### Making Tmux Better and Beautiful

[Source](https://www.youtube.com/watch?v=jaI3Hcw-ZaA&t=21s)

Notes:
- Set mouse support on (so I can resize panes with mouse)
- TPM the plugin manager - clone it, install with prefix I
- catpuccin makes tmux look great
- set option -g status-position top
- he really likes config 3 for catppuccin

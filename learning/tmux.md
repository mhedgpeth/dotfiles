# tmux Learning

The approach to tmux is documented in [CLAUDE.md](/.config/tmux/CLAUDE.md).
Configuration for [tmux](../.config/tmux/tmux.conf).

Main goal - zero to hero with tmux driving a rolls royce, delightful tmux car into the bold new future.

## Progress

- Jan 12-13: getting tmux configured properly
- Next: practicing, incorporating it into the workflow

## Tasks to Practice

### Session Flow (Priority 1)

- [ ] Start session: `t start dotfiles`
- [ ] Switch sessions: `C-Space s` (fzf popup)
- [ ] Detach: `C-Space d`
- [ ] Create new session: `C-Space S`
- [ ] Kill session: `C-Space X`

### Pane Navigation (Priority 2)

- [ ] Navigate between nvim splits and tmux panes: `C-h/j/k/l`
- [ ] Split vertical: `C-Space |`
- [ ] Split horizontal: `C-Space -`
- [ ] Resize panes: `C-Space C-h/j/k/l`
- [ ] Close pane: `C-Space x`

### Window Management (Priority 3)

- [ ] Create window: `C-Space c`
- [ ] Next/Previous window: `C-Space n/p`
- [ ] Rename window: `C-Space ,`
- [ ] Close window: `C-Space &`

### Copy Mode (vim-style)

- [ ] Enter copy mode: `C-Space [`
- [ ] Start selection: `v`
- [ ] Copy and exit: `y`
- [ ] Paste: `C-Space p` (from system clipboard)

## Next Steps

- [ ] Create tmuxinator config for PeopleWork dev environment
- [ ] Practice nvim + bacon pane workflow (the flow state goal)

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

# tmux Learning

Practice tasks and notes for building tmux muscle memory.

## Tasks to Practice

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

### tmuxinator
- [ ] Test it: `tmuxinator start dotfiles`
- [ ] Create project-local config in app repo

## Ideas to Explore

- [ ] Add tmux-fzf for fuzzy finding windows/panes
- [ ] Create more project-specific tmuxinator configs

## Questions to Consider

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

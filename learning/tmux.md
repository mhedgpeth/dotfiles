# tmux

## Learning Tasks

- [ ] Simple tmux config that is minimal
- [ ] Select leader key (he says C-s but what is best for the Moonlander?)
- [ ] Add mouse support
- [ ] Add vim navigation
- [ ] Add catpuccin
- [ ] Status bar on top with picking best layout (consider layout 3)
- [ ] Cmd+S as a save shortcut needs to work for my workflow and hand health - see Moonlander layout
- [ ] Configure nvim integration (both ways)
- [ ] Ensure dev mode is supported - nvim on the left, bacon on the right
  - [ ] for my app
  - [ ] for my api
  - [ ] for my lib
  - [ ] for my cloud
  - [ ] for my platform
  - [ ] for my openspec
  - [ ] for my website
  - [ ] for agents

## Sources

I love Typecraft's videos and thinking about tmux. I'm sold!

### Flow State Video

[flow state video](https://www.youtube.com/watch?v=jcrE1qrm_e8)

The mental state in which a person is fully immersed in energized focus.

"Clear the Mechanism" - best way of saying flow state. Angry bots not yelling at me. Best sensation in the world.

Example: RoR ->

1. open tmux
2. open neovim in code
3. open a new pane and look at mail server
4. run a test to create something below, go back to neovim - perfect flow state

(My thoughts): this is how it would be great to look at neovim and bacon together, with:

1. Easy pane switching

More ergonomic - but on the

```
set -g prefix C-s
```

bind keys k,j,k,l to direction, matchin neovim - on switching panes.

C-s % for new pane?

has
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/vim-tmux-navigator'
set -g @plugin 'catpuccin/tmux#2.1.0'

hold down control and use the vim keys to navigate very quickly

vim-tmux-navigator also has a vim plugin to get out of nvim to a tmux pane - he is mapping in his lazyvim config a way the TmuxNavigateLeft, etc.

[Source](https://github.com/typecraft-dev/dotfiles/blob/master/tmux/.tmux.conf)

Then the neovim config is: [Source](https://github.com/typecraft-dev/dotfiles/blob/master/nvim/.config/nvim/lua/plugins/nvim-tmux-navigation.lua)
He uses vimtest and vimux but to me bacon is way better.

## Making Tmux Better and Beautiful

[Source](https://www.youtube.com/watch?v=jaI3Hcw-ZaA&t=21s)

Need a tmux.conf file.

- Unbind r
- Set prefix to C-s - I need to evaluate what would work for the moonlander
- Set mouse support to be on (so I can resize panes with mouse)
- <leader>hjkl to move around panes
- C-s % to split

A few extras (above).

But it still looks like crap!

- need to add tpm the plugin manager - you clone it? LOL
- install with leader I

catpuccin - makes tmux look great! Wait - am I using this? I should add whatever I'm using for consistency

- status, then last command, then

set option -g status-position top

he really likes config 3 but I would love to investigate

he removes some things he doesn't like.

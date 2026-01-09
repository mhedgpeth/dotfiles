# Tmux Learning Plan

## Week 1: Core Navigation

- **Prefix key**: `Ctrl-Space` (configured in dotfiles)
- **Sessions**: `tmux new -s name`, `tmux attach -t name`, `prefix d` (detach)
- **Windows**: `prefix c` (new), `prefix n/p` (next/prev), `prefix 1-9` (jump)
- **Panes**: `prefix |` (vertical split), `prefix -` (horizontal), `prefix h/j/k/l` (navigate)

## Week 2: Productivity

- **Copy mode**: `prefix [` to enter, `v` to select, `y` to copy
- **Resize panes**: `prefix Ctrl-h/j/k/l`
- **Seamless vim navigation**: `Ctrl-h/j/k/l` works across NeoVim and tmux panes

## Week 3: Session Management

- **List sessions**: `tmux ls`
- **Switch sessions**: `prefix s`
- **Kill session**: `tmux kill-session -t name`

## Key Commands Reference

| Action | Keybind |
|--------|---------|
| Split vertical | `prefix \|` |
| Split horizontal | `prefix -` |
| Navigate panes | `Ctrl-h/j/k/l` |
| Reload config | `prefix r` |
| Detach | `prefix d` |

## First Steps

After running `update.sh` in another terminal:

1. Start tmux: `tmux`
2. Install plugins: `prefix I` (capital I)
3. Try splitting: `prefix |` then `prefix -`
4. Navigate with `Ctrl-h/j/k/l`
5. Open NeoVim and test seamless navigation between vim splits and tmux panes

# tmux Cheat Sheet — Prefix: `Ctrl+Space`

| Category | Keys | Action |
|----------|------|--------|
| **Sessions** | `prefix s` | Switch session (fzf) |
| | `prefix S` | New named session |
| | `prefix X` | Kill session |
| | `prefix d` | Detach |
| | `prefix $` | Rename session |
| **Windows** | `prefix c` | New window |
| | `prefix ,` | Rename window |
| | `prefix &` | Close window |
| | `prefix 1-9` | Go to window N |
| | `prefix n/p` | Next/prev window |
| | `prefix w` | List windows |
| **Panes** | `prefix \|` | Split vertical |
| | `prefix -` | Split horizontal |
| | `prefix x` | Close pane |
| | `prefix z` | Zoom toggle |
| | `prefix Space` | Cycle layouts |
| | `prefix {/}` | Swap pane |
| **Navigate** | `C-h/j/k/l` | Move between panes (vim-style) |
| **Resize** | `prefix C-h/j/k/l` | Resize pane (repeatable) |
| **Copy** | `prefix [` | Enter copy mode |
| | `v` / `y` / `q` | Select / yank / quit |
| | `prefix p` | Paste |
| **Config** | `prefix r` | Reload config |
| | `prefix I/U` | Install/update plugins |

**Terminal:** `t start <name>` · `tmux ls` · `tmux attach -t <n>`

**Copy mode:** vim motions work (`h/j/k/l`, `w/b`, `gg/G`, `/search`)

**Setup:** Catppuccin Mocha · Status top · Windows start at 1 · Mouse enabled

**Drills:** `prefix |` → `C-h` · `prefix z` toggle · `prefix c` → `prefix 1` · `prefix [` → `v` → `y` → `prefix p`

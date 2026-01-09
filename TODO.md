# Tasks

## High Priority (Bugs/Issues)

- [ ] Fix hardcoded username in setup.sh (line 10-11) - uses `/Users/anniehedgpeth/` instead of `$HOME`
- [ ] Fix duplicate ls alias in .zshrc (lines 55, 62) - second alias overwrites first without `--color`
- [ ] Add `set -euo pipefail` to setup.sh and update.sh for safer script execution
- [ ] Fix duplicate [diff] section in git/config (lines 13, 41)
- [ ] Fix duplicate Xcode rule in aerospace.toml (lines 215, 230) - assigns to both workspace M and 0
- [ ] Move cargo directory check earlier in update.sh (before rustup install)

## Medium Priority (Optimizations)

- [ ] Add `zinit cdreplay -q` after compinit in .zshrc for faster completion loading
- [ ] Add completion caching to .zshrc to speed up shell startup
- [ ] Consider zinit turbo/wait mode for plugins (lazy loading)
- [ ] Add `--locked` flag to cargo install commands in update.sh for reproducible builds

## Low Priority (Enhancements)

- [ ] Add eza as modern ls replacement (better icons, git integration)
- [ ] Add bat for better cat (syntax highlighting)
- [ ] Consider atuin for shell history (sync, better search)
- [ ] Consider direnv for per-project environment variables
- [ ] Add tmux to Brewfile or remove .config/tmux from structure
- [ ] Add git rerere config for automatic merge conflict resolution
- [ ] Add git branch sort by recent commits

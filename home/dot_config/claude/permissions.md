# Claude Code Permissions Documentation

This file documents the rationale for permissions in `settings.json`.

## Philosophy

- **Allow**: Read-only operations, standard workflow, low-risk modifications
- **Ask**: Destructive, administrative, irreversible, or high-impact operations
- **Deny**: External integrations, system modifications, or unnecessary commands

---

## Allow List

### GitHub CLI Commands

| Command | Rationale |
|---------|-----------|
| `gh pr view` | Read-only. Displays current branch's pull request details. |
| `gh pr view *` | Read-only. Displays pull request details. |
| `gh issue view *` | Read-only. Displays issue details. |
| `gh pr checks *` | Read-only. Displays CI check status for a pull request. |
| `gh pr diff *` | Read-only. Displays pull request diff. |

### Build & Test Commands

| Command | Rationale |
|---------|-----------|
| `swift test *` | Runs Swift package tests. Local, non-destructive. |
| `cargo test` | Runs Rust tests with no arguments. Local, non-destructive. |
| `cargo test *` | Runs Rust tests with arguments (filters, flags). Local, non-destructive. Space-separated form avoids matching unrelated commands like `cargo testfoo`. |

### Shell Utilities

| Command | Rationale |
|---------|-----------|
| `ls *` | Read-only. Lists directory contents. |
| `head *` | Read-only. Shows first lines of a file or piped input. Enables piped read-only commands like `gh pr view ... \| head -n`. |

### Web Access

| Rule | Rationale |
|------|-----------|
| `WebSearch` | Read-only. Web search for research. |
| `WebFetch(domain:github.com)` | Read-only. Fetches public GitHub content (READMEs, issues, PRs). |
| `WebFetch(domain:book.leptos.dev)` | Read-only. Leptos framework documentation. |

---

## Updating This Document

When modifying `settings.json` permissions:

1. Update the corresponding section in this file
2. Include rationale for the change
3. Consider the risk level (read-only < low-risk < medium < high)

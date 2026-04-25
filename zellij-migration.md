# Zellij Migration

**Source:** N/A (infrastructure)
**Description:** Replace cmux with zellij as the terminal multiplexer; add cross-machine remote sessions over Tailscale; add Claude + Codex agent panes with notifications that reach me regardless of which machine an agent runs on.
**Status:** planning

## Why

- Currently using cmux. Per *DevOps Toolbox: "CMUX: Too Much Hype?"* — zellij delivers the same daily-driver experience without cmux's overhead and is a better fit for a terminal-first NeoVim workflow.
- Want a single multiplexer that runs natively on macOS, Arch, and Windows. **Zellij 0.44.0 (March 2026)** added native Windows support and remote-attach over HTTPS — both unlock the rest of this plan.
- Want persistent dev sessions on every machine in the tailnet (mac mini, Beelink Arch, Beelink Windows) that survive disconnects.
- Want `claude` and `codex` to be first-class parts of the dev layout, with notifications that reach me no matter which machine the agent is running on.

## What

1. Install zellij natively on all three platforms via existing package manifests.
2. Author a shared zellij config + layouts in `home/dot_config/zellij/`.
3. Use zellij 0.44's HTTPS remote-attach, fronted by `tailscale serve`, instead of `ssh -t … zellij attach`.
4. Stand up self-hosted [ntfy](https://ntfy.sh/) on the always-on mac mini for cross-machine agent notifications.

## Machines & Tailscale Prerequisites

The remote-sessions and notifications stories both depend on every machine being reachable on the tailnet under a consistent name:

| Hostname | Role | OS | Runs agents? |
|---|---|---|---|
| `michael-air` | Portable dev (this machine) | macOS | Yes |
| `michael-mini` | Primary dev desktop, Mac Mini Pro M4 | macOS | Yes |
| `michael-beelink` | Dev box, Beelink SER Pro9 | Windows | Yes |
| `build-mini` | GitHub Actions self-hosted runner, Mac Mini M4 | macOS | No — also hosts optional ntfy |

> The Beelink is technically dual-boot Arch/Windows, but the Arch side is dead code right now and out of scope for this migration. If/when it returns, split the hostname (`michael-beelink-arch` / `michael-beelink-win`).

**Naming convention:** `michael-*` for personal devices, `build-*` for build/CI. Distinct hostnames per OS on dual-boot machines (so `michael-beelink-arch` and `michael-beelink-win`, since each Tailscale node needs a unique identity).

**One-time per machine** (documented in README, not repo work):

1. Install Tailscale (in `Brewfile` and `winget.json`; verify in `archlinux.txt`).
2. `tailscale up --ssh --hostname=<name>` — joins tailnet with the right name and enables Tailscale SSH for one-time setup / debugging.
3. `tailscale status` confirms all expected machines are visible.

The tailnet's MagicDNS suffix (e.g., `tail-xxxxx.ts.net`) is used in URLs but not committed to the repo; it lives in a shell var (`ZELLIJ_TAILNET`) read by `zjr`.

## Architecture

### 1. Zellij per machine

| Platform | Install via |
|----------|-------------|
| macOS    | `packages/Brewfile` |
| Windows  | `packages/scoopfile.json` (or winget) |

Config at `home/dot_config/zellij/`:

```
config.kdl              # base settings, keybinds, theme
layouts/
  default.kdl           # editor + shell + floating
  rust.kdl              # nvim + bacon + shell
  agents.kdl            # nvim tab + agents tab (claude | codex)
```

### 2. Remote sessions over zellij's web server + Tailscale Serve

Going full zellij: use 0.44's HTTPS terminal-to-terminal attach instead of SSH. Each machine runs `zellij web`, fronted by `tailscale serve` for TLS + tailnet-only access. The `zellij attach <url>` client speaks zellij's native protocol over HTTPS — no SSH PTY in the path.

**How the pieces fit:**

| Layer | What it does |
|---|---|
| `zellij web` (per machine) | Listens on `127.0.0.1:8082`, serves the web client + multiplayer protocol. Long-lived; supervised by launchd / systemd / Windows service. |
| `web_server true` in `config.kdl` | Persists the setting; alternatively triggered at runtime via `Ctrl-o s`. |
| `zellij web --create-token` | One-time per machine; mints an auth token. **Displayed once, never again** — copy at mint time. Read-only variant: `--create-read-only-token`. |
| `tailscale serve --bg --https=443 http://localhost:8082` | Terminates TLS with auto-renewing tailnet cert; restricts access to my devices. |
| `session_serialization` + `pane_viewport_serialization` | Sessions and pane contents survive remote reboots. |

**URL → session mapping**: `https://<host>.<tailnet>.ts.net/<session-name>` auto-creates / attaches / resurrects by name.

End user command:
```sh
zjr beelink rust    # zellij attach https://beelink.<tailnet>.ts.net/rust
```

**Bonus capabilities that come along:**
- Browser access to any session from any device on the tailnet (iPad, work laptop, anywhere)
- Multiplayer sharing — share a session URL, each client gets their own cursor; useful for pair debugging without screen-share
- Read-only tokens for safe demos

SSH stays available for one-time setup, file copy, and debugging the zellij service when it's not up — it's just not the attach path anymore.

### 3. Agent panes (Claude + Codex)

`layouts/agents.kdl` pre-spawns a `claude` pane and a `codex` pane plus a free shell. Floating panes for transient runs.

### 4. Notify (lowest priority — get there when I get there)

The core value of the migration is steps 1–3. Notify is layered awareness on top, adopt as much or as little as feels useful. Each layer is independent.

| Layer | Mechanism | Renders on | Cost |
|---|---|---|---|
| **Tab icon** | `zellij pipe` → [zellij-attention](https://github.com/KiryuuLight/zellij-attention) plugin (server-side) | Visible in zellij UI on any attached client | ~5 lines of config |
| **OS notification** | OSC 9 escape sequence emitted into pane TTY | The terminal emulator on the client (Ghostty fires native macOS toast) | One `printf` in the hook |
| **Phone push** | ntfy on `build-mini` + iOS app | Phone, even when no terminal is attached | Self-hosted daemon + tailscale serve + subscriber config |

**Why OSC 9 is the killer middle layer:** the hook fires on the server (where the agent runs), but OSC 9 is just terminal data — zellij forwards it like any other byte through to whatever client is currently rendering the pane. The notification appears on YOUR machine, not the server's. This is exactly the "claude calls zellij on server, zellij picks up on client" architecture, just at the terminal protocol layer instead of the plugin API.

Caveat: bell-from-inactive-tab can sit in stasis until focused ([Issue #4595](https://github.com/zellij-org/zellij/issues/4595)). The community-built [claude-zellij-whip](https://github.com/rvcas/claude-zellij-whip) is purpose-built for this exact problem and likely handles the inactive-tab focus logic — worth evaluating before rolling our own.

**Minimum viable hook** (chained — same shape for Claude and Codex):
```sh
zellij pipe --name 'zellij-attention::waiting::$ZELLIJ_PANE_ID' ; \
printf '\033]9;Agent waiting\007' > /dev/tty
```

Two lines, no daemons, covers tab icon + OS notification.

## Structure

```
~/dotfiles/
├── home/dot_config/zellij/
│   ├── config.kdl                  # theme, session_serialization, web_server, keybinds
│   └── layouts/
│       ├── default.kdl
│       ├── rust.kdl
│       └── agents.kdl
├── home/dot_ssh/config             # host aliases for one-time setup / debugging
├── home/dot_zshrc                  # ZELLIJ_CONFIG_DIR + `zj`/`zjr` + codex wrapper
├── home/dot_claude/settings.json   # Stop + Notification hooks → ntfy
├── packages/Brewfile               # add zellij; ntfy only on build-mini if Layer B used
├── packages/scoopfile.json         # add zellij
└── scripts/
    ├── zellij-web.macos.plist      # launchd unit for `zellij web`
    ├── zellij-web.linux.service    # systemd user unit for `zellij web`
    ├── zellij-web.windows.*        # Windows startup task / service (TBD)
    └── ntfy-serve.*                # per-OS ntfy + tailscale serve setup
```

### Notes on config locations

- Zellij defaults to `~/Library/Application Support/org.Zellij-Contributors.Zellij` on macOS, but honors `ZELLIJ_CONFIG_DIR`. Setting it to `$HOME/.config/zellij` in `dot_zshrc` lets chezmoi manage one config tree across all platforms.

## Setup Flow (target end state)

```sh
# Local: open or attach to a project session
zj rust                                          # zellij attach -c rust

# Remote: attach over HTTPS via the tailnet
zjr beelink rust                                 # zellij attach https://beelink.<tailnet>.ts.net/rust

# Or open the same session in a browser from any device
# https://beelink.<tailnet>.ts.net/rust

# Agents fire notifications anywhere on the tailnet
# Claude:   Stop / Notification hooks → curl https://ntfy…/agent
# Codex:    shell wrapper → curl on exit
```

## Tasks

### 1. Install zellij
- [ ] Add `zellij` to `packages/Brewfile`
- [ ] Add `zellij` to `packages/scoopfile.json`
- [ ] Remove `cmux` from any package manifest that has it
- [ ] On each machine: `just install`, confirm `zellij --version` ≥ 0.44

### 2. Configure zellij basics
- [ ] `home/dot_config/zellij/config.kdl` with at minimum:
  - `session_serialization true` (sessions survive reboot)
  - `pane_viewport_serialization true` (pane contents restored too)
  - `on_force_close "detach"` (closing terminal detaches, doesn't kill the session)
  - `web_server true` (enables the web server when zellij starts; needed for step 3)
  - `mouse_mode true`, `copy_on_select true`, theme of choice
- [ ] `home/dot_config/zellij/layouts/default.kdl`
- [ ] `home/dot_config/zellij/layouts/rust.kdl` — nvim + bacon + shell
- [ ] `home/dot_config/zellij/layouts/agents.kdl` — claude + codex side-by-side
- [ ] `home/dot_zshrc`: `export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"`
- [ ] `home/dot_zshrc`: `zj() { zellij attach -c "${1:-main}" }`
- [ ] `home/dot_ssh/config` with host aliases for each tailnet machine (used for one-time setup + debugging, not the attach path)

### 3. Configure remote sessions (zellij web server + Tailscale Serve)
- [ ] `scripts/zellij-web.macos.plist` — launchd user agent that runs `zellij web`
- [ ] `scripts/zellij-web.linux.service` — systemd user unit that runs `zellij web`
- [ ] `scripts/zellij-web.windows.*` — Windows startup task or service (research during execution)
- [ ] `home/dot_zshrc`: `zjr() { zellij attach "https://${1}.${ZELLIJ_TAILNET}/${2:-main}" }` and `export ZELLIJ_TAILNET="tail-xxxxx.ts.net"` (set per-machine, not committed)
- [ ] One-time per machine (document in README, not repo work):
  - `zellij web --create-token`, save token to a password manager (only displayed once)
  - `tailscale serve --bg --https=443 http://localhost:8082`
  - Configure client-side token storage (TBD where zellij looks for the token)
- [ ] Verify round-trip: macOS → Beelink (Arch), macOS → Beelink (Windows)

### 4. Notify (lowest priority — get there when I get there)

**Tier 1 — minimum viable (do this first when you start step 4):**
- [ ] Evaluate [claude-zellij-whip](https://github.com/rvcas/claude-zellij-whip) and [zellaude](https://github.com/ishefi/zellaude) — either may already do the whole job better than rolling our own
- [ ] Add `zellij-attention` plugin to `home/dot_config/zellij/config.kdl`
- [ ] `home/dot_claude/settings.json`: `Stop` + `Notification` hooks chaining `zellij pipe` + OSC 9 `printf`
- [ ] Codex equivalent in codex config (file location TBD during execution)
- [ ] Verify Ghostty's `desktop-notifications = true` is set; confirm OSC 9 propagates through the HTTPS attach to the client

**Tier 2 — phone push (only if Tier 1 isn't enough):**
- [ ] Add `ntfy` to `packages/Brewfile`
- [ ] `scripts/ntfy-serve.sh` — start ntfy + `tailscale serve` on `build-mini`
- [ ] Extend hooks to also `curl` an ntfy topic
- [ ] Subscribe via ntfy iOS app

**Tier 3 — tap-to-respond from phone (probably never, but documented):**
- [ ] Tiny webhook daemon on `build-mini` that runs `zellij action write-chars` against named sessions
- [ ] ntfy notifications carry `http` action buttons that POST to the daemon
- [ ] Apple Shortcut(s) on phone home screen for one-tap nudges

## Open Questions

### Step 1
- **Per-machine package differentiation** — does `claude`/`codex` install on `build-mini` (harmless but pointless), or do we use chezmoi templating to skip it on the CI box?

### Step 2
- **Session naming convention** — per-project (`peoplework`, `dotfiles`), per-machine, or per-purpose (`dev`, `agents`)? Drives layouts.

### Step 3
- **Client-side token storage** — the tutorial doesn't specify where `zellij attach <url>` reads tokens from. Resolve via `zellij web --help` after install.
- **Windows web server supervision** — Scheduled Task, NSSM, or native service?

### Step 4
- **Codex hook config location** — Codex has hooks; resolve exact file/format during execution.
- **Inactive-tab bell stasis** — does OSC 9 from a non-focused tab still fire on the client, or get stuck like BEL? Test before deciding whether `claude-zellij-whip` is worth adopting.
- **Tier 2 ntfy topic structure** if we ever add it — one shared topic or per-machine (`agent-air`, `agent-mini`, `agent-beelink`)?

## Deferred (out of scope for this migration)

- **Arch Linux support** — `packages/archlinux.txt` is dead code; revisit when re-enabling the Beelink Arch side.
- **Token rotation workflow** — handle as it comes up; for now, mint once and store in 1Password.

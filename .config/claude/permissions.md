# Claude Code Permissions Documentation

This file documents the rationale for permissions in `settings.json`.
Every `bd` command is explicitly categorized.

## Philosophy

- **Allow**: Read-only operations, standard workflow, low-risk modifications
- **Ask**: Destructive, administrative, irreversible, or high-impact operations
- **Deny**: External integrations, system modifications, or unnecessary commands

---

## Allow List

### Common

- All web searches

### Core Workflow Commands

| Command | Rationale |
|---------|-----------|
| `bd ready` | Read-only. Shows issues ready to work on. |
| `bd list *` | Read-only. Lists issues with filters. |
| `bd show *` | Read-only. Displays issue details. |
| `bd search *` | Read-only. Searches issues by text. |
| `bd create *` | Core workflow. Creating issues is the primary way to track work. |
| `bd update *` | Core workflow. Updating status/priority is routine. |
| `bd comments *` | Low-risk. Adding/viewing comments on issues. |
| `bd sync *` | Standard git sync. Already integrated with hooks. |
| `bd dep *` | Core workflow. Managing dependencies between issues. |
| `bd epic *` | Core workflow. Managing epics and child issues. |
| `bd label *` | Low-risk. Managing labels on issues. |
| `bd q *` | Quick capture. Just creates an issue and outputs ID. |
| `bd edit *` | Opens issue in $EDITOR. User controls the editor. |
| `bd defer *` | Low-risk. Defers issues for later. |
| `bd undefer *` | Low-risk. Restores deferred issues. |

### Read-Only Information Commands

| Command | Rationale |
|---------|-----------|
| `bd blocked` | Read-only. Shows issues blocked by dependencies. |
| `bd count *` | Read-only. Counts issues matching filters. |
| `bd graph *` | Read-only. Visualizes dependency graph. |
| `bd info` | Read-only. Shows database information. |
| `bd status` | Read-only. Shows database overview/statistics. |
| `bd stats` | Alias for status. Read-only. |
| `bd stale *` | Read-only. Shows issues not updated recently. |
| `bd orphans *` | Read-only. Identifies orphaned issues. |
| `bd where` | Read-only. Shows active beads location. |
| `bd version` | Read-only. Prints version info. |
| `bd help *` | Read-only. Shows help text. |
| `bd human` | Read-only. Shows essential commands for humans. |
| `bd onboard` | Read-only. Displays snippet for AGENTS.md. |
| `bd quickstart` | Read-only. Shows quick start guide. |

### Diagnostic Commands

| Command | Rationale |
|---------|-----------|
| `bd doctor` | Read-only health check. May suggest fixes but doesn't apply them. |
| `bd prime` | Read-only. Outputs AI context. Already used in hooks. |
| `bd preflight *` | Read-only. Shows PR readiness checklist. |
| `bd lint *` | Read-only. Checks issues for missing sections. |
| `bd activity *` | Read-only. Shows real-time state feed. |
| `bd state *` | Read-only. Queries current state dimension value. |

### Advanced Workflow Commands

| Command | Rationale |
|---------|-----------|
| `bd swarm *` | Swarm management for structured epics. Part of epic workflow. |
| `bd agent *` | Manages agent bead state. Needed for AI workflows. |
| `bd audit *` | Append-only logging. Records interactions, doesn't modify issues. |
| `bd slot *` | Manages agent bead slots. Part of agent workflow. |
| `bd gate *` | Manages async coordination gates. Workflow coordination. |
| `bd merge-slot *` | Manages merge-slot gates. Serialized conflict resolution. |
| `bd set-state *` | Sets operational state. Creates events, updates labels. |
| `bd mol *` | Molecule commands (work templates). Template management. |
| `bd formula *` | Manages workflow formulas. Template definitions. |
| `bd cook *` | Compiles formula into proto. Ephemeral by default. |
| `bd export *` | Exports issues to JSONL/Obsidian. Read-only export. |
| `bd restore *` | Restores compacted issue history from git. Recovery tool. |
| `bd completion *` | Generates shell autocompletion. Read-only. |

---

## Ask List (Require Confirmation)

These commands require explicit user approval before execution.

| Command | Risk | Rationale |
|---------|------|-----------|
| `bd close *` | Core workflow. Closing completed work. For now I want to approve of an issue being closed |
| `bd delete *` | **High** | Permanently deletes issues. Irreversible. |
| `bd admin *` | **High** | Administrative database operations. |
| `bd migrate *` | **High** | Database schema migrations. Could break things. |
| `bd repair` | **High** | Modifies database structure to fix corruption. |
| `bd rename-prefix` | **High** | Renames ALL issue IDs. Major change. |
| `bd import *` | **Medium** | Imports external data into database. |
| `bd init` | **Medium** | Creates new beads database. |
| `bd config *` | **Medium** | Modifies beads configuration. |
| `bd hooks *` | **Medium** | Modifies git hooks. |
| `bd setup *` | **Medium** | Sets up integration with AI editors. |
| `bd reopen *` | **Low** | Reopens closed issues. Could undo completed work. |
| `bd worktree *` | **Medium** | Manages git worktrees. |
| `bd upgrade *` | **Medium** | Upgrades bd version. |
| `bd duplicate *` | **Medium** | Marks issue as duplicate of another. |
| `bd duplicates *` | **Medium** | Finds and optionally merges duplicate issues. |
| `bd supersede *` | **Medium** | Marks issue as superseded by newer one. |
| `bd move *` | **Medium** | Moves issue to different rig with dependency remapping. |
| `bd refile *` | **Medium** | Moves issue to different rig. |
| `bd merge *` | **Medium** | Git merge driver for beads JSONL files. |
| `bd daemon *` | **Medium** | Manages background sync daemon. System process. |
| `bd repo *` | **Medium** | Manages multiple repository configuration. |
| `bd ship *` | **Medium** | Publishes capability for cross-project dependencies. |

---

## Deny List

These commands are blocked. They involve external integrations or are unnecessary for this workflow.

| Command | Rationale |
|---------|-----------|
| `bd jira *` | External integration. Not used in this project. |
| `bd linear *` | External integration. Not used in this project. |
| `bd mail *` | Delegates to mail provider. External integration. |
| `bd create-form` | Interactive form. Not suitable for CLI automation. |

---

## Updating This Document

When modifying `settings.json` permissions:

1. Update the corresponding section in this file
2. Include rationale for the change
3. Consider the risk level (read-only < low-risk < medium < high)
4. Every `bd` command must be explicitly listed somewhere

---
description: Investigate an open source repository from a user perspective first, then code
allowed-tools: Read, Grep, Glob, Task, WebFetch
argument-hint: <question or topic>
---

You are investigating an open source repository to answer a question
or understand a topic. The current working directory is the cloned repository
to investigate. The user is a technical software engineer, but is approaching
this repository as a user first, software engineer second.

## Investigation Priority

**Always prioritize the user perspective first, then dive into code:**

### 1. Documentation First (Primary Sources)

Search for and read these in order:

- `README.md` or `README.*` - Project overview, quick start, basic usage
- `docs/` or `documentation/` - Detailed guides and tutorials
- `CONTRIBUTING.md` - How the project works, architecture notes
- `examples/` or `example/` - Working code examples
- `*.md` files in root - Additional documentation (CHANGELOG, FAQ, etc.)
- Wiki or external docs linked in README

### 2. Configuration & Structure (Secondary)

- Package manifest (`package.json`, `Cargo.toml`, `pyproject.toml`, etc.)
- Configuration files that reveal project structure
- Directory structure to understand organization

### 3. Source Code (Tertiary)

Only after exhausting documentation:

- Entry points (`main.*`, `index.*`, `lib.*`)
- Public API surface
- Implementation details as needed

## Response Guidelines

- Start your answer with what you found in documentation
- Cite specific files and locations for your findings
- If docs are insufficient, explain what you found in code
- Be explicit about the source of your information (docs vs code)
- If the answer isn't clear, say so rather than guessing

## Question/Topic

$ARGUMENTS

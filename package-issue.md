# Comtrya Package Installation Issue on Windows

## Problem

Comtrya's `package.install` action fails when packages are already installed, even though the packages are correctly present on the system.

## Root Cause

When `winget install <package>` runs on an already-installed package:
1. Winget checks if updates are available
2. If no updates, winget returns exit code `-1978335189` (`APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE`)
3. Comtrya treats any non-zero exit code as failure
4. Result: "Failed" even when packages are correctly installed

## Upstream Issues

- **Issue #26**: [add update flag to package.install](https://github.com/comtrya/comtrya/issues/26) - Open since 2021
- **Issue #277**: [winget sometimes requires additional arguments](https://github.com/comtrya/comtrya/issues/277) - Closed, suggests using `command.run` as workaround

## Current Impact

Running `just apply` on Windows shows errors for package manifests even when everything is working correctly. The symlink manifests (`dotfiles-config`, `dotfiles-shell`) also report errors when links already exist.

## Workarounds

1. **Ignore errors** - Everything actually works, just looks broken
2. **Use `command.run`** - Replace `package.install` with raw winget commands:
   ```yaml
   - action: command.run
     command: winget
     args:
       - "install --id Package.Name --source winget --silent --accept-source-agreements --accept-package-agreements"
   ```
3. **Skip package manifests on Windows** - Only use comtrya for symlinks
4. **Modify justfile** - Ignore comtrya exit codes on Windows

## Status

Waiting for upstream fix. Using workaround in the meantime.

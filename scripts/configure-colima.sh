#!/bin/bash
set -euo pipefail

if command -v colima &>/dev/null; then
  # Load the launch agent so colima starts on login
  PLIST="$HOME/Library/LaunchAgents/com.colima.default.plist"
  if [ -f "$PLIST" ]; then
    launchctl bootout "gui/$(id -u)" "$PLIST" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$PLIST"
  fi

  # Start now if not already running
  if ! colima status &>/dev/null; then
    colima start
  fi
fi

#!/bin/bash
set -euo pipefail

if command -v colima &>/dev/null; then
  if ! colima status &>/dev/null; then
    colima start
  fi
fi

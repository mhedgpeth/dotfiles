#!/bin/bash
set -euo pipefail

if ! pgrep -f "[Dd]eskflow" > /dev/null; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open -a Deskflow
  else
    deskflow &
  fi
fi

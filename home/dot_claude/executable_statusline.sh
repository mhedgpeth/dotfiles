#!/bin/bash
# Claude Code status line: dotfiles on  main ▓▓▓░░░░░░░ 30% [Opus]
# Green < 50% | Yellow >= 50% | Red >= 90%

input=$(cat)
pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
exceeds=$(printf '%s' "$input" | jq -r '.context_window.exceeds_200k_tokens // false')
folder=$(printf '%s' "$input" | jq -r '.workspace.current_dir // empty')
folder=$(basename "$folder" 2>/dev/null)
branch=$(git branch --show-current 2>/dev/null)
pr=$(gh pr view --json number -q '.number' 2>/dev/null)

# Ahead/behind upstream
ahead=0
behind=0
if upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null); then
  ahead=$(git rev-list --count "$upstream"..HEAD 2>/dev/null || echo 0)
  behind=$(git rev-list --count "HEAD..$upstream" 2>/dev/null || echo 0)
fi

# Git status counts
added=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
deleted=$(git ls-files --deleted 2>/dev/null | wc -l | tr -d ' ')

# Color based on usage
if [ "$pct" -ge 90 ] 2>/dev/null; then
  color='\033[91m'
elif [ "$pct" -ge 50 ] 2>/dev/null; then
  color='\033[93m'
else
  color='\033[92m'
fi
reset='\033[0m'

# 10-char progress bar
filled=$(( pct / 10 ))
empty=$(( 10 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="▓"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# Build output
out=""
[ -n "$folder" ] && out+="\033[94m${folder}${reset}"
if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  branch_color='\033[92m'
else
  branch_color='\033[95m'
fi
[ -n "$branch" ] && out+=" on ${branch_color}⎇ ${branch}${reset}"
[ -n "$pr" ] && out+=" PR #${pr}"
sync=""
[ "$ahead" -gt 0 ] 2>/dev/null && sync+="↑${ahead}"
[ "$behind" -gt 0 ] 2>/dev/null && sync+="↓${behind}"
[ -n "$sync" ] && out+=" \033[96m${sync}${reset}"
gitstatus=""
[ "$added" -gt 0 ] 2>/dev/null && gitstatus+=" \033[92m+${added}${reset}"
[ "$modified" -gt 0 ] 2>/dev/null && gitstatus+=" \033[93m~${modified}${reset}"
[ "$deleted" -gt 0 ] 2>/dev/null && gitstatus+=" \033[91m-${deleted}${reset}"
[ -n "$gitstatus" ] && out+="$gitstatus"
out+=" ${color}${bar} ${pct}%${reset}"
[ "$exceeds" = "true" ] && out+=" \033[91m⚠${reset}"
[ -n "$model" ] && out+=" \033[95m[${model}]${reset}"

printf '%b' "$out"

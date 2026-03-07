#!/usr/bin/env bash
# Claude Code statusline.
# Palette: Catppuccin Mocha.

set -u

readonly ESC=$'\033[38;2;'
readonly C_GRAY="${ESC}108;112;134m"  # #6c7086
readonly C_GREEN="${ESC}166;227;161m" # #a6e3a1
readonly C_PEACH="${ESC}250;179;135m" # #fab387
readonly C_RED="${ESC}243;139;168m"   # #f38ba8
readonly RST=$'\033[0m'
readonly BAR_WIDTH=20

used_pct="$(jq -r '.context_window.used_percentage // empty | floor')"

if [[ -n ${used_pct} ]]; then
  filled=$((used_pct * BAR_WIDTH / 100))
  empty=$((BAR_WIDTH - filled))

  if ((used_pct >= 80)); then
    fill_clr=${C_RED}
  elif ((used_pct >= 50)); then
    fill_clr=${C_PEACH}
  else
    fill_clr=${C_GREEN}
  fi

  printf -v bar_filled '%*s' "${filled}" ''
  printf -v bar_empty '%*s' "${empty}" ''

  printf '%s' "${C_GRAY}[CTX ${fill_clr}${bar_filled// /█}${C_GRAY}${bar_empty// /░} ${used_pct}%]${RST}"
fi

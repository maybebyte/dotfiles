# 'common.sh' is a file with frequently used functions that may be sourced
# for readability purposes

if command -v doas >/dev/null 2>&1; then
  alias priv="doas "
elif command -v sudo >/dev/null 2>&1; then
  alias priv="sudo "
fi

err() {
  printf "%s\\n" "[$(date +'%Y-%m-%d|%H:%M:%S')]: $*" >&2
  exit 1
}

import_colors() {
  . "${HOME}/.cache/wal/colors.sh"
}

menu() {
  dmenu "$@" -i \
    -fn "mono-20" \
    -nb "${color0}" \
    -nf "${color3}" \
    -sb "${color0}" \
    -sf "${color7}"
}

must_be_root() {
  if [ "$(id -u)" != 0 ]; then
    err "Execute $(basename "$0") with root privileges."
  fi
}

today() {
  date '+%Y-%m-%d'
}

yank() {
  xclip -selection clipboard
}

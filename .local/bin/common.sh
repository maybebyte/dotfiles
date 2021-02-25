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

# err isn't used here so that:
# 1) interactive ksh(1) sessions won't terminate
# 2) dmenu scripts still work without colors
import_colors() {
  colors_sh="${HOME}/.cache/wal/colors.sh"
  [ -r "${colors_sh}" ] \
    || printf "%s\\n" "${colors_sh} not readable/found." >&2 \
    && . "${colors_sh}"
}

menu() {
  dmenu "$@" -i \
    -fn "mono-20" \
    -nb "${color0:=#040516}" \
    -nf "${color3:=#9974e7}" \
    -sb "${color0:=#040516}" \
    -sf "${color7:=#e0cef3}"
}

must_be_root() {
  [ "$(id -u)" = 0 ] || err "Execute ${0##*/} with root privileges."
}

today() {
  date '+%Y-%m-%d'
}

usage() {
  [ "$#" -eq "${arguments_needed}" ] || err "${usage_details}"
}

usage_min() {
  [ "$#" -ge "${arguments_needed}" ] || err "${usage_details}"
}

yank() {
  xclip -selection clipboard
}

# shellcheck disable=SC1090,SC2034,SC2154 shell=sh
# 'common.sh' is a file with frequently used functions. its purpose is
# to be sourced in scripts for readability purposes and ease of
# management. therefore, it has no shebang and isn't executable.

# instead of remembering/accounting for two different forms of privilege
# elevation, one is assigned to the alias 'priv.'
if [ -x "$(command -v 'doas')" ]; then
  alias priv='doas '

elif [ -x "$(command -v 'sudo')" ]; then
  alias priv='sudo '

fi

# if Xorg isn't running, exit with an error.
check_grafix() {
  [ -z "${DISPLAY}" ] && err "${0##*/} requires a graphical environment."
}

# reads from STDIN and checks that all commands needed are executable
# and available.
#
# note that I only check executables that aren't accounted for in dotfiles.
check_deps() {
  while read -r -- dependency; do

    if [ -x "$(command -v -- "${dependency}")" ]; then
      continue

    else
      err "${dependency} not found in PATH or not executable."

    fi

  done
}

# err() is the generic way to print an error message and exit a script.
# all of its output goes to STDERR.
#
# print everything passed as an argument.
# exit with a return code of 1.
err() {
  printf '%s\n' "$*" >&2
  exit 1
}

# if colors.sh is readable, source it. otherwise print to STDERR.
#
# err isn't used here so that:
# 1) interactive ksh(1) sessions won't terminate.
# 2) dmenu scripts still work without colors.
import_colors_sh() {
  colors_sh="${HOME}/.cache/wal/colors.sh"

  if [ -r "${colors_sh}" ]; then
    . "${colors_sh}" # source the file

  else
    : "${dotfiles_log:=${HOME}/.local/share/dotfiles.log}"
    echo "${colors_sh} not readable/found." 2>>"${dotfiles_log}" >&2

  fi
}

# generic dmenu function to handle customizations. uses colors that
# import_colors_sh() gathers.
menu() {
  dmenu -i \
    -nb "${color0:=#040516}" \
    -nf "${color3:=#9974e7}" \
    -sb "${color0:=#040516}" \
    -sf "${color7:=#e0cef3}" \
    -fn 'mono-20' \
    "$@"
}

# if the user isn't root, print an error message and exit.
must_be_root() {
  [ "$(id -u)" = 0 ] || err "Execute ${0##*/} with root privileges."
}

# copy STDIN to the clipboard so it can be pasted elsewhere.
yank() { xclip -selection clipboard "$@"; }

# shellcheck disable=SC1090,SC2034,SC2154 shell=sh
# 'common.sh' is a file with frequently used functions. its purpose is
# to be a collection of tools that can be easily referenced. keeping
# frequently used functions in one place ensures a certain level of
# consistency.

# instead of remembering/accounting for two different forms of privilege
# elevation, one is assigned to the alias 'priv.'
if [ -x "$(command -v -- 'doas')" ]; then
  alias priv='doas '

elif [ -x "$(command -v -- 'sudo')" ]; then
  alias priv='sudo '

fi


# reads from STDIN and checks that all commands needed are executable
# and available.
#
# note that I only check executables that aren't accounted for in dotfiles.
check_deps() {
  while read -r dependency; do

    [ -x "$(command -v -- "${dependency}")" ] \
      || err "${dependency} not found in PATH or not executable."

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
  readonly COLORS_SH="${XDG_CACHE_HOME:=${HOME}/.cache}/wal/colors.sh"

  if ! [ -r "${COLORS_SH}" ]; then
    echo "${COLORS_SH} is not readable." >&2

  elif ! [ -f "${COLORS_SH}" ]; then
    echo "${COLORS_SH} is not a file." >&2

  # passed sanity checks, so source the file
  else
    . "${COLORS_SH}"

  fi
}


# generic dmenu function to handle customizations. uses colors that
# import_colors_sh() gathers.
menu() {
  dmenu -i -fn 'mono-12'       \
  -nb "${background:-#040516}" \
  -nf "${color3:-#9974e7}"     \
  -sb "${background:-#040516}" \
  -sf "${foreground:-#e0cef3}" \
  "$@"
}

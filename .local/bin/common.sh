# 'common.sh' is a file with frequently used functions. its purpose is
# to be sourced in scripts for readability purposes and ease of
# management. therefore, it has no shebang and isn't executable.

# instead of remembering/accounting for two different forms of privilege
# elevation, one is assigned to the alias 'priv.' doas is preferred over
# sudo.
if command -v doas >/dev/null 2>&1; then
  alias priv='doas '
elif command -v sudo >/dev/null 2>&1; then
  alias priv='sudo '
fi

# err() is the generic way to print an error message and exit a script.
# all of its output goes to STDERR.
#
# print the date + time of the error in this format:
# [yyyy-mm-dd|hh:mm:ss]:
#
# after that, print everything passed as an argument.
# exit with a return code of 1.
err() {
  printf '%s\n' "[$(date '+%Y-%m-%d|%H:%M:%S')]: $*" >&2
  exit 1
}

# if colors.sh is readable, source it. otherwise print to STDERR.
#
# err isn't used here so that:
# 1) interactive ksh(1) sessions won't terminate.
# 2) dmenu scripts still work without colors.
import_colors() {
  colors_sh="${HOME}/.cache/wal/colors.sh"
  [ -r "${colors_sh}" ] \
    && . "${colors_sh}" \
    || echo "${colors_sh} not readable/found." >&2
}

# generic dmenu function to handle customizations. uses colors that
# import_colors() gathers.
menu() {
  dmenu "$@" -i \
    -fn 'mono-20' \
    -nb "${color0:=#040516}" \
    -nf "${color3:=#9974e7}" \
    -sb "${color0:=#040516}" \
    -sf "${color7:=#e0cef3}"
}

# if the user isn't root, print an error message and exit.
must_be_root() {
  [ "$(id -u)" = 0 ] || err "Execute ${0##*/} with root privileges."
}

# print date in yyyy-mm-dd format.
today() {
  date '+%Y-%m-%d'
}

# if the number of arguments isn't equal to the number needed, print the
# usage details to STDERR and exit.
arg_eq() {
  [ "$#" -eq "${arguments_needed}" ] || err "${usage_details}"
}

# if the number of arguments isn't greater than or equal to the number
# needed, print the usage details to STDERR and exit.
arg_ge() {
  [ "$#" -ge "${arguments_needed}" ] || err "${usage_details}"
}

# copy STDIN to the clipboard so it can be pasted elsewhere.
yank() {
  xclip -selection clipboard
}

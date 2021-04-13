# shellcheck disable=SC1090,SC2034,SC2154
# 'common.sh' is a file with frequently used functions. its purpose is
# to be sourced in scripts for readability purposes and ease of
# management. therefore, it has no shebang and isn't executable.

# instead of remembering/accounting for two different forms of privilege
# elevation, one is assigned to the alias 'priv.' doas is preferred over
# sudo.
if [ -x "$(command -v doas)" ]; then
  alias priv='doas '
elif [ -x "$(command -v sudo)" ]; then
  alias priv='sudo '
fi

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

# if Xorg isn't running, exit with an error.
check_grafix() {
  [ -z "${DISPLAY}" ] && err "${0##*/} requires a graphical environment."
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
import_colors() {
  readonly colors_sh="${HOME}/.cache/wal/colors.sh"
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
today() { date '+%Y-%m-%d'; }

# if $1 is less than 1024, print it and exit successfully.
# if $1 is not an integer, exit with an error.
# otherwise, convert $1 to its human readable counterpart.
#
# $1 is a positive integer (supporting rational numbers would require
# some additional code to handle exceptions).
#
# bug: 1024000 returns 0MB. maybe fix it by checking modulus?
hreadable() {
  no_of_loops=0
  size="$1"
  echo "${size}" \
    | grep -q '[^[:digit:]]' \
    && err 'Only integers are accepted.'
  [ "${size}" -lt 1024 ] \
    && echo "${size}" \
    && return 0
  # shell arithmetic must be assigned to a variable to avoid executing output
  # https://github.com/koalaman/shellcheck/wiki/SC2084
  until [ "${#size}" -le 3 ]; do
    dummy1=$((no_of_loops += 1))
    dummy2=$((size /= 1024))
  done
  case ${no_of_loops} in
    1) echo "${size}KB"                                    ;;
    2) echo "${size}MB"                                    ;;
    3) echo "${size}GB"                                    ;;
    4) echo "${size}TB"                                    ;;
    *) err 'hreadable() can only convert up to terabytes.' ;;
  esac
}

# copy STDIN to the clipboard so it can be pasted elsewhere.
yank() { xclip -selection clipboard; }

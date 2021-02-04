# shellcheck disable=SC2034,SC1090
. "${HOME}/.local/bin/common.sh"

# pywal
if [ -f "${HOME}/.cache/wal/colors.sh" ]; then
  import_colors
fi

if command -v tmux >/dev/null 2>&1; then
  # if not inside a tmux session, and if no session is started, start a
  # new session
  [ -z "${TMUX}" ] && (tmux attach || tmux) >/dev/null 2>&1
fi

# ksh options
set -o \
  vi \
  vi-esccomplete

if printf "%s" "${KSH_VERSION}" | grep -qi "pd ksh"; then
  set -o vi-show8
fi

for srcfile in aliases functions prompt vars; do
  . "${HOME}/.config/ksh/${srcfile}"
done

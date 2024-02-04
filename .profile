# use nvim if it's installed, vi otherwise
command -v 'nvim' > /dev/null 2>&1 && export EDITOR='nvim'
[ -z "${EDITOR}" ] && export EDITOR='vi'

# use colorls if it's installed, ls otherwise
command -v 'colorls' > /dev/null 2>&1 && export LS='colorls'
[ -z "${LS}" ] && export LS='ls'

export \
	BROWSER="firefox" \
	CLICOLOR=1 \
	FCEDIT="${EDITOR}" \
	HISTFILE="${HOME}/.history" \
	HISTSIZE=10000 \
	LC_CTYPE='en_US.UTF-8' \
	LESS='-iMRx 4' \
	LESSSECURE=1 \
	PAGER='less' \
	VISUAL="${EDITOR}" \
	XDG_BIN_HOME="${HOME}/.local/bin" \
	XDG_CACHE_HOME="${HOME}/.cache" \
	XDG_CONFIG_HOME="${HOME}/.config" \
	XDG_DATA_HOME="${HOME}/.local/share" \
	XDG_STATE_HOME="${HOME}/.local/state"

# These variables come after.
export \
	GOBIN="${XDG_BIN_HOME}" \
	GNUPGHOME="${XDG_CONFIG_HOME}/gnupg" \
	HTML_TIDY="${XDG_CONFIG_HOME}/tidy/tidy.conf" \
	MAILRC="${XDG_CONFIG_HOME}/mail/mailrc" \
	PERL5LIB="${XDG_DATA_HOME}/perl5" \
	PERLCRITIC="${XDG_CONFIG_HOME}/config/perlcritic.conf" \
	PERLTIDY="${XDG_CONFIG_HOME}/perltidy/perltidy.conf"

# shellcheck disable=SC1091
[ -n "${DISPLAY}" ] && . "${XDG_CACHE_HOME}/wal/colors.sh"

# Add XDG_BIN_HOME to PATH.
#
# PATH parameter expansion explanation:
# https://unix.stackexchange.com/a/415028
export PATH="${PATH:+${PATH}:}${XDG_BIN_HOME}"

# sh/ksh initialization
#
# this should come last in .profile so that one can assume
# that any variables exported in .profile will carry over to
# ksh(1).
export ENV="${XDG_CONFIG_HOME}/ksh/kshrc"

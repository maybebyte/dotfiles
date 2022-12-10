# use nvim if it's installed, vi otherwise
command -v 'nvim' > /dev/null 2>&1 && export EDITOR='nvim'
[ -z "${EDITOR}" ] && export EDITOR='vi'

# use colorls if it's installed, ls otherwise
command -v 'colorls' > /dev/null 2>&1 && export LS='colorls'
[ -z "${LS}" ] && export LS='ls'

export \
	CLICOLOR=1 \
	FCEDIT="${EDITOR}" \
	VISUAL="${EDITOR}" \
	HISTFILE="${HOME}/.history" \
	HISTSIZE=10000 \
	LC_CTYPE='en_US.UTF-8' \
	LESS='-iMRx 4' \
	LESSSECURE=1 \
	PAGER='less' \
	XDG_BIN_HOME="${HOME}/.local/bin" \
	XDG_CACHE_HOME="${HOME}/.cache" \
	XDG_CONFIG_HOME="${HOME}/.config" \
	XDG_DATA_HOME="${HOME}/.local/share" \
	XDG_STATE_HOME="${HOME}/.local/state" \
	SITE='https://www.anthes.is'

# these have to come after XDG_* are defined
export \
	GNUPGHOME="${XDG_CONFIG_HOME}/gnupg" \
	MAILRC="${XDG_CONFIG_HOME}/mail/mailrc" \
	PERLTIDY="${XDG_CONFIG_HOME}/perltidy/perltidyrc"

# shellcheck disable=SC1091
[ -n "${DISPLAY}" ] && . "${XDG_CACHE_HOME}/wal/colors.sh"

# OS specific actions
# written so it can be expanded later if needed
case "$(uname)" in
	'OpenBSD')
		GATEWAY="$(netstat -rn 2> /dev/null | awk '/^default/{print $2}')"
		export GATEWAY
		;;

	*) # if this isn't OpenBSD, do nothing
		;;
esac

# host-specific actions
case "$(hostname -s)" in
	'aphrodite' | 'lain')
		export \
			MARKDOWNDIR="${HOME}/src/website_md" \
			SRVDIR="/var/www/htdocs/${SITE##*//}"
		;;

	*) # if the hostname doesn't match, do nothing
		;;
esac


# Add XDG_BIN_HOME to PATH.
#
# PATH parameter expansion explanation:
# https://unix.stackexchange.com/a/415028
export PATH="${PATH:+${PATH}:}${XDG_BIN_HOME}"

# Add local man page directory.
export MANPATH=":${XDG_DATA_HOME}/man"

# sh/ksh initialization
#
# this should come last in .profile so that one can assume
# that any variables exported in .profile will carry over to
# ksh(1).
if [ -r "${XDG_CONFIG_HOME}/ksh/kshrc" ]; then
	export ENV="${XDG_CONFIG_HOME}/ksh/kshrc"
else
	echo "${XDG_CONFIG_HOME}/ksh/kshrc not readable."
fi

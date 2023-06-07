# use nvim if it's installed, vi otherwise
command -v 'nvim' > /dev/null 2>&1 && export EDITOR='nvim'
[ -z "${EDITOR}" ] && export EDITOR='vi'

# use colorls if it's installed, ls otherwise
command -v 'colorls' > /dev/null 2>&1 && export LS='colorls'
[ -z "${LS}" ] && export LS='ls'

export \
	CLICOLOR=1 \
	FCEDIT="${EDITOR}" \
	HISTFILE="${HOME}/.history" \
	HISTSIZE=10000 \
	LC_CTYPE='en_US.UTF-8' \
	LESS='-iMRx 4' \
	LESSSECURE=1 \
	PAGER='less' \
	VISUAL="${EDITOR}" \
	WEBSITE='https://www.anthes.is/'
	XDG_BIN_HOME="${HOME}/.local/bin" \
	XDG_CACHE_HOME="${HOME}/.cache" \
	XDG_CONFIG_HOME="${HOME}/.config" \
	XDG_DATA_HOME="${HOME}/.local/share" \
	XDG_STATE_HOME="${HOME}/.local/state" \

# These variables come after.
export \
	GNUPGHOME="${XDG_CONFIG_HOME}/gnupg" \
	HTML_TIDY="${XDG_CONFIG_HOME}/tidy/tidy.conf" \
	MAILRC="${XDG_CONFIG_HOME}/mail/mailrc" \
	PERL5LIB="${XDG_DATA_HOME}/perl5"
	PERLTIDY="${XDG_CONFIG_HOME}/perltidy/perltidy.conf" \

TMPVAR="${WEBSITE%/}"
export WEBSITE_DOMAIN="${TMPVAR##*//}"
unset TMPVAR

# shellcheck disable=SC1091
[ -n "${DISPLAY}" ] && . "${XDG_CACHE_HOME}/wal/colors.sh"

# OS specific actions
# written so it can be expanded later if needed
case "$(uname)" in
	'OpenBSD')
		IPV4_GATEWAY="$(netstat -rn -f inet 2> /dev/null | awk '/^default/{print $2}')"
		IPV6_GATEWAY="$(netstat -rn -f inet6 2> /dev/null | awk '/^default/{print $2}')"
		export IPV4_GATEWAY IPV6_GATEWAY
		;;

	*) # if this isn't OpenBSD, do nothing
		;;
esac

[ -e "${HOME}/src/website_md" ] &&
	export WEBSITE_SRC_DIR="${HOME}/src/website_md"

if [ -e "/var/www/htdocs/${WEBSITE_DOMAIN}" ]; then
	export WEBSITE_DEST_DIR="/var/www/htdocs/${WEBSITE_DOMAIN}"
elif [ -e "/var/www/htdocs/${WEBSITE_DOMAIN##www.}" ]; then
	export WEBSITE_DEST_DIR="/var/www/htdocs/${WEBSITE_DOMAIN##www.}"
fi

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

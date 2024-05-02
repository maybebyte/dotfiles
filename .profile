# determines what EDITOR will be based on what's available
if command -v 'nvim' > /dev/null 2>&1; then
	export EDITOR='nvim'
elif command -v 'vim' > /dev/null 2>&1; then
	export EDITOR='vim'
else
	export EDITOR='vi'
fi

# determines what LS will be based on what's available
if command -v 'colorls' > /dev/null 2>&1; then
	export LS='colorls'
else
	export LS='ls'
fi

# History variables
export \
	HISTFILE="${HOME}/.history" \
	HISTSIZE=10000

# Pager variables
export \
	LESS='-iMRx 4' \
	LESSSECURE=1 \
	PAGER='less'

# variables that depend on EDITOR being defined
export \
	FCEDIT="${EDITOR}" \
	VISUAL="${EDITOR}"

# XDG variables
export \
	XDG_BIN_HOME="${HOME}/.local/bin" \
	XDG_CACHE_HOME="${HOME}/.cache" \
	XDG_CONFIG_HOME="${HOME}/.config" \
	XDG_DATA_HOME="${HOME}/.local/share" \
	XDG_STATE_HOME="${HOME}/.local/state"

# Variables that depend on XDG_* being defined
export \
	GOBIN="${XDG_BIN_HOME}" \
	GNUPGHOME="${XDG_CONFIG_HOME}/gnupg" \
	HTML_TIDY="${XDG_CONFIG_HOME}/tidy/tidy.conf" \
	MAILRC="${XDG_CONFIG_HOME}/mail/mailrc" \
	PERL5LIB="${XDG_DATA_HOME}/perl5" \
	PERLCRITIC="${XDG_CONFIG_HOME}/config/perlcritic.conf" \
	PERLTIDY="${XDG_CONFIG_HOME}/perltidy/perltidy.conf"


# Other miscellaneous variables
export \
	BROWSER='firefox' \
	CLICOLOR=1 \
	LC_CTYPE='en_US.UTF-8'

# shellcheck disable=SC1091
[ -n "${DISPLAY}" ] && . "${XDG_CACHE_HOME}/wal/colors.sh"

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
export ENV="${XDG_CONFIG_HOME}/ksh/kshrc"

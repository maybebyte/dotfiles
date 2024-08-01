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
	GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0" \
	HTML_TIDY="${XDG_CONFIG_HOME}/tidy/tidy.conf" \
	MAILRC="${XDG_CONFIG_HOME}/mail/mailrc" \
	PERL5LIB="${XDG_DATA_HOME}/perl5" \
	PERLCRITIC="${XDG_CONFIG_HOME}/config/perlcritic.conf" \
	PERLTIDY="${XDG_CONFIG_HOME}/perltidy/perltidy.conf"


# Other miscellaneous variables
export \
	BROWSER='chromium' \
	CLICOLOR=1 \
	LC_CTYPE='en_US.UTF-8' \
	MANWIDTH=80 \
	QT_STYLE_OVERRIDE='Adwaita-dark'

# Bemenu theming
export BEMENU_OPTS='--fb "#303446" --ff "#c6d0f5" --nb "#303446" --nf "#c6d0f5" --tb "#303446" --hb "#303446" --tf "#e78284" --hf "#e5c890" --af "#c6d0f5" --ab "#303446" --fn "sans 16"'

export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# Append XDG_BIN_HOME to PATH.
#
# PATH parameter expansion explanation:
# https://unix.stackexchange.com/a/415028
export PATH="${PATH:+${PATH}:}${XDG_BIN_HOME}"

# Add local man page directory.
export MANPATH=":${XDG_DATA_HOME}/man"

# Needed so that OpenBSD ksh will source its rc file.
export ENV="${HOME}/.kshrc"

# Shell initialization. Currently, bash and OpenBSD ksh are supported.
. "${XDG_CONFIG_HOME}/shell/rc"

# determines what EDITOR will be based on what's available
if command -v 'nvim' > /dev/null 2>&1; then
	export EDITOR='nvim'
elif command -v 'vim' > /dev/null 2>&1; then
	export EDITOR='vim'
else
	export EDITOR='vi'
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
	PERLCRITIC="${XDG_CONFIG_HOME}/perlcritic/perlcritic.conf" \
	PERLTIDY="${XDG_CONFIG_HOME}/perltidy/perltidy.conf"


# Other miscellaneous variables
export \
	BROWSER='chromium' \
	CLICOLOR=1 \
	LC_CTYPE='en_US.UTF-8' \
	MANWIDTH=80 \
	READER='zathura' \
	QT_STYLE_OVERRIDE='Adwaita-dark'

# Bemenu theming
export BEMENU_OPTS='--fb "#24273a" --ff "#cad3f5" --nb "#24273a" --nf "#cad3f5" --tb "#24273a" --hb "#24273a" --tf "#ed8796" --hf "#eed49f" --af "#cad3f5" --ab "#24273a" --fn "sans 16"'

export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# Prepend XDG_BIN_HOME to PATH.
#
# PATH parameter expansion explanation:
# https://unix.stackexchange.com/a/415028
export PATH="${XDG_BIN_HOME}${PATH:+:${PATH}}"

# Add local man page directory.
export MANPATH=":${XDG_DATA_HOME}/man"

# Get NPM to install global packages in ~/.local
export npm_config_prefix="${HOME}/.local"

# Needed for OpenBSD's ksh and dash
#
# (Obviously dash is not ksh, but nothing ksh specific is set there, so
# it's fine)
export ENV="${HOME}/.kshrc"

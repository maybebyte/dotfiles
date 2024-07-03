. "${XDG_CONFIG_HOME}/shell/rc"

if [ -n "${BASH_VERSION}" ]; then
	bind -m vi-command 'Control-l: clear-screen'
	bind -m vi-insert 'Control-l: clear-screen'
fi

if [ -n "${BASH_VERSION}" ]; then
	complete -F _root_command doas
fi

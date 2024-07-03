. "${XDG_CONFIG_HOME}/shell/rc"

if [ -n "${BASH_VERSION}" ]; then
	bind -m vi-command 'Control-l: clear-screen'
	bind -m vi-insert 'Control-l: clear-screen'
fi

. "${XDG_CONFIG_HOME}/shell/rc"

bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

complete -F _root_command doas

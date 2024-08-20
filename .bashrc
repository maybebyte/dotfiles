# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
case "$-" in
	*i*) :      ;; # interactive
	*)   return ;; # not interactive
esac

. "${XDG_CONFIG_HOME}/shell/rc"

bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

complete -F _root_command doas

# Adds some nice things, like:
# CTRL-R -- paste selected command into history
# CTRL-T -- paste selected file path into command line
# ALT-C -- cd into selected directory
if [ -f '/usr/share/fzf/key-bindings.bash' ]; then
	. '/usr/share/fzf/key-bindings.bash'
fi

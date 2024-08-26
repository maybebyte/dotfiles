if status is-interactive
	# Automatically launch sway if:
	# 1) Wayland is not running
	# 2) We've logged into the first virtual terminal
	# 3) We're using Linux
	if ! string length --quiet {$WAYLAND_DISPLAY} \
	&& [ {$XDG_VTNR} -eq 1 ] \
	&& string match --quiet 'Linux' (uname)
		exec dbus-run-session sway
	end

	# If tmux is installed and not inside a tmux session, then try to attach.
	# If attachment fails, start a new session.
	if ! string length --quiet {$TMUX} && command --search --quiet 'tmux'
		begin
			tmux attach || tmux
		end > /dev/null 2>&1
	end

	# Allows '..' to cd to the parent directory, '...' to the directory
	# above that, etc.
	abbr --add dotdot --regex '^\.\.+$' --function multicd

	# Disable CTRL-S and CTRL-Q
	# These cause the terminal output to stop and start, but I've never had
	# an actual use case for these.
	#
	# Fish disables these by default, but I'm adding this anyway, just
	# in case they ever decide to revert that decision.
	# https://github.com/fish-shell/fish-shell/issues/814
	stty stop undef
	stty start undef

	# Suppress greeting.
	set -gx fish_greeting ""

	# Use vim bindings.
	set -gx fish_key_bindings fish_vi_key_bindings

	# Mimic neovim's cursor.
	set -gx fish_cursor_default block
	set -gx fish_cursor_insert line
	set -gx fish_cursor_replace_one underscore
	set -gx fish_cursor_replace underscore
	set -gx fish_cursor_external line

	# Needed for GnuPG to properly operate.
	set -gx GPG_TTY (tty)

	if command --search --quiet 'fzf'
		fzf --fish | source
	end

	# Replaces cd with zoxide if available
	# https://github.com/ajeetdsouza/zoxide
	if command --search --quiet 'zoxide'
		zoxide init --cmd 'cd' 'fish' | source
	end
end

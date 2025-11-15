if status is-interactive
	set SSH_VAULT_VM "vault-ssh"
	if string length --quiet -- {$SSH_VAULT_VM}
		set -gx SSH_AUTH_SOCK "/home/user/.SSH_AGENT_$SSH_VAULT_VM"
	end

	# Auto-install Fisher plugin manager if not present
	if not functions --query fisher
		if curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
			fisher update
		end
	end

	# Automatically launch sway if:
	# 1) Wayland is not running
	# 2) We've logged into the first virtual terminal
	# 3) We're using Linux
	# 4) both dbus-run-session and sway are available
	if ! string length --quiet {$WAYLAND_DISPLAY} \
	&& string match --quiet '1' {$XDG_VTNR} \
	&& string match --quiet 'Linux' (uname) \
	&& command --search --quiet 'dbus-run-session' \
	&& command --search --quiet 'sway'
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

	# Mimic neovim's cursor.
	set -gx fish_cursor_default block
	set -gx fish_cursor_insert line
	set -gx fish_cursor_replace_one underscore
	set -gx fish_cursor_replace underscore
	set -gx fish_cursor_external line

	# Needed for GnuPG to properly operate.
	set -gx GPG_TTY (tty)

	# Replaces cd with zoxide if available
	# https://github.com/ajeetdsouza/zoxide
	if command --search --quiet 'zoxide'
		zoxide init --cmd 'cd' 'fish' | source
	end
end

# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
case "$-" in
	*i*) :      ;; # interactive
	*)   return ;; # not interactive
esac

# If tmux is installed and not inside a tmux session, then try to attach.
# If attachment fails, start a new session.
if [ -z "${TMUX}" ] && command -v tmux > /dev/null 2>&1; then
		{ tmux attach || tmux; } > /dev/null 2>&1
fi

# These are features that are specific to pdksh.
case "${KSH_VERSION%%\ KSH*}" in
	'@(#)PD')
		# Prefix characters with the eighth bit set with 'M-', rather
		# than printing them as is (it may cause problems otherwise).
		set -o vi-show8
esac

# Enable ^T binding as a quick way to send SIGINFO. Useful for
# retrieving dd(1) updates on *BSD, for instance. Note that SIGINFO is
# only supported on *BSD, so that's the reason for the check.
#
# This stty command may work on a *BSD other than OpenBSD, but I haven't
# personally tested it. So I'm keeping this to what I've tested.
if [ "$(uname)" = 'OpenBSD' ]; then
	stty status "^T"
fi

set -o vi

. "${XDG_CONFIG_HOME:="${HOME}/.config"}/shell/aliases"
. "${XDG_CONFIG_HOME:="${HOME}/.config"}/shell/prompt"

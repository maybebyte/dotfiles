# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
case "$-" in
	*i*) :      ;; # interactive
	*)   return ;; # not interactive
esac

# Automatically launch sway if:
# 1) Wayland is not running
# 2) We've logged into the first virtual terminal
# 3) We're using Linux
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && [ "$(uname)" = 'Linux' ]; then
	exec dbus-run-session sway
fi

# If tmux is installed and not inside a tmux session, then try to attach.
# If attachment fails, start a new session.
if [ -z "${TMUX}" ] && command -v 'tmux' > /dev/null 2>&1; then
	{ tmux attach || tmux; } > /dev/null 2>&1
fi

# Lines configured by zsh-newuser-install
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST="${HISTSIZE}"
setopt autocd correctall extendedglob nomatch menucomplete
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' glob 100
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle :compinstall filename "${HOME}/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall


# If a new command line being added to the history list duplicates
# an older one, the older command is removed from the list (even if
# it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt HIST_FIND_NO_DUPS

# When writing out the history file, older commands that duplicate newer
# ones are omitted.
setopt HIST_SAVE_NO_DUPS

# Remove superfluous blanks from each command line being added to
# the history list.
setopt HIST_REDUCE_BLANKS

# Remove command lines from the history list when the first character on
# the line is a space, or when one of the expanded aliases contains a
# leading space. Only normal aliases (not global or suffix aliases) have
# this behaviour. Note that the command lingers in the internal history
# until the next command is entered before it vanishes, allowing you to
# briefly reuse or edit the line. If you want to make it vanish right
# away without entering another command, type a space and press return.
setopt HIST_IGNORE_SPACE

# Whenever the user enters a line with history expansion, don’t execute
# the line directly; instead, perform history expansion and reload the
# line into the editing buffer.
setopt HIST_VERIFY

# This option works like APPEND_HISTORY except that new history lines
# are added to the $HISTFILE incrementally (as soon as they are
# entered), rather than waiting until the shell exits. The file will
# still be periodically re-written to trim it when the number of lines
# grows 20% beyond the value specified by $SAVEHIST (see also the
# HIST_SAVE_BY_COPY option).
setopt INC_APPEND_HISTORY

# I'm not interested in beeps at all.
unsetopt HIST_BEEP
unsetopt LIST_BEEP

# If a pattern for filename generation is badly formed, print an error
# message. (If this option is unset, the pattern will be left
# unchanged.)
setopt BAD_PATTERN

# When this option is set and the default zsh-style globbing is in effect,
# the pattern ‘**/*’ can be abbreviated to ‘**’ and the pattern ‘***/*’
# can be abbreviated to ***. Hence ‘**.c’ finds a file ending in .c in any
# subdirectory, and ‘***.c’ does the same while also following symbolic
# links. A / immediately after the ‘**’ or ‘***’ forces the pattern to be
# treated as the unabbreviated form.
setopt GLOB_STAR_SHORT

# When writing out the history file, by default zsh uses ad-hoc file
# locking to avoid known problems with locking on some operating systems.
# With this option locking is done by means of the system’s fcntl call,
# where this method is available. On recent operating systems this may
# provide better performance, in particular avoiding history corruption
# when files are stored on NFS.
setopt HIST_FCNTL_LOCK

# Allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS

# Disable CTRL-S and CTRL-Q
# These cause the terminal output to stop and start, but I've never had
# an actual use case for these.
stty stop undef
stty start undef

# Set the shell prompt
PS1="%F{blue}[%f%F{cyan}%n%f@%F{magenta}%m%f %F{red}%~%f%F{blue}]%f%# "

# Enable syntax highlighting if it's available
if [ -f "/usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh" ]; then
	source "/usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh"
fi

# Enable autosuggestions from history if available
if [ -f "/usr/share/zsh/site-functions/zsh-autosuggestions.zsh" ]; then
	source "/usr/share/zsh/site-functions/zsh-autosuggestions.zsh"
fi

# Adds some nice things, like:
# CTRL-R -- paste selected command into history
# CTRL-T -- paste selected file path into command line
# ALT-C -- cd into selected directory
if [ -f '/usr/share/fzf/key-bindings.zsh' ]; then
	. '/usr/share/fzf/key-bindings.zsh'
fi

# Needed for menu selection in zsh.
zmodload zsh/complist

# Use vim bindings for menu selection.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Fixes a really annoying bug with searching in vi mode.
#
# The problem is that if I hit ESC and / too quickly in succession,
# it'll pull up this entirely different thing that I didn't want.
#
# https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
vi-search-fix() {
	zle vi-cmd-mode
	zle .vi-history-search-backward
}
autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix

# Fixes the inability to delete characters preceding wherever the cursor
# was when the user switches from normal to insert in zsh's vi mode.
#
# https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# Replaces cd with zoxide if available
# https://github.com/ajeetdsouza/zoxide
if command -v 'zoxide' > /dev/null 2>&1; then
	eval "$(zoxide init --cmd cd zsh)"
fi

# Needed for GnuPG to properly operate.
GPG_TTY="$(tty)"
export GPG_TTY

. "${XDG_CONFIG_HOME}/shell/aliases.sh"
. "${XDG_CONFIG_HOME}/shell/functions.sh"

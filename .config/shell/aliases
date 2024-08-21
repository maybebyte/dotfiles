# cd into parent directories more easily.
alias \
	..='cd ..' \
	...='cd ../..' \
	....='cd ../../..' \
	.....='cd ../../../..'

# Manage dotfiles more easily.
alias d="git --git-dir=\${HOME}/.dotfiles/ --work-tree=\${HOME}/"

# Play audio with mpv more easily.
alias mpva='mpv --no-keep-open --no-resume-playback --no-pause --no-video'

# Generate diffs between kernel configurations that can be used in
# /etc/kernel/config.d
#
# See also:
# https://wiki.gentoo.org/wiki/Project:Distribution_Kernel#Using_.2Fetc.2Fkernel.2Fconfig.d
alias diffkernel='diff --changed-group-format="%>" --unchanged-group-format=""'

# Aliases to add color
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ls='ls --color=auto'

# Replace ls with eza if available
# https://github.com/eza-community/eza
if command -v eza > /dev/null 2>&1; then
	alias ls='eza --icons --classify'
	alias ll='eza --icons --classify --time-style=long-iso --git --icons --binary --long --group --header --links --octal-permissions'
fi

# Replace cat and less with bat if available
# https://github.com/sharkdp/bat
if command -v bat > /dev/null 2>&1; then
	alias cat='bat'
	alias less='bat --paging always'
fi

# Replace vi and vim commands with neovim if available.
if command -v nvim > /dev/null 2>&1; then
	alias vi='nvim'
	alias vim='nvim'
fi

# These allow other aliases to be checked and expanded after sudo or
# doas.
alias sudo='sudo '
alias doas='doas '

# Convenience alias for viewing SELinux denials.
alias sedenials='ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts boot'

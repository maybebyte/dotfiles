. ~/.profile
set -o braceexpand
set -o vi
set -o vi-esccomplete
set -o vi-tabcomplete
set -o vi-show8

# use vim if it's installed, vi otherwise
case "$(command -v vim)" in
  */vim) VIM="vim" ;;
  *)     VIM="vi"  ;;
esac

# https://wiki.archlinux.org/index.php/Ranger#Preventing_nested_ranger_instances
ranger() {
	if [ -z "$RANGER_LEVEL" ]; then
		/usr/local/bin/ranger "$@"
	else
		exit
	fi
}

# use colorls if it's installed, plain old ls otherwise
if command -v colorls > /dev/null ; then
  LS='colorls'
else
  LS='ls'
fi

umask 077

# swaps colors when uid is 0
case "$(id -u)" in
  0) _PS1_USER_COLOR='\[\033[1;33m\]' _PS1_PATH_COLOR='\[\033[1;35m\]' ;;
  *) _PS1_USER_COLOR='\[\033[1;35m\]' _PS1_PATH_COLOR='\[\033[1;33m\]' ;;
esac
_PS1_BRACKET_COLOR='\[\033[1;36m\]'
_PS1_CLEAR='\[\033[0m\]'

PS1='${_PS1_BRACKET_COLOR}[${_PS1_CLEAR}${_PS1_USER_COLOR}\u ${_PS1_CLEAR}@ ${_PS1_PATH_COLOR}\w${_PS1_CLEAR}${_PS1_BRACKET_COLOR}]${_PS1_CLEAR}\$ '

export QT_STYLE_OVERRIDE=adwaita
export HISTFILE=${HOME}/.history
export HISTSIZE=10000
export BROWSER="firefox"
export LESS="-iMR"
export PAGER="less"
export VISUAL="${VIM}"
export EDITOR="${VIM}"
export FCEDIT=${EDITOR}
export CLICOLOR=1
export GNUPGHOME="${HOME}/.config/gnupg"
export PATH=${HOME}/.local/bin:${HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games

alias wgetall="wget --random-wait -m -k -p -np -c -N --show-progress --no-verbose -R 'index.html*' -U mozilla"
alias wgetone="wget --random-wait -k -p -np -c -E -H -K -N --show-progress --no-verbose -U mozilla"
alias dots="git --git-dir=~/.dotfiles/ --work-tree=~/"
alias dots_cmt="dots commit -a -m"
alias dots_psh="dots push origin master"
alias ytdl="youtube-dl"
alias ytdlrm="ytdl --rm-cache-dir"
alias yta="ytdl -x -f bestaudio/best --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"
alias ytv="ytdl --embed-subs --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"
alias trem="transmission-remote"
alias ls="\${LS} -F"
alias ll="ls -lh"
alias llnew="ll -t"
alias llbig="ll -S"
alias df="df -h"
alias du="du -ch"
alias mkdir="mkdir -p"
alias ..="cd .."
alias ...="cd ../.."
alias sort_mpd="sort /var/lib/mpd/playlists/revised.m3u > /var/lib/mpd/playlists/revised1.m3u && rm /var/lib/mpd/playlists/revised.m3u && mv /var/lib/mpd/playlists/revised1.m3u /var/lib/mpd/playlists/revised.m3u && chown mpd:mpd /var/lib/mpd/playlists/revised.m3u"
alias today="date '+%Y-%m-%d'"
alias kpcli="keepassxc-cli"
alias gcl="git clone"
alias gcmt="git commit -a -m"
alias gpsh="git push"
alias cmd_stats="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr"
alias yank="xclip -selection clipboard"
alias se="doas vim"
alias sepf="se /etc/pf.conf"
alias pfld="doas pfctl -f /etc/pf.conf"
alias pftst="doas pfctl -f /etc/pf.conf -n -vvv"
alias tmatt="tmux attach"
alias tmksrv="tmux kill-server"
alias tmls="tmux list-sessions"
alias pdfman="MANPAGER=zathura man -T pdf"
alias ssgauto="ssg5 ~/builds/website_md ~/builds/website \"A Missing Link\" \"https://amissing.link\" && ~/bin/fmt_site"
alias mutt="neomutt"
alias axel="axel -a -v"
alias tskctchup="task done \$(task due.before:today ids)"
alias n="nnn"

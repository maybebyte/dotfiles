#!/usr/bin/env sh
. ~/.profile
set -o braceexpand
set -o vi
set -o vi-esccomplete
set -o vi-tabcomplete
set -o vi-show8

# use vim if it's installed, vi otherwise
case "$(command -v vim)" in
  */vim) VIM=vim ;;
  *)     VIM=vi  ;;
esac

# use colorls if it's installed, plain old ls otherwise
if command -v colorls > /dev/null ; then
  LS='colorls'
else
  LS='ls'
fi

# swaps colors when uid is 0
case "$(id -u)" in
  0) _PS1_USER_COLOR='\[\033[1;33m\]' _PS1_PATH_COLOR='\[\033[1;35m\]' ;;
  *) _PS1_USER_COLOR='\[\033[1;35m\]' _PS1_PATH_COLOR='\[\033[1;33m\]' ;;
esac
_PS1_BRACKET_COLOR='\[\033[1;36m\]'
_PS1_CLEAR='\[\033[0m\]'

PS1='${_PS1_BRACKET_COLOR}[${_PS1_CLEAR}${_PS1_USER_COLOR}\u ${_PS1_CLEAR}@ ${_PS1_PATH_COLOR}\w${_PS1_CLEAR}${_PS1_BRACKET_COLOR}]${_PS1_CLEAR}\$'

QT_STYLE_OVERRIDE=adwaita
HISTFILE=~/.history
HISTSIZE=10000
BROWSER="firefox"
LESS="-iMR"
PAGER="less"
#VISUAL="$VIM"
EDITOR="$VIM"
FCEDIT=${EDITOR}
CLICOLOR=1
PATH=~/.local/bin:~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games
export PATH BROWSER PAGER VISUAL EDITOR ENV PS1 FCEDIT QT_STYLE_OVERRIDE CLICOLOR

alias wgetall="wget --random-wait -m -k -p -np -c -e robots=off --no-check-certificate -R 'index.html*' -U mozilla"
alias wgetone="wget --random-wait -k -p -np -c -e robots=off --no-check-certificate -E -H -K --show-progress --no-verbose -U mozilla"
alias dots="git --git-dir=~/.dotfiles/ --work-tree=~/"
alias dots_cmt="dots commit -a -m"
alias dots_psh="dots push origin master"
alias ytdl="youtube-dl"
alias ytdlrm="ytdl --rm-cache-dir"
alias yta="ytdl -x -f bestaudio/best --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"
alias ytv="ytdl --embed-subs --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"
alias trem="transmission-remote"
alias ls="$LS -F"
alias ll="ls -lh"
alias llnew="ll -t"
alias llbig="ll -S"
alias df="df -h"
alias du="du -ch"
alias mkdir="mkdir -p"
alias ..="cd .."
alias ...="cd ../.."
#alias rsync="openrsync" # currently bugged
alias sort_mpd="sort /var/lib/mpd/playlists/revised.m3u > /var/lib/mpd/playlists/revised1.m3u && rm /var/lib/mpd/playlists/revised.m3u && mv /var/lib/mpd/playlists/revised1.m3u /var/lib/mpd/playlists/revised.m3u && chown mpd:mpd /var/lib/mpd/playlists/revised.m3u"
alias today="date '+%Y-%m-%d'"
alias kpcli="keepassxc-cli"
alias gcl="git clone"
alias gcm="git commit"
alias gpsh="git push"
alias cmd_stats="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr"
alias yank="xclip -selection clipboard"
alias tar_backup="tar -cf - /mnt --exclude=/$(today).tar.bz2 | pv -s $(\du -s /mnt | awk '{print $1}') | bzip2 -c > /$(today).tar.bz2"
alias se="doas vim"
alias sepf="se /etc/pf.conf"
alias pfld="doas pfctl -f /etc/pf.conf"
alias tmatt="tmux attach"
alias tmksrv="tmux kill-server"
alias tmls="tmux list-sessions"
alias crontab="VISUAL=vi crontab" # crontab won't save otherwise

ranger() {
	if [ -z "$RANGER_LEVEL" ]; then
		/usr/local/bin/ranger "$@"
	else
		exit
	fi
}

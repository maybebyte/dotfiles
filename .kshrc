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

# use colorls if it's installed, plain old ls otherwise
if command -v colorls > /dev/null; then
  LS='colorls'
else
  LS='ls'
fi

umask 077

# swaps colors when uid is 0, i.e. root
case "$(id -u)" in
  0) _PS1_USER_COLOR='\[\033[1;33m\]' _PS1_PATH_COLOR='\[\033[1;35m\]' ;;
  *) _PS1_USER_COLOR='\[\033[1;35m\]' _PS1_PATH_COLOR='\[\033[1;33m\]' ;;
esac
_PS1_BRACKET_COLOR='\[\033[1;36m\]'
_PS1_CLEAR='\[\033[0m\]'

PS1="${_PS1_BRACKET_COLOR}[${_PS1_CLEAR}${_PS1_USER_COLOR}\\u ${_PS1_CLEAR}@ ${_PS1_PATH_COLOR}\\w${_PS1_CLEAR}${_PS1_BRACKET_COLOR}]${_PS1_CLEAR}\$ "

export QT_STYLE_OVERRIDE=adwaita
export HISTFILE=${HOME}/.history
export HISTSIZE=10000
export BROWSER="firefox"
export LESS="-iMR"
export PAGER="less"
export EDITOR="${VIM}"
export VISUAL="${VIM}"
export FCEDIT=${EDITOR}
export CLICOLOR=1
export GNUPGHOME="${HOME}/.config/gnupg"
export PATH=${HOME}/.local/bin:${HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games

# git
alias dots="git --git-dir=~/.dotfiles/ --work-tree=~/"
alias dotscmt="dots commit -a -m"
alias dotspsh="dots push origin master"
alias gcl="git clone"
alias gcmt="git commit -a -m"
alias gpsh="git push"

# youtube-dl
alias ytdl="youtube-dl"
alias ytdlrm="ytdl --rm-cache-dir"
alias yta="ytdl -x -f bestaudio/best --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"
alias ytv="ytdl --embed-subs --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"

# preferred flags for core utilities
alias ls="\${LS} -F"
alias ll="ls -lh"
alias llnew="ll -tr"
alias llbig="ll -Sr"
alias df="df -h"
alias du="du -ch"
alias mkd="mkdir -p"

# makes life easier
alias ..="cd .."
alias ...="cd ../.."

# keepass
alias kpcli="keepassxc-cli"
alias kpopen="kpcli open ~/passwords/KeePass\\ Database.kdbx"

# editing
alias se="doas vim"
alias sepf="se /etc/pf.conf"
alias seiwm="se /etc/hostname.iwm0"
alias seunw="se /etc/unwind.conf"
alias sems="se /etc/X11/xorg.conf.d/90-modesetting.conf"
alias sesys="se /etc/sysctl.conf"

# pf
alias pfload="doas pfctl -f /etc/pf.conf"
alias pftest="doas pfctl -f /etc/pf.conf -n -vvv"

# tmux
alias tmatt="tmux attach"
alias tmksrv="tmux kill-server"
alias tmls="tmux list-sessions"

# taskwarrior
alias tcatchup="yes | task done \$(task due.before:today ids)"
alias tadd="task add"
alias tid="task ids"
alias tls="task list"
alias tdone="task done"
alias ttoday="task list due:today"
alias ttech="task list project:tech"
alias taddtech="task add project:tech"
alias tself="task list project:selfcare"
alias taddself="task add project:selfcare"
alias tshop="task list project:shopping"
alias taddshop="task add project:shopping"

# most used commands
alias cmdstat="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr"

# misc
alias mirrorsite="wget --random-wait -k -p -np -c -K -m -e robots=off -R 'index.html*'"
alias n="nnn"
alias nscan="doas nmap -v -A"
alias mpva="mpv --no-video --speed=1"
alias upnet="doas sh /etc/netstart"
alias today="date '+%Y-%m-%d'"
alias pdfman="MANPAGER=zathura man -T pdf"
alias ssgauto="ssg5 ~/builds/website_md ~/builds/website \"A Missing Link\" \"https://amissing.link\""
alias mutt="neomutt"
alias yank="xclip -selection clipboard"
alias trem="transmission-remote"

# $OpenBSD: dot.profile,v 1.7 2020/01/24 02:09:51 okan Exp $
#
# sh/ksh initialization
PS1="$(echo -e "\033[36m[\033[0m\033[35m\u \033[0m@ \033[33m\w\033[0m\033[36m]\033[0m\\$ ")"
QT_STYLE_OVERRIDE=adwaita
HISTFILE=~/.history
HISTSIZE=10000
ENV=~/.kshrc
BROWSER="firefox"
LESS="-iMR"
PAGER="less"
VISUAL="vim"
EDITOR="vim"
FCEDIT=${EDITOR}
TERM=tmux-256color
PATH=$HOME/.local/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games
export PATH TERM BROWSER PAGER VISUAL EDITOR ENV PS1 FCEDIT QT_STYLE_OVERRIDE

# $OpenBSD: dot.profile,v 1.7 2020/01/24 02:09:51 okan Exp $
#
# sh/ksh initialization
export ENV=${HOME}/.kshrc

QT_STYLE_OVERRIDE=adwaita
HISTFILE=~/.history
HISTSIZE=10000
BROWSER="firefox"
LESS="-iMR"
PAGER="less"
VISUAL="${VIM}"
EDITOR="${VIM}"
FCEDIT=${EDITOR}
CLICOLOR=1
PATH=~/.local/bin:~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games
export QT_STYLE_OVERRIDE HISTFILE HISTSIZE BROWSER LESS PAGER VISUAL EDITOR FCEDIT CLICOLOR PATH

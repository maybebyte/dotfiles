# $OpenBSD: dot.profile,v 1.7 2020/01/24 02:09:51 okan Exp $
#
# sh/ksh initialization
[ -f "${HOME}/.kshrc" ] \
  && export ENV="${HOME}/.kshrc"

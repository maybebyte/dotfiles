# $OpenBSD: dot.profile,v 1.7 2020/01/24 02:09:51 okan Exp $
#
# sh/ksh initialization
[ -r "${HOME}/.kshrc" ] \
  && export ENV="${HOME}/.kshrc"

# PATH acts funny w/ indentation
if [ -d '/data/data/com.termux' ]; then
  export PATH="${HOME}/.local/bin:/data/data/com.termux/files/usr/bin:\
/data/data/com.termux/files/usr/bin/applets"
else
  export PATH="${HOME}/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:\
/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games"
fi

export \
  BROWSER='firefox' \
  CLICOLOR=1 \
  GNUPGHOME="${HOME}/.config/gnupg" \
  HISTFILE="${HOME}/.history" \
  HISTSIZE=10000 \
  LESS='-iMR' \
  PAGER='less' \
  QT_STYLE_OVERRIDE='adwaita' \
  READER='zathura' \
  TERMINAL='xst' \
  site='https://amissing.link'

# written so it can be expanded later if needed
case "$(uname)" in
  'OpenBSD')
    export \
      markdowndir="${HOME}/builds/website_md" \
      srvdir='/var/www/htdocs/aml' \
      icons='/usr/local/share/icons/gnome/scalable'
    ;;
esac

gateway="$(netstat -rn 2>/dev/null | awk '/default/{print $2}')" \
  && export gateway

nic="$(ifconfig egress 2>/dev/null | head -1 | cut -f 1 -d ':')" \
  && export nic

userjs="$(find "${HOME}/.mozilla" -iname user.js 2>/dev/null)" \
  && export userjs

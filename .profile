# sh/ksh initialization
[ -r "${HOME}/.config/ksh/kshrc" ] \
  && export ENV="${HOME}/.config/ksh/kshrc"

export \
  BROWSER='firefox' \
  CLICOLOR=1 \
  GNUPGHOME="${HOME}/.config/gnupg" \
  HISTFILE="${HOME}/.history" \
  HISTSIZE=10000 \
  LANG='en_US.UTF-8' \
  LESS='-iMR' \
  MAILRC="${HOME}/.config/mail/mailrc" \
  PAGER='less' \
  PATH="${HOME}/.local/bin${PATH:+:${PATH}}" \
  QT_STYLE_OVERRIDE='adwaita' \
  READER='zathura' \
  TERMINAL='xst' \
  XMONAD_CACHE_DIR="${HOME}/.cache/xmonad" \
  XMONAD_CONFIG_DIR="${HOME}/.config/xmonad" \
  XMONAD_DATA_DIR="${HOME}/.local/share/xmonad" \
  site='https://amissing.link'

# written so it can be expanded later if needed
case "$(uname)" in
  'OpenBSD')
    export \
      markdowndir="${HOME}/builds/website_md" \
      srvdir='/var/www/htdocs/aml' \
      gnome_icon_dir='/usr/local/share/icons/gnome/scalable'
    ;;
esac

gateway="$(netstat -rn 2>/dev/null | awk '/default/{print $2}')" \
  && export gateway

nic="$(ifconfig egress 2>/dev/null | head -1 | cut -f 1 -d ':')" \
  && export nic

userjs="$(find "${HOME}/.mozilla" -iname user.js 2>/dev/null)" \
  && export userjs

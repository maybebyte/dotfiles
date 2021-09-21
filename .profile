# use nvim if it's installed, vi otherwise
if [ -x "$(command -v 'nvim')" ]; then
  export EDITOR='nvim'

else
  export EDITOR='vi'

fi

# use colorls if it's installed, ls otherwise
if [ -x "$(command -v 'colorls')" ]; then
  export ls='colorls'

else
  export ls='ls'

fi

GPG_TTY="$(tty)" && export GPG_TTY

export                                          \
  BROWSER='firefox'                             \
  CLICOLOR=1                                    \
  FCEDIT="${EDITOR}"                            \
  VISUAL="${EDITOR}"                            \
  GNUPGHOME="${HOME}/.config/gnupg"             \
  HISTFILE="${HOME}/.history"                   \
  HISTSIZE=10000                                \
  LC_CTYPE='en_US.UTF-8'                        \
  LESS='-iMR'                                   \
  LESSSECURE=1                                  \
  MAILRC="${HOME}/.config/mail/mailrc"          \
  PAGER='less'                                  \
  PATH="${HOME}/.local/bin${PATH:+:${PATH}}"    \
  QT_STYLE_OVERRIDE='adwaita'                   \
  READER='zathura'                              \
  TERMINAL='xst'                                \
  XMONAD_CACHE_DIR="${HOME}/.cache/xmonad"      \
  XMONAD_CONFIG_DIR="${HOME}/.config/xmonad"    \
  XMONAD_DATA_DIR="${HOME}/.local/share/xmonad" \
  site='https://amissing.link'

# logging
export dotfiles_log="${HOME}/.local/share/dotfiles.log"
mkdir -p "${dotfiles_log%/*}" && :>"${dotfiles_log}"

# OS specific actions
# written so it can be expanded later if needed
case "$(uname)" in

  'OpenBSD')
    export \
      markdowndir="${HOME}/builds/website_md" \
      srvdir='/var/www/htdocs/aml'

    gateway="$(netstat -rn 2>/dev/null | awk -- '/^default/{print $2}')" \
      && export gateway

    nic="$(ifconfig egress 2>/dev/null | head -1 | cut -f 1 -d ':')" \
      && export nic

    ;;

  *)
    # if not a recognized OS, do nothing

    ;;

esac

case "$(hostname -s)" in

  'aphrodite'|'lain')
    [ -x "$(command -v 'gpg-agent')" ] && eval "$(gpg-agent --daemon)"

    ;;

  *)
    # only defined hosts should launch a gpg-agent

    ;;

esac

# sh/ksh initialization
#
# this should come last in .profile so that one can assume
# that any variables exported in .profile will carry over to
# ksh(1).
[ -r "${HOME}/.config/ksh/kshrc" ] \
  && export ENV="${HOME}/.config/ksh/kshrc"

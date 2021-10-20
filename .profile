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

# PATH parameter expansion explanation:
# https://unix.stackexchange.com/a/415028
#
# the extra colon is intentional, it's the delimiter for PATH.
export                                          \
  BROWSER='lynx'                                \
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
  XMONAD_CACHE_DIR="${HOME}/.cache/xmonad"      \
  XMONAD_CONFIG_DIR="${HOME}/.config/xmonad"    \
  XMONAD_DATA_DIR="${HOME}/.local/share/xmonad" \
  site='https://amissing.link'

# logging
export dotfiles_log="${HOME}/.local/share/dotfiles.log"
mkdir -p -- "${dotfiles_log%/*}"
:>"${dotfiles_log}"

# OS specific actions
# written so it can be expanded later if needed
case "$(uname)" in

  'OpenBSD')
    gateway="$(netstat -rn 2>/dev/null | awk -- '/^default/{print $2}')"
    export gateway

    nic="$(ifconfig egress 2>/dev/null | head -1 | cut -f 1 -d ':')"
    export nic

    ;;

  *)
    # if not a recognized OS, do nothing

    ;;

esac

# host-specific actions
case "$(hostname -s)" in

  'aphrodite'|'lain')
    [ -x "$(command -v 'gpg-agent')" ] && eval "$(gpg-agent --daemon)"

    export \
      markdowndir="${HOME}/builds/website_md" \
      srvdir='/var/www/htdocs/aml'

    ;;

  *)
    # if the hostname doesn't match, do nothing

    ;;

esac

# sh/ksh initialization
#
# this should come last in .profile so that one can assume
# that any variables exported in .profile will carry over to
# ksh(1).
if [ -r "${HOME}/.config/ksh/kshrc" ]; then
  export ENV="${HOME}/.config/ksh/kshrc"

else
  echo "${HOME}/.config/ksh/kshrc not readable." 2>>"${dotfiles_log}" >&2

fi

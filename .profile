# use nvim if it's installed, vi otherwise
if [ -x "$(command -v -- 'nvim')" ]; then
  export EDITOR='nvim'

else
  export EDITOR='vi'

fi

# use colorls if it's installed, ls otherwise
if [ -x "$(command -v -- 'colorls')" ]; then
  export LS='colorls'

else
  export LS='ls'

fi

export                                          \
  BROWSER='lynx'                                \
  CLICOLOR=1                                    \
  FCEDIT="${EDITOR}"                            \
  VISUAL="${EDITOR}"                            \
  HISTFILE="${HOME}/.history"                   \
  HISTSIZE=10000                                \
  LC_CTYPE='en_US.UTF-8'                        \
  LESS='-iMR'                                   \
  LESSSECURE=1                                  \
  PAGER='less'                                  \
  XDG_BIN_HOME="${HOME}/.local/bin"             \
  XDG_CACHE_HOME="${HOME}/.cache"               \
  XDG_CONFIG_HOME="${HOME}/.config"             \
  XDG_DATA_HOME="${HOME}/.local/share"          \
  XDG_STATE_HOME="${HOME}/.local/state"         \
  SITE='https://amissing.link'

# these have to come after XDG_* are defined
export                                          \
  GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"          \
  MAILRC="${XDG_CONFIG_HOME}/mail/mailrc"       \
  XMONAD_CACHE_DIR="${XDG_CACHE_HOME}/xmonad"   \
  XMONAD_CONFIG_DIR="${XDG_CONFIG_HOME}/xmonad" \
  XMONAD_DATA_DIR="${XDG_DATA_HOME}/xmonad"

# logging
export DOTFILES_LOG="${XDG_DATA_HOME}/dotfiles.log"
mkdir -p -- "${DOTFILES_LOG%/*}"
:>"${DOTFILES_LOG}"

# OS specific actions
# written so it can be expanded later if needed
case "$(uname)" in

  'OpenBSD')
    GATEWAY="$(netstat -rn 2>/dev/null | awk -- '/^default/{print $2}')"
    export GATEWAY

    NIC="$(ifconfig egress 2>/dev/null | head -1 | cut -f 1 -d ':')"
    export NIC

    # prepend /usr/games and ~/.local/bin to PATH
    #
    # PATH parameter expansion explanation:
    # https://unix.stackexchange.com/a/415028
    #
    # the extra colon is intentional, it's the delimiter for PATH.
    export PATH="${XDG_BIN_HOME}:/usr/games${PATH:+:${PATH}}"

    ;;

  *)
    # no /usr/games if not OpenBSD
    export PATH="${XDG_BIN_HOME}${PATH:+:${PATH}}"

    ;;

esac

# host-specific actions
case "$(hostname -s)" in

  'aphrodite'|'lain')
    [ -x "$(command -v -- 'gpg-agent')" ] && eval "$(gpg-agent --daemon)"

    export \
      MARKDOWNDIR="${HOME}/builds/website_md" \
      SRVDIR='/var/www/htdocs/aml'

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
if [ -r "${XDG_CONFIG_HOME}/ksh/kshrc" ]; then
  export ENV="${XDG_CONFIG_HOME}/ksh/kshrc"

else
  echo "${XDG_CONFIG_HOME}/ksh/kshrc not readable." 2>>"${DOTFILES_LOG}" >&2

fi

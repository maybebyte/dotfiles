. ~/.profile

umask 077

set -o \
  braceexpand \
  vi \
  vi-esccomplete \
  vi-show8 \
  vi-tabcomplete

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

# swaps colors when uid is 0, i.e. root
case "$(id -u)" in
  0) _PS1_USER_COLOR='\[\033[1;33m\]' _PS1_PATH_COLOR='\[\033[1;35m\]' ;;
  *) _PS1_USER_COLOR='\[\033[1;35m\]' _PS1_PATH_COLOR='\[\033[1;33m\]' ;;
esac

_PS1_BRACKET_COLOR='\[\033[1;36m\]'
_PS1_CLEAR='\[\033[0m\]'

PS1="${_PS1_BRACKET_COLOR}[${_PS1_CLEAR}${_PS1_USER_COLOR}\\u ${_PS1_CLEAR}@ ${_PS1_PATH_COLOR}\\w${_PS1_CLEAR}${_PS1_BRACKET_COLOR}]${_PS1_CLEAR}\$ "

export \
  QT_STYLE_OVERRIDE=adwaita \
  HISTFILE=${HOME}/.history \
  HISTSIZE=10000 \
  BROWSER="firefox" \
  LESS="-iMR" \
  PAGER="less" \
  EDITOR="${VIM}" \
  VISUAL="${VIM}" \
  FCEDIT=${EDITOR} \
  CLICOLOR=1 \
  GNUPGHOME="${HOME}/.config/gnupg" \
  PATH=${HOME}/.local/bin:${HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games

# git
alias \
  dots="git --git-dir=~/.dotfiles/ --work-tree=~/" \
  dotscmt="dots commit -a -m" \
  dotspsh="dots push origin master" \
  gcl="git clone" \
  gcmt="git commit -a -m" \
  gpsh="git push"

# youtube-dl
alias \
  ytdl="youtube-dl" \
  ytdlrm="ytdl --rm-cache-dir" \
  yta="ytdl -x -f bestaudio/best --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'" \
  ytv="ytdl --embed-subs --embed-thumbnail -ic --add-metadata -o '~/Downloads/%(title)s.%(ext)s'"

# preferred flags for core utilities
alias \
  ls="\${LS} -F" \
  ll="ls -lh" \
  llnew="ll -tr" \
  llbig="ll -Sr" \
  df="df -h" \
  du="du -ch" \
  mkd="mkdir -p"

# makes life easier
alias \
  ..="cd .." \
  ...="cd ../.."

# keepass
alias \
  kpcli="keepassxc-cli" \
  kpopen="kpcli open ~/passwords/KeePass\\ Database.kdbx"

# editing
alias \
  se="doas vim" \
  sepf="se /etc/pf.conf" \
  seiwm="se /etc/hostname.iwm0" \
  seunw="se /etc/unwind.conf" \
  sems="se /etc/X11/xorg.conf.d/90-modesetting.conf" \
  sesys="se /etc/sysctl.conf"

# pf
alias \
  pfload="doas pfctl -f /etc/pf.conf" \
  pftest="pfload -n -vvv"

# tmux
alias \
  tmatt="tmux attach" \
  tmksrv="tmux kill-server" \
  tmls="tmux list-sessions"

# taskwarrior
alias \
  tcatchup="yes | task done \$(task due.before:today ids)" \
  tadd="task add" \
  tid="task ids" \
  tls="task list" \
  tdone="task done" \
  ttoday="tls due:today" \
  ttech="tls project:tech" \
  tself="tls project:selfcare" \
  tshop="tls project:shopping" \
  taddtech="tadd project:tech" \
  taddself="tadd project:selfcare" \
  taddshop="tadd project:shopping"

# misc
alias \
  mirrorsite="wget --random-wait -k -p -np -c -K -m -e robots=off -R 'index.html*'" \
  cmdstat="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr" \
  n="nnn" \
  nscan="doas nmap -v -A" \
  mpva="mpv --no-video --speed=1" \
  upnet="doas sh /etc/netstart" \
  today="date '+%Y-%m-%d'" \
  pdfman="MANPAGER=zathura man -T pdf" \
  ssgauto="ssg5 ~/builds/website_md ~/builds/website \"A Missing Link\" \"https://amissing.link\"" \
  mutt="neomutt" \
  yank="xclip -selection clipboard" \
  trem="transmission-remote" \
  off="doas shutdown -p now"

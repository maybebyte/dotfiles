. ~/.profile

# more restricted permissions - 0700 for dirs, 0600 for files
umask 077

# ksh options
set -o \
  braceexpand \
  vi \
  vi-esccomplete \
  vi-show8 \
  vi-tabcomplete

# use vim if it's installed, vi otherwise
case "$(command -v vim)" in
  */vim) vim="vim" ;;
  *)     vim="vi"  ;;
esac

# use colorls if it's installed, ls otherwise
if command -v colorls > /dev/null; then
  ls='colorls'
else
  ls='ls'
fi

# swaps colors when uid is 0, i.e. root
case "$(id -u)" in
  0) _ps1_user='\[\033[1;33m\]' _ps1_path='\[\033[1;35m\]' ;;
  *) _ps1_user='\[\033[1;35m\]' _ps1_path='\[\033[1;33m\]' ;;
esac

_ps1_bracket='\[\033[1;36m\]'
_ps1_clear='\[\033[0m\]'

PS1="${_ps1_bracket}[${_ps1_clear}${_ps1_user}\\u \
${_ps1_clear}@ ${_ps1_path}\\w${_ps1_clear}${_ps1_bracket}]\
${_ps1_clear}\$ "

# PATH acts funny w/ indentation
export \
  QT_STYLE_OVERRIDE=adwaita \
  HISTFILE=${HOME}/.history \
  HISTSIZE=10000 \
  BROWSER="firefox" \
  LESS="-iMR" \
  PAGER="less" \
  EDITOR="${vim}" \
  VISUAL="${EDITOR}" \
  FCEDIT=${EDITOR} \
  CLICOLOR=1 \
  GNUPGHOME="${HOME}/.config/gnupg" \
  PATH=${HOME}/.local/bin:${HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:\
/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games

# git
alias \
  d="git --git-dir=~/.dotfiles/ --work-tree=~/" \
  da="d add" \
  dcmt="d commit -a -m" \
  ddiff="d diff" \
  dls="d ls-files ~" \
  dpsh="d push origin master" \
  ds="d status" \
  g="git" \
  ga="g add" \
  gcl="g clone" \
  gcmt="g commit -a -m" \
  gdiff="g diff" \
  gls="git ls-files" \
  gpsh="g push" \
  gs="g status"

# youtube-dl
alias \
  yt="youtube-dl --add-metadata -ic --embed-thumbnail -o '~/Downloads/%(title)s.%(ext)s'" \
  ytrm="yt --rm-cache-dir" \
  yta="yt -x -f bestaudio/best " \
  ytv="yt --embed-subs"

# preferred flags for base utilities
alias \
  c="clear" \
  ls="\${ls} -F" \
  ll="ls -lh" \
  llb="ll -Sr" \
  lln="ll -tr" \
  df="df -h" \
  du="du -ch" \
  mkd="mkdir -p"

# gotta go fast
alias \
  ..="cd .." \
  ...="cd ../.."

# keepass
alias \
  kp="keepassxc-cli" \
  kpopen="kp open ~/passwords/KeePass\\ Database.kdbx"

# editing
alias \
  e="\${EDITOR}" \
  se="doas \${EDITOR}" \
  seiwm="se /etc/hostname.iwm0" \
  sems="se /etc/X11/xorg.conf.d/90-modesetting.conf" \
  sepf="se /etc/pf.conf" \
  seunw="se /etc/unwind.conf" \
  sesys="se /etc/sysctl.conf"

# pf
alias \
  pfl="doas pfctl -f /etc/pf.conf" \
  pft="pfl -n -vvv"

# tmux
alias \
  tma="tmux attach" \
  tmk="tmux kill-server" \
  tmls="tmux list-sessions"

# taskwarrior
alias \
  t="task" \
  ta="t add" \
  td="t done" \
  tid="t ids" \
  tls="t list" \
  tm="t modify" \
  tt="tls due:today" \
  tself="tls project:selfcare" \
  tshop="tls project:shopping" \
  ttech="tls project:tech" \
  taself="ta project:selfcare" \
  tashop="ta project:shopping" \
  tatech="ta project:tech" \
  tc="yes | td \$(task due.before:today ids)"

# sec
alias \
  sspl="searchsploit" \
  nk="nikto -output nikto-\$(today).txt -host"

# web-related
alias \
  mirror="wget --random-wait -k -p -np -c -K -m -e robots=off -R 'index.html*'" \
  gensite="ssg5 ~/builds/website_md ~/builds/website \"A Missing Link\" \"https://amissing.link\"" \
  m="neomutt" \
  mpva="mpv --no-video --speed=1" \
  stcli="speedtest-cli" \
  trem="transmission-remote"

# system
alias \
  off="doas shutdown -p now" \
  offon="doas shutdown -r now" \
  offif="doas ifconfig egress down" \
  onif="doas ifconfig egress up" \
  offonif="offif && onif" \
  showif="ifconfig egress" \
  upnet="doas sh /etc/netstart"

# misc handy things
alias \
  cmdstat="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr" \
  n="nnn" \
  pdfman="MANPAGER=zathura man -T pdf" \
  today="date '+%Y-%m-%d'" \
  yank="xclip -selection clipboard"

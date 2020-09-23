. "${HOME}/.profile"

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
  BROWSER="firefox" \
  CLICOLOR=1 \
  EDITOR="${vim}" \
  FCEDIT=${EDITOR} \
  GNUPGHOME="${HOME}/.config/gnupg" \
  HISTFILE=${HOME}/.history \
  HISTSIZE=10000 \
  LESS="-iMR" \
  PAGER="less" \
  PATH=${HOME}/.local/bin:${HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:\
/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games \
  QT_STYLE_OVERRIDE=adwaita \
  VISUAL="${EDITOR}"

# assorted
alias \
  cmdstat="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr" \
  mus="ncmpcpp" \
  n="nnn" \
  pdfman="MANPAGER=zathura man -T pdf" \
  today="date '+%Y-%m-%d'" \
  yank="xclip -selection clipboard"

# base utilities
alias \
  c="clear" \
  df="df -h" \
  du="du -ch" \
  ll="ls -lh" \
  llb="ll -Sr" \
  lln="ll -tr" \
  ls="\${ls} -F" \
  lsd="find . -iname \".[^.]*\" -maxdepth 1" \
  mkd="mkdir -p"

# editing
alias \
  e="\${EDITOR}" \
  ek="e \${HOME}/.kshrc" \
  se="doas \${EDITOR}" \
  seiwm="se /etc/hostname.iwm0" \
  sems="se /etc/X11/xorg.conf.d/90-modesetting.conf" \
  sepf="se /etc/pf.conf" \
  seunw="se /etc/unwind.conf" \
  sesys="se /etc/sysctl.conf"

# git
alias \
  d="git --git-dir=\${HOME}/.dotfiles/ --work-tree=\${HOME}/" \
  da="d add" \
  dcmt="d commit -a -m" \
  ddiff="d diff" \
  dls="d ls-files \${HOME}" \
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

# keepass
alias \
  kp="keepassxc-cli" \
  kpo="kp open \${HOME}/passwords/KeePass\\ Database.kdbx"

# navigation
alias \
  ..="cd .." \
  ...="cd ../.."

# pf
alias \
  pfc="doas pfctl" \
  pfi="pfs info" \
  pfif="pfs Interfaces" \
  pfl="pfc -f /etc/pf.conf" \
  pfoff="pfc -d" \
  pfon="pfc -e" \
  pfs="pfc -s" \
  pfr="pfs rules" \
  pft="pfl -n -vvv"

# taskwarrior
alias \
  t="task" \
  ta="t add" \
  taself="ta project:selfcare" \
  tashop="ta project:shopping" \
  tatech="ta project:tech" \
  tc="t config" \
  td="t done" \
  tid="t ids" \
  tls="t list" \
  tmod="t modify" \
  tself="tls project:selfcare" \
  tshop="tls project:shopping" \
  tt="tls due:today" \
  ttech="tls project:tech" \
  tup="yes | td \$(task due.before:today ids)"

# tmux
alias \
  tm="tmux" \
  tma="tm attach" \
  tmk="tm kill-server" \
  tml="tm list-sessions"

# sec
alias \
  nk="nikto -output nikto-\$(today).txt -host" \
  sspl="searchsploit"

# system
alias \
  off="doas shutdown -p now" \
  offif="doas ifconfig egress down" \
  onif="doas ifconfig egress up" \
  res="doas shutdown -r now" \
  resif="offif && onif" \
  showif="ifconfig egress" \
  upnet="doas sh /etc/netstart"

# web
alias \
  gensite="ssg5 \${HOME}/builds/website_md \${HOME}/builds/website \"A Missing Link\" \"https://amissing.link\"" \
  m="neomutt" \
  mirror="wget --random-wait -k -p -np -c -K -m -e robots=off -R 'index.html*'" \
  mpva="mpv --no-video --speed=1" \
  stcli="speedtest-cli" \
  trem="transmission-remote"

# youtube-dl
alias \
  yt="youtube-dl --add-metadata -ic --embed-thumbnail -o '\${HOME}/Downloads/%(title)s.%(ext)s'" \
  yta="yt -x -f bestaudio/best " \
  ytrm="yt --rm-cache-dir" \
  ytv="yt --embed-subs"

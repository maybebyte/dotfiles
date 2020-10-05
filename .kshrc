. "${HOME}/.profile"

# more restricted permissions - 0700 for dirs, 0600 for files
umask 077

# ksh options
set -o \
  vi \
  vi-esccomplete

if [ "$(uname -s)" = "OpenBSD" ]; then
  set -o vi-show8
fi

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

if [ "$(uname -s)" = "OpenBSD" ]; then
  # swaps colors when uid is 0, i.e. root
  case "$(id -u)" in
    0) _ps1_user='\[\033[1;33m\]' _ps1_path='\[\033[1;35m\]' ;;
    *) _ps1_user='\[\033[1;35m\]' _ps1_path='\[\033[1;33m\]' ;;
  esac

  _ps1_bracket='\[\033[1;36m\]'
  _ps1_clear='\[\033[0m\]'

# unintended spaces occur w/ indentation
PS1="${_ps1_bracket}[${_ps1_clear}${_ps1_user}\\u \
${_ps1_clear}@ ${_ps1_path}\\w${_ps1_clear}${_ps1_bracket}]\
${_ps1_clear}\$ "
fi

# PATH acts funny w/ indentation
export \
  BROWSER="iridium" \
  CLICOLOR=1 \
  EDITOR="${vim}" \
  FCEDIT="${EDITOR}" \
  GNUPGHOME="${HOME}/.config/gnupg" \
  HISTFILE="${HOME}/.history" \
  HISTSIZE=10000 \
  LESS="-iMR" \
  PAGER="less" \
  PATH="${HOME}/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:\
/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games" \
  QT_STYLE_OVERRIDE="adwaita" \
  READER="zathura" \
  TERMINAL="st" \
  VISUAL="${EDITOR}" \
  site="https://amissing.link"

gateway=$(netstat -rn 2> /dev/null | awk '/default/{print $2}') \
  && export gateway

nic=$(ifconfig egress 2> /dev/null | head -1 | cut -f 1 -d ':') \
  && export nic

userjs=$(find "${HOME}/.mozilla" -iname user.js 2> /dev/null) \
  && export userjs

# assorted
alias \
  cmdstat="history -n 0 | sort | uniq -c | sort -n | tail -10 | sort -nr" \
  exifrm="exiftool -all= " \
  mus="ncmpcpp" \
  n="nnn" \
  pdfman="MANPAGER=zathura man -T pdf" \
  o="mimeopen" \
  today="date '+%Y-%m-%d'" \
  unlockhdd="doas bioctl -c C -l sd2a softraid0" \
  yank="xclip -selection clipboard"

# base utilities
alias \
  c="clear" \
  df="df -h" \
  du="du -h" \
  la="ll -A" \
  ll="ls -lh" \
  llb="ll -Sr" \
  lln="ll -tr" \
  ls="\${ls} -F" \
  lsd="find . -maxdepth 1 -iname \".[^.]*\"" \
  mkd="mkdir -p" \
  shre=". \${HOME}/.kshrc" \
  size="du -s"

# editing
alias \
  e="\${EDITOR}" \
  edu="e -d \${HOME}/builds/ghacks-user.js/user.js \${userjs}" \
  ef="e \${HOME}/.config/fontconfig/fonts.conf" \
  ek="e \${HOME}/.kshrc" \
  em="e \${HOME}/.config/neomutt/neomuttrc" \
  es="e \${HOME}/.config/sxhkd/sxhkdrc" \
  eu="e \${userjs}" \
  ev="e \${HOME}/.vimrc" \
  exm="e \${HOME}/.xmonad/xmonad.hs" \
  exmb="e \${HOME}/.config/xmobar/xmobarrc" \
  exr="e \${HOME}/.Xresources" \
  exs="e \${HOME}/.xsession" \
  se="doas \${EDITOR}" \
  sehn="se /etc/hostname.\${nic}" \
  sehs="se /etc/hosts" \
  sems="se /etc/X11/xorg.conf.d/90-modesetting.conf" \
  sepf="se /etc/pf.conf" \
  seres="se /etc/resolv.conf" \
  sesys="se /etc/sysctl.conf" \
  seunw="se /etc/unwind.conf"

# git
alias \
  d="git --git-dir=\${HOME}/.dotfiles/ --work-tree=\${HOME}/" \
  da="d add" \
  dcmt="d commit -a -m" \
  ddiff="d diff" \
  dgr="d grep" \
  dlg="d log" \
  dls="d ls-files \${HOME}" \
  dpsh="d push origin master" \
  dre="d restore" \
  ds="d status" \
  g="git" \
  ga="g add" \
  gcl="g clone" \
  gcmt="g commit -a -m" \
  gdiff="g diff" \
  ggr="g grep" \
  glg="g log" \
  gls="g ls-files" \
  gpsh="g push" \
  gre="g restore" \
  gs="g status"

# keepass
alias \
  kp="keepassxc-cli" \
  kpo="kp open \${HOME}/passwords/KeePass\\ Database.kdbx"

# navigation
alias \
  ..="cd .." \
  ...="cd ../.."

# networking
alias \
  exip="curl ifconfig.me && printf \"%s\\n\"" \
  nicdel="doas ifconfig \${nic} delete" \
  nicoff="doas ifconfig \${nic} down" \
  nicon="doas ifconfig \${nic} up" \
  nicre="nicoff && nicon" \
  nicshow="ifconfig \${nic}" \
  nictail="doas tcpdump -i \${nic} -p" \
  nsr6="netstat -rn -f inet6" \
  nsr="netstat -rn -f inet" \
  ntst6="netstat -n -f inet6" \
  ntst="netstat -n -f inet" \
  ntstl6="netstat -ln -f inet6" \
  ntstl="netstat -ln -f inet" \
  renet="doas sh /etc/netstart" \
  renetnic="renet \${nic}" \
  sysnet="systat netstat" \
  tlan="ping \${gateway}" \
  tnet="ping \${site##*//}"

# pf
alias \
  pfc="doas pfctl" \
  pfd="doas tcpdump -n -e -ttt -r /var/log/pflog" \
  pfi="pfs info" \
  pfif="pfs Interfaces" \
  pfiif="pfif -vv -i \${nic}" \
  pfl="pfc -f /etc/pf.conf" \
  pfoff="pfc -d" \
  pfon="pfc -e" \
  pfr="pfs rules" \
  pfs="pfc -s" \
  pft="pfl -n -vvv" \
  pftail="doas tcpdump -n -e -ttt -i pflog0" \
  pftailb="doas tcpdump -n -e -ttt -i pflog0 action block" \
  pftailp="doas tcpdump -n -e -ttt -i pflog0 action pass"

# pkg
alias \
  pkgL="pkgq -L" \
  pkga="doas pkg_add" \
  pkgas="doas pkg_add -D snap" \
  pkgd="doas pkg_delete" \
  pkgda="pkgd -a" \
  pkgl="pkgq -mz" \
  pkgq="pkg_info" \
  pkgqs="pkg_info -D snap" \
  pkgs="pkgq -Q" \
  pkgss="pkgq -D snap -Q" \
  pkgup="pkga -u"

# sec
alias \
  nk="nikto -output nikto-\$(today).txt -host" \
  sc="doas nmap -sn" \
  sspl="searchsploit"

# service management
alias \
  rc="doas rcctl" \
  rcd="rc disable" \
  rce="rc enable" \
  rcg="rcctl get" \
  rclfail="rc ls failed" \
  rclon="rcctl ls on" \
  rclstr="rc ls started" \
  rcre="rc restart" \
  rcset="rc set" \
  rcst="rc stop" \
  rcstr="rc start" \
  rcstrf="rc -f start"

# system
alias \
  chksn="w3m \$(cat /etc/installurl)/snapshots/amd64" \
  dtsu="doas shutdown now" \
  dsklab="doas disklabel -p g" \
  off="doas shutdown -p now" \
  re="doas shutdown -r now" \
  readmsg="doas less /var/log/messages" \
  up="uptime"

# taskwarrior
alias \
  t="task" \
  ta="t add" \
  taself="ta project:selfcare" \
  tashop="ta project:shopping" \
  tatech="ta project:tech" \
  tc="t config" \
  td="t done" \
  tdel="t delete" \
  tdue="task due.before:today ids" \
  tid="t ids" \
  tls="t list" \
  tmod="t modify" \
  tself="tls project:selfcare" \
  tshop="tls project:shopping" \
  tt="tls due:today" \
  ttech="tls project:tech" \
  tup="td \$(tdue)"

# tmux
alias \
  tm="tmux" \
  tma="tm attach" \
  tmk="tm kill-server" \
  tml="tm list-sessions"

# web
alias \
  dl="ftp -V -C -n" \
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

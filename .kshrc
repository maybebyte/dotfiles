# shellcheck disable=SC2034

# more restricted permissions - 0700 for dirs, 0600 for files
umask 077

if command -v tmux >/dev/null 2>&1; then
  # if not inside a tmux session, and if no session is started, start a new
  # session
  [ -z "${TMUX}" ] && (tmux attach >/dev/null 2>&1 || tmux)
fi

# ksh options
set -o \
  vi \
  vi-esccomplete

# use vim if it's installed, vi otherwise
if command -v nvim >/dev/null; then
  EDITOR="nvim"
else
  EDITOR="vi"
fi

# use colorls if it's installed, ls otherwise
if command -v colorls >/dev/null; then
  ls="colorls"
else
  ls="ls"
fi

if printf "%s" "${KSH_VERSION}" | grep -qi "pd ksh"; then
  set -o vi-show8
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
${_ps1_clear}\\$ "
fi

# PATH acts funny w/ indentation
export \
  BROWSER="firefox" \
  CLICOLOR=1 \
  FCEDIT="${EDITOR}" \
  GNUPGHOME="${HOME}/.config/gnupg" \
  HISTFILE="${HOME}/.history" \
  HISTSIZE=10000 \
  LESS="-iMR" \
  PAGER="less" \
  QT_STYLE_OVERRIDE="adwaita" \
  READER="zathura" \
  TERMINAL="st" \
  VISUAL="${EDITOR}" \
  site="https://amissing.link" \
  wallpaper="${HOME}/pictures/wallpapers/wallhaven-dgow5j.jpg"

# termux compatibility
if [ -d "/data/data/com.termux" ]; then
  export PATH="${HOME}/.local/bin:/data/data/com.termux/files/usr/bin:\
/data/data/com.termux/files/usr/bin/applets"
else
  export PATH="${HOME}/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:\
/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games"
fi

gateway=$(netstat -rn 2>/dev/null | awk '/default/{print $2}') \
  && export gateway

nic=$(ifconfig egress 2>/dev/null | head -1 | cut -f 1 -d ':') \
  && export nic

userjs=$(find "${HOME}/.mozilla" -iname user.js 2>/dev/null) \
  && export userjs

# assorted
alias \
  b64="openssl enc -base64" \
  chksn="w3m \$(head -1 /etc/installurl)/snapshots/amd64" \
  cmdstat="history -n 0 | sort | uniq -c | sort -n | tail | sort -nr" \
  exifrm="exiftool -all= " \
  mus="ncmpcpp" \
  n="nnn" \
  nb="newsboat" \
  o="mimeopen" \
  rmus="mus --host 192.168.1.79" \
  today="date '+%Y-%m-%d'" \
  tuir="torsocks tuir" \
  unlockhdd="doas bioctl -c C -l sd2a softraid0" \
  yank="xclip -selection clipboard"

# basic utilities
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
  shre=". \${HOME}/.kshrc"

# editing
alias \
  e="\${EDITOR}" \
  eduj="e -d \${HOME}/builds/ghacks-user.js/user.js \${userjs}" \
  efont="e \${HOME}/.config/fontconfig/fonts.conf" \
  ek="e \${HOME}/.kshrc" \
  empv="e \${HOME}/.config/mpv/mpv.conf" \
  emusb="e \${HOME}/.config/ncmpcpp/bindings" \
  emusc="e \${HOME}/.config/ncmpcpp/config" \
  enb="e \${HOME}/.config/newsboat/config" \
  enbu="e \${HOME}/.config/newsboat/urls" \
  enm="e \${HOME}/.config/neomutt/neomuttrc" \
  esxh="e \${HOME}/.config/sxhkd/sxhkdrc" \
  etm="e \${HOME}/.tmux.conf" \
  euj="e \${userjs}" \
  ev="e \${HOME}/.config/nvim/init.vim" \
  exm="e \${HOME}/.xmonad/xmonad.hs" \
  exmb="e \${HOME}/.config/xmobar/xmobarrc" \
  exr="e \${HOME}/.Xresources" \
  exs="e \${HOME}/.xsession" \
  se="doas \${EDITOR}" \
  sehn="se /etc/hostname.\${nic}" \
  sehst="se /etc/hosts" \
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
  gpsh="g push origin master" \
  gre="g restore" \
  gs="g status"

# keepass
alias \
  kp="keepassxc-cli" \
  kpo="kp open \${HOME}'/passwords/KeePass Database.kdbx'"

# man
alias \
  apr="apropos" \
  pdfman="MANPAGER=zathura man -T pdf"

aprv() {
  apr -S "$(uname -m)" any="${1}"
}

cht() {
  curl cht.sh/"${1}"
}

# navigation
alias \
  ..="cd .." \
  ...="cd ../.." \
  cdweb="cd ~/builds/website_md"

# networking
alias \
  exip="curl ifconfig.me && printf '%s\\n'" \
  nicdel="doas ifconfig \${nic} delete" \
  nicoff="doas ifconfig \${nic} down" \
  nicon="doas ifconfig \${nic} up" \
  nicre="nicoff && nicon" \
  nicshow="ifconfig \${nic}" \
  nictail="doas tcpdump -p -i \${nic}" \
  ntstr6="netstat -rn -f inet6" \
  ntstr="netstat -rn -f inet" \
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
  pfdump="doas tcpdump -n -e -ttt -r /var/log/pflog" \
  pfdumpb="doas tcpdump -n -e -ttt -r /var/log/pflog action block" \
  pfdumpp="doas tcpdump -n -e -ttt -r /var/log/pflog action pass" \
  pfif="pfshow Interfaces" \
  pfinfo="pfshow info" \
  pfload="pfc -f /etc/pf.conf" \
  pfnic="pfif -vv -i \${nic}" \
  pfoff="pfc -d" \
  pfon="pfc -e" \
  pfrules="pfshow rules" \
  pfshow="pfc -s" \
  pftest="pfload -n -vvv" \
  pftail="doas tcpdump -n -e -ttt -i pflog0" \
  pftailb="pftail action block" \
  pftailp="pftail action pass"

# pkg
alias \
  pkgL="pkgq -L" \
  pkga="doas pkg_add" \
  pkgd="doas pkg_delete" \
  pkgda="pkgd -a" \
  pkgl="pkgq -mz" \
  pkgq="pkg_info" \
  pkgqo="pkg_info -E" \
  pkgs="pkgq -Q" \
  pkgsize="pkg_info -s" \
  pkgup="pkga -u"

# sec
alias \
  nk="nikto -output nikto-\$(today).txt -host" \
  scan="doas nmap -sn" \
  sspl="searchsploit"

# service management
alias \
  rc="doas rcctl" \
  rcoff="rc disable" \
  rcon="rc enable" \
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
  dsklab="doas disklabel -p g" \
  dtsu="doas shutdown now" \
  off="doas shutdown -p now" \
  re="doas shutdown -r now" \
  up="uptime"

# taskwarrior
alias \
  t="task" \
  ta="t add" \
  tafin="ta project:finances" \
  tagroc="ta project:groceries" \
  taedu="ta project:education" \
  taself="ta project:selfcare" \
  tashop="ta project:shopping" \
  tatech="ta project:tech" \
  tconf="t config" \
  td="t done" \
  tdel="t delete" \
  tdue="task due.before:today ids" \
  tedu="tls project:education" \
  tfin="tls project:finances" \
  tgroc="tls project:groceries" \
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

# viewing log files
alias \
  readhttp="less /var/www/logs/access.log" \
  readmail="doas less /var/log/maillog" \
  readmsg="less /var/log/messages" \
  readsec="doas less /var/log/secure" \
  readx="less /var/log/Xorg.0.log" \
  tailhttp="tail -f /var/www/logs/access.log" \
  tailmail="doas tail -f /var/log/maillog" \
  tailmsg="doas tail -f /var/log/messages"

# web
alias \
  anonftp="torsocks ftp -n -U ''" \
  anonsh="torsocks --shell" \
  ftp="ftp -n -U ''" \
  gensite="ssg5 \${HOME}/builds/website_md \${HOME}/builds/website \"A Missing Link\" \"https://amissing.link\"" \
  m="neomutt" \
  mirror="wget --random-wait -kpcKEm -np -e robots=off -R 'index.html*'" \
  mpva="mpv --no-video --speed=1" \
  stcli="speedtest-cli" \
  trem="transmission-remote"

anonread() {
  anonftp -o - "${1}" | zathura -
}

# youtube-dl
alias \
  yt="youtube-dl --add-metadata -ic --embed-thumbnail -o '\${HOME}/Downloads/%(title)s.%(ext)s'" \
  yta="yt -x -f bestaudio/best " \
  ytdesc="yt --get-description" \
  ytlen="yt --get-duration" \
  ytrm="yt --rm-cache-dir" \
  ytv="yt --embed-subs"

#!/usr/bin/env sh

show_time () {
  TIME=$(date "+%Y-%m-%d %H:%M")
  printf %s "${TIME}"
}

show_volume () {
  VOLUME=$(sndioctl output.level | cut -f 2 -d "=" | cut -f 2 -d ".")
  printf %.7s "VOL: ${VOLUME}"
}

show_disk_space () {
  DISKSPACE=$(df -h /home | tail -1 | awk '{print $4}')
  printf %s "${DISKSPACE}"
}

show_battery () {
  ADAPTER=$(apm -a)
  BATTERY=$(apm -l)
  if [ "${ADAPTER}" = 0 ]; then
    printf %s "BAT: ${BATTERY}%"
  elif [ "${ADAPTER}" = 1 ]; then
    printf %s "CHR: ${BATTERY}%"
  else
    printf %s "UNKNWN PWR SRC"
  fi
}

while true; do
  printf %s "%{B#000000}%{r} $(show_battery) | $(show_disk_space) | $(show_volume)% | $(show_time)"
  sleep 1
done

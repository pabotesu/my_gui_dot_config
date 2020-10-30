#!/usr/bin/env bash

set -euCo pipefail

function online_icon() {
  [[ $# -eq 0 ]] && return 1
  local -ar icons=('[/....]⚡' '[//...]⚡' '[///..]⚡' '[////.]⚡' '[/////]⚡')
  local index
  index=$(expr $1 % ${#icons[@]})
  echo ${icons[${index}]}
}

function echo_battery() {
  [[ $# -eq 1 ]] \
    && echo -e "\"full_text\": \"$1 \"" \
    || echo -e "\"full_text\": \"$1 \", \"color\": \"$2\""
}

function get_battery() {
  [[ -e '/sys/class/power_supply/BAT0/capacity' ]] \
    && cat '/sys/class/power_supply/BAT0/capacity' \
    || echo 0
}

function online() {
  [[ $(cat /sys/class/power_supply/AC/online) -eq 1 ]] \
    && return 0
  return 
}

function main() {
  local -Ar \
    high=( ['value']=79 ['icon']='[/////] ➤' ['color']='#4db56a') \
    high_middle=( ['value']=59 ['icon']='[////.] ➤' ['color']='#4db56a') \
    middle=(['value']=39 ['icon']='[///..] ➤' ['color']='#4db56a') \
    low_middle=( ['value']=19 ['icon']='[//...] ➤' ['color']='#f0c674') \
    low=( ['icon']='[/....] ➤' ['color']='#cc6666')

  local online_icon='' cnt=0
  while sleep 1; do
    cnt=$(expr ${cnt} + 1)

    if online; then
      online_icon=$(online_icon ${cnt})
    else
      [[ -z ${online_icon} && $(expr ${cnt} % 60) -ne 1 ]] \
        && continue
      online_icon=''
    fi

    local battery
    battery=$(get_battery)
    if [[ ${battery} -eq 0 ]]; then
      echo_battery ${online_icon}
   
    elif [[ ${battery} -gt ${high['value']} ]];then
      echo_battery \
        "${online_icon:-${high['icon']}} ${battery}%" ${high['color']}
    
    elif [[ ${battery} -gt ${high_middle['value']} ]];then
      echo_battery \
        "${online_icon:-${high_middle['icon']}} ${battery}%" ${high_middle['color']}
    
    elif [[ ${battery} -gt ${middle['value']} ]];then
      echo_battery \
        "${online_icon:-${middle['icon']}} ${battery}%" ${middle['color']}
 
    elif [[ ${battery} -gt ${low_middle['value']} ]];then
      echo_battery \
        "${online_icon:-${low_middle['icon']}} ${battery}%" ${low_middle['color']}
   
    else
       echo_battery \
        "${online_icon:-${low['icon']}} ${battery}%" ${low['color']}
 
    fi
  done
}

main

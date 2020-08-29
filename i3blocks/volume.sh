#!/usr/bin/env bash
set -euCo pipefail

function get_volume() {
  
  pactl list sinks \
  | grep 'Volume' | grep -o '[0-9]*%' | head -1 | tr -d '%'
}

function get_mute(){
  
   pactl list sinks \
   | grep 'Mute' | sed 's/[[:space:]]//g' | cut -d: -f2 | head -1
}


function main() {

   local -r st_mute=$(get_mute)
   
   if [ ${st_mute} = "yes" ]; then
     echo "mute"
   else
     get_volume
   fi  
}

main

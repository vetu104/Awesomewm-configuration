#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "picom"
#run "xfce4-power-manager"
run "numlockx"
run "udiskie"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

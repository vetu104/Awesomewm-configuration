#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "picom"
run "xfce4-power-manager"
run "numlockx"
run "udiskie"

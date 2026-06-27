#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  printf "Usage: ./run-me.sh cool\n"
  exit 1
fi

printf "This is a %s script!\n" "$1"
exit 0

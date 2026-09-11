#!/usr/bin/env bash

id=$1

makoctl list -j |
  jq -r '.[0] | "\(.summary)\n\(.body)"' |
  wl-copy

makoctl dismiss -n "$id"

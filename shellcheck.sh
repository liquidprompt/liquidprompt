#!/bin/sh

# shellcheck disable=SC2093
exec shellcheck \
  --shell=bash \
  --exclude=SC2155 \
  --external-sources --check-sourced \
  tools/* \
  "$0" # Include this script to get the below imports


. ./liquidprompt

. ./themes/alternate_vcs/alternate_vcs.theme
. ./themes/powerline/powerline.theme

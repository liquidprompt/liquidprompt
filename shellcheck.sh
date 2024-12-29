#!/bin/sh

# shellcheck shell=bash

# shellcheck disable=SC2093
exec shellcheck \
  --shell=bash \
  --exclude=SC2155 \
  --external-sources --check-sourced \
  liquidprompt \
  tools/* \
  "$0" # Include this script to get the below imports


. ./liquidprompt

. ./themes/alternate_vcs/alternate_vcs.theme
. ./themes/powerline/powerline.theme
. ./themes/unfold/unfold.theme
. ./themes/explain/explain.theme

# vim: ft=sh et sts=2 sw=2 tw=120

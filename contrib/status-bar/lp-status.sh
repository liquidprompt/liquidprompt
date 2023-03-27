#!/bin/bash

wdir=$(pwd)
cd $(dirname $0)/../..

set -u

. ./liquidprompt --no-activate

# If a theme was given, use the theme and source all other arguments.
if [[ -z ${1-} || $1 == --help ]]; then
  printf '
Usage: %s theme [sourced files...]

Print out the prompt.

Example usage: %s powerline themes/powerline/powerline.theme
' "$0" "$0"
  exit 1

else
  theme=$1
  shift

  for file in "$@"; do
    # shellcheck disable=SC1090
    . "$file"
  done
fi

# Liquid Prompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

# Activate and generate
lp_activate --no-config
# Only needs to be done once

lp_theme "$theme" || exit "$?"

cd $wdir


# Since the shell is not evaluating PS1, if we print the PS1 to the console,
# the shell escape sequences will not be hidden, and it will look wrong. We
# cannot strip them ahead of time, since they are required to know where to
# look to remove formatting, so we have to do it right before printing it.
__remove_shell_escapes() {  # PS1 -> PS1
  PS1="${PS1//"${_LP_OPEN_ESC}"/}"
  PS1="${PS1//"${_LP_CLOSE_ESC}"/}"
}

__print_prompt() {
    __lp_set_prompt
    __remove_shell_escapes
    printf '%s\n' "$PS1"
}

__print_prompt


# Error on unset variables
set -u

. ../liquidprompt --no-activate

LP_ENABLE_DETACHED_SESSIONS=1
_LP_ENABLE_SCREEN=1
_LP_ENABLE_TMUX=1

typeset -a screen_outputs screen_values tmux_outputs tmux_values

# Add test cases to these arrays like below

# Linux 4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14 14:37:00 UTC 2020 x86_64 GNU/Linux CentOS Linux release 8.2.2004 (Core)
# Trailing "" are needed to prevent Git from converting \r\n into \n
screen_outputs+=(
"No Sockets found in /run/screen/S-user.
""
"
)
screen_values+=(0)
screen_outputs+=(
"There is a screen on:""
	2261393.pts-1.server	(Detached)
1 Socket in /run/screen/S-user.""
"
)
screen_values+=(1)
tmux_outputs+=(
""
)
tmux_values+=(0)
tmux_outputs+=(
"0: 1 windows (created Thu Dec 17 15:19:13 2020) [179x96]
"
)
tmux_values+=(1)


function test_screen_sessions {

  screen() {
    printf '%s' "$__screen_output"
  }
  tmux() { : ; }

  for (( index=0; index < ${#screen_values[@]}; index++ )); do
    __screen_output=${screen_outputs[$index]}
    _lp_detached_sessions
    assertEquals "Screen sessions output" "${screen_values[$index]}" "$lp_detached_sessions"
  done
}

function test_tmux_sessions {

  tmux() {
    printf '%s' "$__tmux_output"
  }
  screen() { : ; }

  for (( index=0; index < ${#tmux_values[@]}; index++ )); do
    __tmux_output=${tmux_outputs[$index]}
    _lp_detached_sessions
    assertEquals "Tmux sessions output" "${tmux_values[$index]}" "$lp_detached_sessions"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

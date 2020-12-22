
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

# Darwin Kernel Version 18.7.0: Tue Nov 10 00:07:31 PST 2020; root:xnu-4903.278.51~1/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
screen_outputs+=(
"This room is empty (/var/folders/x3/gk96bn856xv__mnm_h8xnjqw0000gn/T/.screen).
""
"
)
screen_values+=(0)

# Darwin Kernel Version 19.6.0: Tue Nov 10 00:10:30 PST 2020; root:xnu-6153.141.10~1/RELEASE_X86_64 x86_64 i386 Macmini7,1 Darwin
screen_outputs+=(
"No Sockets found in /var/folders/s1/y_2wmcg90gl9x54bq2p4t9980000gn/T/.screen.
""
"
)
screen_values+=(0)

# Linux 5.4.0-58-generic #64-Ubuntu SMP Wed Dec 9 08:16:25 UTC 2020 x86_64 GNU/Linux Ubuntu 20.04.1 LTS
screen_outputs+=(
"There is a screen on:""
	840.irssi	(12/12/20 09:49:29)	(Detached)
1 Socket in /run/screen/S-usernam.""
"
)
screen_values+=(1)

# Linux 4.9.0-13-amd64 #1 SMP Debian 4.9.228-1 (2020-07-05) x86_64 GNU/Linux Debian 9.13 (stretch)
screen_outputs+=(
"There is a screen on:""
	30133.pts-6.hostnam	(08/03/20 09:10:09)	(Attached)
1 Socket in /run/screen/S-user.""
"
)
screen_values+=(0)


function test_screen_sessions {

  screen() {
    printf '%s' "$__screen_output"
  }
  tmux() { : ; }

  for (( index=0; index < ${#screen_values[@]}; index++ )); do
    __screen_output=${screen_outputs[$index]}
    _lp_detached_sessions
    assertEquals "Screen sessions output at index ${index}" "${screen_values[$index]}" "$lp_detached_sessions"
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
    assertEquals "Tmux sessions output at index ${index}" "${tmux_values[$index]}" "$lp_detached_sessions"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

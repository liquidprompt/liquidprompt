# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

LP_ENABLE_ATTACHED_SESSIONS=1
LP_ENABLE_DETACHED_SESSIONS=1
LP_ENABLE_JOBS=1
LP_MARK_JOBS_SEPARATOR="/"
_LP_ENABLE_SCREEN=1
_LP_ENABLE_TMUX=1
_LP_ENABLE_SHPOOL=1
_LP_ENABLE_HERDR=1

typeset -a screen_outputs screen_values shpool_outputs shpool_values tmux_outputs tmux_values herdr_outputs herdr_values

# Screen outputs
screen_outputs+=(
"No Sockets found in /run/screen/S-user.
"
)
screen_values+=(0)

screen_outputs+=(
"There is a screen on:
	2261393.pts-1.server	(Detached)
1 Socket in /run/screen/S-user.
"
)
screen_values+=(0)

screen_outputs+=(
"There is a screen on:
	30133.pts-6.hostnam	(08/03/20 09:10:09)	(Attached)
1 Socket in /run/screen/S-user.
"
)
screen_values+=(1)

# Tmux outputs
tmux_outputs+=(
""
)
tmux_values+=(0)

tmux_outputs+=(
"0: 1 windows (created Thu Dec 17 15:19:13 2020) [179x96]
"
)
tmux_values+=(0)

tmux_outputs+=(
"0: 1 windows (created Thu Dec 17 15:19:13 2020) [179x96] (attached)
"
)
tmux_values+=(1)

# Shpool outputs
shpool_outputs+=(
"NAME   	STARTED_AT     	STATUS
"
)
shpool_values+=(0)

shpool_outputs+=(
"NAME   	STARTED_AT     	STATUS
test   	2024-09-26T16:06:07.352+00:00  	disconnected
"
)
shpool_values+=(0)

shpool_outputs+=(
"NAME   	STARTED_AT     	STATUS
test   	2024-09-26T16:06:07.352+00:00  	attached
"
)
shpool_values+=(1)

# Herdr outputs
herdr_outputs+=(
"NAME   STATUS
"
)
herdr_values+=(0)

herdr_outputs+=(
"NAME   STATUS
main   detached
"
)
herdr_values+=(0)

herdr_outputs+=(
"NAME   STATUS
main   running
sub    attached
"
)
herdr_values+=(2)

herdr_outputs+=(
"name                 status   directory                                        socket
default              running  /root/.config/herdr                              /root/.config/herdr/herdr.sock
"
)
herdr_values+=(1)


function test_screen_attached_sessions {
  screen() {
    printf '%s' "$__screen_output"
  }
  shpool() { : ; }
  tmux() { : ; }
  herdr() { : ; }

  for (( index=0; index < ${#screen_values[@]}; index++ )); do
    __screen_output=${screen_outputs[$index]}
    _lp_attached_sessions
    assertEquals "Screen attached sessions output at index ${index}" "${screen_values[$index]}" "$lp_attached_sessions"
  done
}

function test_shpool_attached_sessions {
  shpool() {
    printf '%s' "$__shpool_output"
  }
  screen() { : ; }
  tmux() { : ; }
  herdr() { : ; }

  for (( index=0; index < ${#shpool_values[@]}; index++ )); do
    __shpool_output=${shpool_outputs[$index]}
    _lp_attached_sessions
    assertEquals "shpool attached sessions output at index ${index}" "${shpool_values[$index]}" "$lp_attached_sessions"
  done
}

function test_tmux_attached_sessions {
  tmux() {
    printf '%s' "$__tmux_output"
  }
  screen() { : ; }
  shpool() { : ; }
  herdr() { : ; }

  for (( index=0; index < ${#tmux_values[@]}; index++ )); do
    __tmux_output=${tmux_outputs[$index]}
    _lp_attached_sessions
    assertEquals "Tmux attached sessions output at index ${index}" "${tmux_values[$index]}" "$lp_attached_sessions"
  done
}

function test_herdr_attached_sessions {
  herdr() {
    printf '%s' "$__herdr_output"
  }
  screen() { : ; }
  shpool() { : ; }
  tmux() { : ; }

  for (( index=0; index < ${#herdr_values[@]}; index++ )); do
    __herdr_output=${herdr_outputs[$index]}
    _lp_attached_sessions
    assertEquals "herdr attached sessions output at index ${index}" "${herdr_values[$index]}" "$lp_attached_sessions"
  done
}

function test_jobcount_color_attached {
  screen() { : ; }
  shpool() { : ; }
  tmux() { : ; }
  herdr() {
    printf '%s' "NAME   STATUS
main   running
sub    detached
"
  }
  LP_COLOR_JOB_D="[D]"
  LP_COLOR_JOB_A="[A]"
  NO_COL=""
  _lp_jobcount_color
  assertEquals "Jobcount color with attached and detached sessions" "[D]1d/[A]1r" "$lp_jobcount_color"
}

. ./shunit2

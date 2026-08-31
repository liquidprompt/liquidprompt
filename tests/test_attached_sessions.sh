# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

LP_ENABLE_ATTACHED_SESSIONS=1
LP_ENABLE_MULTIPLEXER=1
LP_ENABLE_DETACHED_SESSIONS=1
LP_ENABLE_JOBS=1
LP_MARK_JOBS_SEPARATOR="/"
_LP_ENABLE_SCREEN=1
_LP_ENABLE_TMUX=1
_LP_ENABLE_SHPOOL=1
_LP_ENABLE_HERDR=1
_LP_ENABLE_ZELLIJ=1

function setUp {
  unset TMUX SHPOOL_SESSION_NAME HERDR_SESSION HERDR_SESSION_NAME HERDR_ENV ZELLIJ ZELLIJ_SESSION_NAME
  TERM=dumb
}

typeset -a screen_outputs screen_values shpool_outputs shpool_values tmux_outputs tmux_values herdr_outputs herdr_values zellij_outputs zellij_values

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

# Zellij outputs
zellij_outputs+=(
""
)
zellij_values+=(0)

zellij_outputs+=(
"session1 [Created 10s ago] (current)
"
)
zellij_values+=(1)

zellij_outputs+=(
"session1 [Created 10s ago]
"
)
zellij_values+=(0)

zellij_outputs+=(
"session1 [Created 10s ago] (current)
session2 [Created 5s ago]
"
)
zellij_values+=(1)

zellij_outputs+=(
"s1 [Created 10s ago] (current)
s2 [Created 8s ago]
s3 [Created 5s ago] (current)
s4 [Created 1s ago] (EXITED - attach to resurrect)
"
)
zellij_values+=(2)


function test_screen_attached_sessions {
  screen() {
    printf '%s' "$__screen_output"
  }
  shpool() { : ; }
  tmux() { : ; }
  herdr() { : ; }
  zellij() { : ; }

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
  zellij() { : ; }

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
  zellij() { : ; }

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
  zellij() { : ; }

  for (( index=0; index < ${#herdr_values[@]}; index++ )); do
    __herdr_output=${herdr_outputs[$index]}
    _lp_attached_sessions
    assertEquals "herdr attached sessions output at index ${index}" "${herdr_values[$index]}" "$lp_attached_sessions"
  done
}

function test_zellij_attached_sessions {
  zellij() {
    printf '%s' "$__zellij_output"
  }
  screen() { : ; }
  shpool() { : ; }
  tmux() { : ; }
  herdr() { : ; }

  for (( index=0; index < ${#zellij_values[@]}; index++ )); do
    __zellij_output=${zellij_outputs[$index]}
    _lp_attached_sessions
    assertEquals "zellij attached sessions output at index ${index}" "${zellij_values[$index]}" "$lp_attached_sessions"
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
  zellij() { : ; }
  LP_COLOR_JOB_D="[D]"
  LP_COLOR_JOB_A="[A]"
  NO_COL=""
  _lp_jobcount_color
  assertEquals "Jobcount color with attached and detached sessions" "[D]1d/[A]1r" "$lp_jobcount_color"
}

function test_attached_sessions_exclude_current {
  local -i total_sessions=10
  local -i inside_sessions=$(( total_sessions - 1 ))

  tmux() {
    printf '%s' "0: 1 windows [179x96] (attached)
1: 1 windows [179x96] (attached)
"
  }
  screen() {
    printf '%s' "	12345.pts-0.host	(08/14/2026 10:00:00 AM)	(Attached)
	12346.pts-1.host	(08/14/2026 10:00:00 AM)	(Attached)
"
  }
  shpool() {
    printf '%s' "s1	attached
s2	attached
"
  }
  herdr() {
    printf '%s' "NAME   STATUS
h1     attached
h2     attached
"
  }
  zellij() {
    printf '%s' "z1 (current)
z2 (current)
"
  }

  # Inside tmux (subtract 1)
  TMUX=1
  _lp_attached_sessions
  assertEquals "Exclude current session inside tmux" "$inside_sessions" "$lp_attached_sessions"

  # Inside screen (subtract 1)
  unset TMUX
  TERM=screen-256color
  _lp_attached_sessions
  assertEquals "Exclude current session inside screen" "$inside_sessions" "$lp_attached_sessions"

  # Inside shpool (subtract 1)
  TERM=dumb
  SHPOOL_SESSION_NAME=s1
  _lp_attached_sessions
  assertEquals "Exclude current session inside shpool" "$inside_sessions" "$lp_attached_sessions"

  # Inside herdr (subtract 1)
  unset SHPOOL_SESSION_NAME
  HERDR_SESSION=h1
  _lp_attached_sessions
  assertEquals "Exclude current session inside herdr" "$inside_sessions" "$lp_attached_sessions"

  # Inside zellij (subtract 1)
  unset HERDR_SESSION HERDR_SESSION_NAME HERDR_ENV
  ZELLIJ=1
  _lp_attached_sessions
  assertEquals "Exclude current session inside zellij" "$inside_sessions" "$lp_attached_sessions"

  # Outside any multiplexer (do not subtract)
  unset ZELLIJ ZELLIJ_SESSION_NAME
  _lp_attached_sessions
  assertEquals "Do not exclude current session when outside multiplexer" "$total_sessions" "$lp_attached_sessions"

  # Inside zellij but LP_ENABLE_MULTIPLEXER=0 (multiplexer detection disabled, do not subtract)
  ZELLIJ=1
  LP_ENABLE_MULTIPLEXER=0
  _lp_attached_sessions
  assertEquals "Do not exclude current session when LP_ENABLE_MULTIPLEXER=0" "$total_sessions" "$lp_attached_sessions"
  LP_ENABLE_MULTIPLEXER=1
}

. ./shunit2

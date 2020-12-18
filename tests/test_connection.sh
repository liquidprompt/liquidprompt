
. ../liquidprompt --no-activate

typeset -a who_outputs ps_outputs values

# Add test cases to these arrays like below

# Linux 4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14 14:37:00 UTC 2020 x86_64 GNU/Linux CentOS Linux release 8.2.2004 (Core)
who_outputs+=(
"user     pts/0        Dec 17 11:06 (192.168.1.7)"
)
ps_outputs+=(
"bash"
)
values+=(tel)


function test_connection {

  who() {
    printf '%s\n' "$__who_output"
  }
  ps() {
    printf '%s\n' "$__ps_output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    __who_output=${who_outputs[$index]}
    __ps_output=${ps_outputs[$index]}
    local SSH_CLIENT= SSH2_CLIENT= SSH_TTY=

    _lp_connection
    assertEquals "Connection output" "${values[$index]}" "$lp_connection"

    SSH_CLIENT=foo
    _lp_connection
    assertEquals "Connection output" "ssh" "$lp_connection"
    unset SSH_CLIENT
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

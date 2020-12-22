
# Error on unset variables
set -u

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

# Darwin Kernel Version 18.7.0: Tue Nov 10 00:07:31 PST 2020; root:xnu-4903.278.51~1/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
who_outputs+=(
"user.lastname ttys135      Dec 21 19:08"
)
ps_outputs+=(
"-bash"
)
values+=(lcl)

# Darwin Kernel Version 19.6.0: Tue Nov 10 00:10:30 PST 2020; root:xnu-6153.141.10~1/RELEASE_X86_64 x86_64 i386 Macmini7,1 Darwin
who_outputs+=(
"usernames ttys000      Dec 21 19:12 (fe80::12:a1b2:a123:fb84%en0)"
)
ps_outputs+=(
"-bash"
)
values+=(tel)

# Linux 5.4.0-58-generic #64-Ubuntu SMP Wed Dec 9 08:16:25 UTC 2020 x86_64 GNU/Linux Ubuntu 20.04.1 LTS
who_outputs+=(
"usernam  pts/1        Dec 21 19:16 (2600:8801:9600:b64:9966:24a:dc6f:41fd)"
)
ps_outputs+=(
"bash"
)
values+=(tel)

# Linux 5.4.0-58-generic #64-Ubuntu SMP Wed Dec 9 08:16:25 UTC 2020 x86_64 GNU/Linux Ubuntu 20.04.1 LTS
who_outputs+=(
""
)
ps_outputs+=(
"bash"
)
values+=(lcl)

# Linux 4.9.0-13-amd64 #1 SMP Debian 4.9.228-1 (2020-07-05) x86_64 GNU/Linux Debian 9.13 (stretch)
who_outputs+=(
"user     pts/75       Dec 22 10:39 (10.0.0.117)"
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
    assertEquals "Connection output at index ${index}" "${values[$index]}" "$lp_connection"

    SSH_CLIENT=foo
    _lp_connection
    assertEquals "Connection output at index ${index} with ssh" "ssh" "$lp_connection"
    unset SSH_CLIENT
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

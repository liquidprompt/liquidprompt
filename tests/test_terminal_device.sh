
# Error on unset variables
set -u

. ../liquidprompt --no-activate

typeset -a tty_outputs values

# Add test cases to these arrays like below

# Linux 4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14 14:37:00 UTC 2020 x86_64 GNU/Linux CentOS Linux release 8.2.2004 (Core)
tty_outputs+=(
"/dev/pts/0"
)
values+=("0")

# Darwin Kernel Version 18.7.0: Tue Nov 10 00:07:31 PST 2020; root:xnu-4903.278.51~1/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
tty_outputs+=(
"/dev/ttys135"
)
values+=("ttys135")

# Linux 4.9.0-13-amd64 #1 SMP Debian 4.9.228-1 (2020-07-05) x86_64 GNU/Linux Debian 9.13 (stretch)
tty_outputs+=(
"/dev/pts/75"
)
values+=("75")


function test_terminal_device {

  tty() {
    printf '%s\n' "$__tty_output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    __tty_output=${tty_outputs[$index]}

    _lp_terminal_device
    assertEquals "Terminal device basename at index ${index}" "${values[$index]}" "$lp_terminal_device"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

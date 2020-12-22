
# Error on unset variables
set -u

. ../liquidprompt --no-activate

typeset -a host_cksum_outputs values

# Add test cases to these arrays like below

# Linux 4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14 14:37:00 UTC 2020 x86_64 GNU/Linux CentOS Linux release 8.2.2004 (Core)
host_cksum_outputs+=(
"4172267268 7"
)
values+=("4172267268")

# Darwin Kernel Version 18.7.0: Tue Nov 10 00:07:31 PST 2020; root:xnu-4903.278.51~1/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
host_cksum_outputs+=(
"3020151712 13"
)
values+=("3020151712")


function test_hostname_hash {

  cksum() {
    printf '%s\n' "$__host_cksum_output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    __host_cksum_output=${host_cksum_outputs[$index]}

    __lp_hostname_hash
    assertEquals "Hostname cksum hash at index ${index}" "${values[$index]}" "$lp_hostname_hash"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

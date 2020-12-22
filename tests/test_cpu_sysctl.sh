
# Error on unset variables
set -u

# Load MacOS version of CPU functions
uname() { printf 'Darwin'; }

. ../liquidprompt --no-activate

typeset -a ncpu_outputs ncpu_values loadavg_outputs loadavg_values

# Add test cases to these arrays like below

# Darwin Kernel Version 18.7.0: Tue Nov 10 00:07:31 PST 2020; root:xnu-4903.278.51~1/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
ncpu_outputs+=(
"12"
)
ncpu_values+=(12)
loadavg_outputs+=(
"{ 2.38 2.82 4.17 }"
)
loadavg_values+=("2.38")


function test_sysctl_hw_ncpu {

  sysctl() {
    printf '%s\n' "$__ncpu_output"
  }

  for (( index=0; index < ${#ncpu_values[@]}; index++ )); do
    __ncpu_output=${ncpu_outputs[$index]}

    __lp_cpu_count
    assertEquals "CPU count at index ${index}" "${ncpu_values[$index]}" "$_lp_CPUNUM"
  done
}

function test_sysctl_vm_loadavg {

  sysctl() {
    printf '%s\n' "$__loadavg_output"
  }

  for (( index=0; index < ${#loadavg_values[@]}; index++ )); do
    __loadavg_output=${loadavg_outputs[$index]}

    _lp_cpu_load
    assertEquals "CPU load at index ${index}" "${loadavg_values[$index]}" "$lp_cpu_load"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

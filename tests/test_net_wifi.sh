
# Error on unset variables
set -u

# Load Linux version
uname() { printf 'Linux'; }

. ../liquidprompt --no-activate
unset -f uname

LP_ENABLE_WIFI_STRENGTH=1

typeset -a outputs values

# Linux 5.4.0-58-generic #64-Ubuntu SMP Wed Dec 9 08:16:25 UTC 2020 x86_64 GNU/Linux
outputs+=(
"Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
  wlo1: 0000   69.  -41.  -256        0      0      0      0     33        0"
)
values+=("99")

# Fake two interfaces
outputs+=(
"Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
  wlo1: 0000   69.  -41.  -256        0      0      0      0     33        0
  wlo2: 0000   61.  -58.  -256        0      0      0      0     37        0"
)
values+=("70")


function test_net_wifi {
  _LP_LINUX_WIRELESS_FILE="${SHUNIT_TMPDIR}/wireless"

  for (( index=0; index < ${#values[@]}; index++ )); do
    printf '%s\n' "${outputs[$index]}" >"$_LP_LINUX_WIRELESS_FILE"

    LP_WIFI_STRENGTH_THRESHOLD="0"
    _lp_wifi_signal_strength
    assertEquals "Linux wireless above returns at index ${index}" "1" "$?"
    assertEquals "Linux wireless value at index ${index}" "${values[$index]}" "$lp_wifi_signal_strength"

    # This is to test that _lp_wifi_signal_strength() ignores previous low values.
    lp_wifi_signal_strength=-10000

    LP_WIFI_STRENGTH_THRESHOLD="100"
    _lp_wifi_signal_strength
    assertEquals "Linux wireless below returns at index ${index}" "0" "$?"
    assertEquals "Linux wireless value at index ${index}" "${values[$index]}" "$lp_wifi_signal_strength"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

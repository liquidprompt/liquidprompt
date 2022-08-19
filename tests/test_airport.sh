
# Error on unset variables
set -u

# Load MacOS version
uname() { printf 'Darwin'; }

. ../liquidprompt --no-activate
unset -f uname

LP_ENABLE_WIFI_STRENGTH=1

typeset -a outputs values

# Darwin Kernel Version 21.4.0: Fri Mar 18 00:46:32 PDT 2022; root:xnu-8020.101.4~15/RELEASE_ARM64_T6000 arm64
outputs+=(
"     agrCtlRSSI: -55
     agrExtRSSI: 0
    agrCtlNoise: -92
    agrExtNoise: 0
          state: running
        op mode: station 
     lastTxRate: 400
        maxRate: 400
lastAssocStatus: 0
    802.11 auth: open
      link auth: wpa2-psk
          BSSID:
           SSID: redacted
            MCS: 9
  guardInterval: 400
            NSS: 2
        channel: 36,1"
)
values+=("75")

# https://support.moonpoint.com/os/os-x/wireless/wifi-signal-strength
outputs+=(
"     agrCtlRSSI: -67
     agrExtRSSI: 0
    agrCtlNoise: -86
    agrExtNoise: 0
          state: running
        op mode: station 
     lastTxRate: 7
        maxRate: 144
lastAssocStatus: 0
    802.11 auth: open
      link auth: none
          BSSID: ec:44:76:81:e4:40
           SSID: VA Internet
            MCS: 0
        channel: 11"
)
values+=("55")


function test_airport {

  airport() {
    printf '%s\n' "$__output"
  }
  _LP_AIRPORT_BIN=airport

  for (( index=0; index < ${#values[@]}; index++ )); do
    __output=${outputs[$index]}

    LP_WIFI_STRENGTH_THRESHOLD="0"
    _lp_wifi_signal_strength
    assertEquals "airport wireless above returns at index ${index}" "1" "$?"
    assertEquals "airport wireless value at index ${index}" "${values[$index]}" "$lp_wifi_signal_strength"

    # This is to test that _lp_wifi_signal_strength() ignores previous low values.
    lp_wifi_signal_strength=-10000

    LP_WIFI_STRENGTH_THRESHOLD="100"
    _lp_wifi_signal_strength
    assertEquals "airport wireless below returns at index ${index}" "0" "$?"
    assertEquals "airport wireless value at index ${index}" "${values[$index]}" "$lp_wifi_signal_strength"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

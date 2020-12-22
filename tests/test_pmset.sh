
# Error on unset variables
set -u

# Load MacOS version of _lp_battery()
uname() { printf 'Darwin'; }

. ../liquidprompt --no-activate
unset -f uname

LP_ENABLE_BATT=1

typeset -a outputs statuses values

# Simulated, originally from ./pmset-simulator
# https://github.com/nojhan/liquidprompt/issues/315
outputs+=(
"Now drawing from 'AC Power'"
)
statuses+=(4)
values+=('')
# https://github.com/nojhan/liquidprompt/issues/326#issuecomment-66120495
outputs+=(
"Now drawing from 'AC Power'
 -InternalBattery-0 37%; AC attached; not charging"
)
statuses+=(2)
values+=(37)
# https://github.com/nojhan/liquidprompt/issues/326
outputs+=(
"Now drawing from 'AC Power'
 -InternalBattery-0 8%; charging; 2:46 remaining"
)
statuses+=(2)
values+=(8)
# https://github.com/nojhan/liquidprompt/issues/326
outputs+=(
"Now drawing from 'Battery Power'
 -InternalBattery-0 9%; discharging; (no estimate)"
)
statuses+=(0)
values+=(9)
# https://github.com/nojhan/liquidprompt/issues/326
outputs+=(
"Now drawing from 'Battery Power'
 -InternalBattery-0 7%; discharging; 0:13 remaining
    Battery Warning: Early"
)
statuses+=(0)
values+=(7)

# Darwin Kernel Version 20.2.0: Wed Dec  2 20:39:59 PST 2020; root:xnu-7195.60.75~1/RELEASE_X86_64 x86_64
outputs+=(
"Now drawing from 'AC Power'
 -InternalBattery-0 (id=5701731)	100%; charged; 0:00 remaining present: true"
)
statuses+=(4)
values+=(100)
outputs+=(
"Now drawing from 'Battery Power'
 -InternalBattery-0 (id=5701731)	100%; discharging; 2:49 remaining present: true"
)
statuses+=(0)
values+=(100)

# Darwin Kernel Version 18.7.0: Tue Nov 10 00:07:31 PST 2020; root:xnu-4903.278.51~1/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
outputs+=(
"Now drawing from 'AC Power'
 -InternalBattery-0 (id=4325475)	100%; charged; 0:00 remaining present: true"
)
statuses+=(4)
values+=(100)

# Darwin Kernel Version 19.6.0: Tue Nov 10 00:10:30 PST 2020; root:xnu-6153.141.10~1/RELEASE_X86_64 x86_64 i386 Macmini7,1 Darwin
outputs+=(
"Now drawing from 'AC Power'"
)
statuses+=(4)
values+=('')


function test_pmset {

  pmset() {
    printf '%s\n' "$__output"
  }

  for (( index=0; index < ${#values[@]}; index++ )); do
    __output=${outputs[$index]}

    LP_BATTERY_THRESHOLD=100
    _lp_battery
    assertEquals "pmset battery below returns at index ${index}" "${statuses[$index]}" "$?"
    assertEquals "pmset battery value at index ${index}" "${values[$index]}" "$lp_battery"

    _status=${statuses[$index]}
    (( _status < 4 )) && _status=$(( _status + 1 ))

    LP_BATTERY_THRESHOLD=0
    _lp_battery
    assertEquals "pmset battery above returns at index ${index}" "$_status" "$?"
    assertEquals "pmset battery value at index ${index}" "${values[$index]}" "$lp_battery"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

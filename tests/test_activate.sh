
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

# Liquidprompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "


function test_activate {
  lp_activate --no-config
}

. ./shunit2

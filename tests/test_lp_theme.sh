
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ../liquidprompt --no-activate


function setUp {
  unset LP_THEME _LP_OLD_THEME _LP_THEME_ACTIVATE_FUNCTION

  PS1='$ '
  lp_activate
}

function _lp_test_theme_prompt { : ; }

function test_lp_theme_function {
  assertEquals "$LP_THEME" "default"

  lp_theme test
  assertEquals "$LP_THEME" "test"

  lp_theme invalid_theme
  assertEquals "$LP_THEME" "test"
}

function test_lp_theme_var {
  assertEquals "$LP_THEME" "default"

  LP_THEME=test
  __lp_set_prompt
  assertEquals "$LP_THEME" "test"

  LP_THEME=invalid_theme
  __lp_set_prompt
  assertEquals "$LP_THEME" "test"
}

function test_lp_theme_unset {
  lp_theme invalid_theme
  assertEquals "$LP_THEME" "default"
}

. ./shunit2

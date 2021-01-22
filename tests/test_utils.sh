
# Error on unset variables
set -u

. ../liquidprompt --no-activate

function test_as_text {
  # The escape sequences are different on Bash and Zsh
  assertEquals "basic text removal" "a normal string without colors" \
    "$(_lp_as_text "${_LP_OPEN_ESC}bad text${_LP_CLOSE_ESC}a normal string without ${_LP_OPEN_ESC}color${_LP_CLOSE_ESC}colors")"

  assertEquals "control character removal" "string" \
    "$(_lp_as_text "${_LP_OPEN_ESC}"$'\a\b'"${_LP_CLOSE_ESC}str${_LP_OPEN_ESC}"$'\001\E'"${_LP_CLOSE_ESC}ing")"
}

function test_escape {
  typeset ret

  __lp_escape "a pretty normal string"
  assertEquals "normal string" "a pretty normal string" "$ret"

  __lp_escape 'a string with \backslashes and %percents'
  if (( is_zsh )); then
    assertEquals "backslash+percent string" 'a string with \\backslashes and %%percents' "$ret"
  else
    assertEquals "backslash+percent string" 'a string with \\\\backslashes and %percents' "$ret"
  fi

  __lp_escape $'a string with \nnewlines and \001others'
  if (( is_zsh )); then
    assertEquals "control chars string" 'a string with \nnewlines and \001others' "$ret"
  else
    assertEquals "control chars string" 'a string with \\nnewlines and \\001others' "$ret"
  fi

  __lp_escape $'a string with \abells and \177deletes and \eescapes \\rfalse alarms'
  if (( is_zsh )); then
    assertEquals "more control chars string" 'a string with \abells and \177deletes and \eescapes \\rfalse alarms' "$ret"
  else
    assertEquals "more control chars string" 'a string with \\abells and \\177deletes and \\eescapes \\\\rfalse alarms' "$ret"
  fi
}

function test_line_count {
  typeset test_string="a normal string"
  __lp_line_count "$test_string"
  assertEquals "normal 1 line string" $(printf %s "$test_string" | wc -l) $count

  test_string="\
    a
    longer
    string"
  __lp_line_count "$test_string"
  assertEquals "3 line string" $(printf %s "$test_string" | wc -l) $count

  test_string="\
    a

    longer

    string


    with many consecutive breaks"
  __lp_line_count "$test_string"
  assertEquals "consecutive blank lines string" $(printf %s "$test_string" | wc -l) $count

  test_string=""
  __lp_line_count "$test_string"
  assertEquals "null string" $(printf %s "$test_string" | wc -l) $count
}

function test_pwd_tilde {
  typeset HOME="/home/user"
  typeset PWD="/a/test/path"
  __lp_pwd_tilde
  assertEquals "unchanged path" "$PWD" "$lp_pwd_tilde"

  PWD="/home/user/a/test/path"
  __lp_pwd_tilde
  assertEquals "shorted home path" "~/a/test/path" "$lp_pwd_tilde"
}

function test_is_function {
  function my_function { :; }

  # Ignore errors, we just really need this to not be a function
  unset -f not_my_function >/dev/null 2>&1 || true

  assertTrue "failed to find valid function" '__lp_is_function my_function'
  assertFalse "claimed to find non-existent function" '__lp_is_function not_my_function'

  alias not_my_function=my_function
  assertFalse "claimed alias was a function" '__lp_is_function not_my_function'

  unset -f my_function
  unalias not_my_function
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
  is_zsh=1
else
  is_zsh=0
fi

. ./shunit2

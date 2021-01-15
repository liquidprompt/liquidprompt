
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

  __lp_pwd_tilde "/home/user/a/different/path"
  assertEquals "shorted home path" "~/a/different/path" "$lp_pwd_tilde"
}

function pathSetUp {
  # We cannot use SHUNIT_TEMPDIR because we need to know the start of the path
  typeset long_path="/tmp/_lp/a/very/long/pathname"
  mkdir -p "${long_path}/" "${long_path/name/foo}/"
}

function pathTearDown {
  rm -r "/tmp/_lp/"
}

function test_get_unique_directory {
  pathSetUp

  typeset lp_unique_directory

  __lp_get_unique_directory "/"
  assertFalse "No shortening on '/'" "$?"

  __lp_get_unique_directory "~"
  assertFalse "No shortening on '~'" "$?"

  __lp_get_unique_directory "/tmp/_lp/a"
  assertFalse "No shortening on 'a'" "$?"

  __lp_get_unique_directory "/tmp/_lp/a/very"
  assertTrue "Shortening on 'very'" "$?"
  assertEquals "Shortening on 'very'" "v" "$lp_unique_directory"

  __lp_get_unique_directory "/tmp/_lp/a/very/long/pathname"
  assertTrue "Partial shortening on 'pathname'" "$?"
  assertEquals "Partial shortening on 'pathname'" "pathn" "$lp_unique_directory"

  pathTearDown
}

function test_path_format() {
  pathSetUp

  typeset HOME="/home/user"
  typeset PWD="/"

  _lp_find_vcs() {
    return 1
  }

  typeset COLUMNS=100
  LP_PATH_LENGTH=100
  LP_PATH_VCS_ROOT=1

  typeset lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory formatting" '{format}/' "$lp_path_format"

  _lp_path_format '{format}' '' '' '' '['
  assertEquals "root directory formatting ignore separator" '{format}/' "$lp_path_format"

  PWD="/tmp"
  _lp_path_format ''
  assertEquals "root directory no formatting" '/tmp' "$lp_path_format"

  _lp_path_format '' '' '' '' '^'
  assertEquals "root directory no formatting custom separator" '/^tmp' "$lp_path_format"

  PWD=$HOME
  _lp_path_format '{format}'
  assertEquals "home directory formatting" '{format}~' "$lp_path_format"

  PWD="/tmp/_lp/a"
  _lp_path_format ''
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  LP_PATH_LENGTH=13

  PWD="/tmp/_lp/a/very"
  _lp_path_format ''
  assertEquals "short directory formatting" "/t/_lp/a/very" "$lp_path_format"

  LP_PATH_LENGTH=1
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "shortened directory formatting" "{n}/{s}t/{s}_/{n}a/{l}very" "$lp_path_format"

  LP_PATH_LENGTH=13
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory formatting" "{n}/{s}t/{n}_lp/{n}a/{l}very" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="/tmp/_lp/a/very"
  }

  PWD="/tmp/_lp/a/very/long/pathname"
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory formatting" "{n}/{s}t/{s}_/{n}a/{v}very/{s}l/{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '^' '{^}'
  assertEquals "full directory formatting with separator" "{n}/{^}^{s}t{^}^{s}_{^}^{n}a{^}^{v}very{^}^{s}l{^}^{l}pathname" "$lp_path_format"

  pathTearDown
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
fi

. ./shunit2


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

function test_floating_scale {
  typeset ret

  __lp_floating_scale '1.23' 100
  assertEquals "scaling 100" '123' "$ret"

  __lp_floating_scale '1.00' 100
  assertEquals "scaling 100" '100' "$ret"

  __lp_floating_scale '1.' 100
  assertEquals "scaling 100" '100' "$ret"

  __lp_floating_scale '1' 100
  assertEquals "scaling 100" '100' "$ret"

  __lp_floating_scale '.01' 100
  assertEquals "scaling 100" '1' "$ret"

  __lp_floating_scale '.01' 100
  assertEquals "scaling 100" '1' "$ret"

  __lp_floating_scale '.10' 100
  assertEquals "scaling 100" '10' "$ret"

  __lp_floating_scale '.1' 100
  assertEquals "scaling 100" '10' "$ret"

  __lp_floating_scale '.001' 100
  assertEquals "scaling 100" '0' "$ret"

  __lp_floating_scale '1000001.001' 100
  assertEquals "scaling 100" '100000100' "$ret"

  __lp_floating_scale '11.1' 1000
  assertEquals "scaling 1000" '11100' "$ret"

  __lp_floating_scale '12.3' 1
  assertEquals "scaling 1" '12' "$ret"

  __lp_floating_scale '12.3' 10
  assertEquals "scaling 10" '123' "$ret"

  __lp_floating_scale '12.34' 10
  assertEquals "scaling 10" '123' "$ret"

  __lp_floating_scale '12.345' 10
  assertEquals "scaling 10" '123' "$ret"
}

function test_get_last_command_line() {
  if (( _LP_SHELL_zsh )); then
    # This is simpler, and only shows one test as skipped instead of per assert.
    startSkipping
    assertTrue ''
    endSkipping
    return
  fi

  builtin() {
    printf '%s\n' "$history_line"
  }

  local command

  history_line=' 100  command'
  __lp_get_last_command_line
  assertEquals "normal history" 'command' "$command"

  history_line='1000  a command'
  __lp_get_last_command_line
  assertEquals "no leading space" 'a command' "$command"

  history_line='    0  a different command'
  __lp_get_last_command_line
  assertEquals "single digit index" 'a different command' "$command"

  history_line='  119* a modified command'
  __lp_get_last_command_line
  assertEquals "modified history" 'a modified command' "$command"

  unset -f builtin
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

function test_path_format_from_path_left() {
  typeset HOME="/home/user"
  typeset PWD="/"

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  typeset COLUMNS=100
  LP_PATH_LENGTH=100
  LP_PATH_KEEP=0
  LP_PATH_VCS_ROOT=1
  LP_PATH_METHOD=truncate_chars_from_path_left
  LP_MARK_SHORTEN_PATH="..."

  typeset lp_path lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory" '/' "$lp_path"
  assertEquals "root directory formatting" '{format}/' "$lp_path_format"

  _lp_path_format '{format}' '' '' '' '['
  assertEquals "root directory ignore separator" '/' "$lp_path"
  assertEquals "root directory formatting ignore separator" '{format}/' "$lp_path_format"

  PWD="/tmp"
  _lp_path_format ''
  assertEquals "tmp directory" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting" '/tmp' "$lp_path_format"

  _lp_path_format '' '' '' '' '^'
  assertEquals "tmp directory no custom separator" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting custom separator" '/^tmp' "$lp_path_format"

  PWD=$HOME
  _lp_path_format '{format}'
  assertEquals "home directory" '~' "$lp_path"
  assertEquals "home directory formatting" '{format}~' "$lp_path_format"

  PWD="/tmp/_lp/a"
  _lp_path_format ''
  assertEquals "short directory" "$PWD" "$lp_path"
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  LP_PATH_LENGTH=1

  PWD="/tmp/_lp/a/very"
  _lp_path_format ''
  assertEquals "short directory" ".../very" "$lp_path"
  assertEquals "short directory formatting" ".../very" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "shortened directory" ".../very" "$lp_path"
  assertEquals "shortened directory formatting" "{s}.../{l}very" "$lp_path_format"

  LP_PATH_LENGTH=13
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory" ".../_lp/a/very" "$lp_path"
  assertEquals "medium directory formatting" "{s}.../{n}_lp/{n}a/{l}very" "$lp_path_format"

  LP_PATH_KEEP=2
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory" "/tmp/.../very" "$lp_path"
  assertEquals "medium directory formatting" "{n}/{n}tmp/{s}.../{l}very" "$lp_path_format"

  LP_PATH_KEEP=3
  # Don't shorten if it would make longer
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory" "/tmp/_lp/a/very" "$lp_path"
  assertEquals "medium directory formatting" "{n}/{n}tmp/{n}_lp/{n}a/{l}very" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="/tmp/_lp/a/very"
  }

  LP_PATH_KEEP=0
  PWD="/tmp/_lp/a/very/long/pathname"
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory" ".../very/.../pathname" "$lp_path"
  assertEquals "full directory formatting" "{s}.../{v}very/{s}.../{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '^' '{^}'
  assertEquals "full directory with separator" ".../very/.../pathname" "$lp_path"
  assertEquals "full directory formatting with separator" "{s}...{^}^{v}very{^}^{s}...{^}^{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '///'
  assertEquals "full directory with multichar separator" ".../very/.../pathname" "$lp_path"
  assertEquals "full directory formatting with multichar separator" "{s}...///{v}very///{s}...///{l}pathname" "$lp_path_format"

  LP_PATH_KEEP=2
  PWD="/tmp/averylong/superduperlong/obviouslytoolong/dir"

  LP_PATH_LENGTH=30
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}...g/{n}obviouslytoolong/{l}dir" "$lp_path_format"

  LP_PATH_LENGTH=29
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}.../{n}obviouslytoolong/{l}dir" "$lp_path_format"

  LP_PATH_LENGTH=28
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}...obviouslytoolong/{l}dir" "$lp_path_format"

  LP_PATH_LENGTH=27
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}...bviouslytoolong/{l}dir" "$lp_path_format"

  PWD="/tmp/a/bc/last"
  LP_PATH_LENGTH=$(( ${#PWD} - 1 ))
  _lp_path_format ''
  assertEquals "2 short dirs shortening" "/tmp/.../last" "$lp_path_format"

  PWD="/tmp/a/b/last"
  LP_PATH_LENGTH=$(( ${#PWD} - 1 ))
  _lp_path_format ''
  assertEquals "2 short dirs no shortening" "/tmp/a/b/last" "$lp_path_format"

  PWD="/tmp/a/b/c/last"
  LP_PATH_LENGTH=$(( ${#PWD} - 1 ))
  _lp_path_format ''
  assertEquals "3 short dirs shortening" "/tmp/...c/last" "$lp_path_format"

  LP_PATH_LENGTH=${#PWD}
  _lp_path_format ''
  assertEquals "3 short dirs no shortening" "/tmp/a/b/c/last" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="/tmp/a/b"
  }

  LP_PATH_LENGTH=$(( ${#PWD} - 1 ))
  _lp_path_format ''
  assertEquals "no shortening" "/tmp/a/b/c/last" "$lp_path_format"

  PWD=$'/a_fake_\\n_newline/and_%100_fresh/and_a_real_\n_newline'
  LP_PATH_LENGTH=${#PWD}
  _lp_path_format ''
  if (( _LP_SHELL_zsh )); then
    assertEquals "shell escapes" $'/a_fake_\\n_newline/and_%100_fresh/and_a_real_\n_newline' "$lp_path"
    assertEquals "shell escapes format" $'/a_fake_\\\\n_newline/and_%%100_fresh/and_a_real_\n_newline' "$lp_path_format"
  else
    assertEquals "shell escapes" $'/a_fake_\\n_newline/and_%100_fresh/and_a_real_\n_newline' "$lp_path"
    assertEquals "shell escapes format" $'/a_fake_\\\\n_newline/and_%100_fresh/and_a_real_\n_newline' "$lp_path_format"
  fi
}

function test_path_format_from_dir_right {
  typeset HOME="/home/user"
  typeset PWD="/"

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  typeset COLUMNS=100
  LP_PATH_LENGTH=100
  LP_PATH_KEEP=0
  LP_PATH_VCS_ROOT=1
  LP_PATH_METHOD=truncate_chars_from_dir_right
  LP_MARK_SHORTEN_PATH="..."
  LP_PATH_CHARACTER_KEEP=1

  typeset lp_path lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory" '/' "$lp_path"
  assertEquals "root directory formatting" '{format}/' "$lp_path_format"

  _lp_path_format '{format}' '' '' '' '['
  assertEquals "root directory ignore separator" '/' "$lp_path"
  assertEquals "root directory formatting ignore separator" '{format}/' "$lp_path_format"

  PWD="/tmp"
  _lp_path_format ''
  assertEquals "tmp directory" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting" '/tmp' "$lp_path_format"

  _lp_path_format '' '' '' '' '^'
  assertEquals "tmp directory custom separator" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting custom separator" '/^tmp' "$lp_path_format"

  PWD=$HOME
  _lp_path_format '{format}'
  assertEquals "home directory" '~' "$lp_path"
  assertEquals "home directory formatting" '{format}~' "$lp_path_format"

  PWD="/tmp/_lp/a"
  _lp_path_format ''
  assertEquals "short directory" "$PWD" "$lp_path"
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  LP_PATH_LENGTH=1

  PWD="/tmp/_lp/a/very"
  _lp_path_format ''
  assertEquals "short directory" "$PWD" "$lp_path"
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  PWD="/avery/muchlong/pathname"
  _lp_path_format ''
  assertEquals "short directory formatting" "/a.../m.../pathname" "$lp_path_format"

  LP_PATH_LENGTH=$(( ${#PWD} - 1 ))
  _lp_path_format ''
  assertEquals "medium directory formatting" "/a.../muchlong/pathname" "$lp_path_format"

  LP_PATH_KEEP=2
  _lp_path_format ''
  assertEquals "medium directory formatting" "/avery/m.../pathname" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="/tmp/_lp/a/very"
  }

  LP_PATH_KEEP=0
  LP_MARK_SHORTEN_PATH="."
  PWD="/tmp/_lp/a/very/long/pathname"
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory" "/t./_./a/very/l./pathname" "$lp_path"
  assertEquals "full directory formatting" "{n}/{s}t./{s}_./{n}a/{v}very/{s}l./{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '///'
  assertEquals "full directory with multichar separator" "/t./_./a/very/l./pathname" "$lp_path"
  assertEquals "full directory formatting with multichar separator" "{n}////{s}t.///{s}_.///{n}a///{v}very///{s}l.///{l}pathname" "$lp_path_format"

  LP_PATH_KEEP=2
  PWD="/tmp/averylong/superduperlong/obviouslytoolong/dir"

  LP_PATH_LENGTH=31
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory length $LP_PATH_LENGTH" "/tmp/a./s./obviouslytoolong/dir" "$lp_path"
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}a./{s}s./{n}obviouslytoolong/{l}dir" "$lp_path_format"

  LP_PATH_LENGTH=30
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory length $LP_PATH_LENGTH" "/tmp/a./s./o./dir" "$lp_path"
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}a./{s}s./{s}o./{l}dir" "$lp_path_format"
}

function test_path_format_from_dir_middle {
  typeset HOME="/home/user"
  typeset PWD="/"

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  typeset COLUMNS=100
  LP_PATH_LENGTH=100
  LP_PATH_KEEP=0
  LP_PATH_VCS_ROOT=1
  LP_PATH_METHOD=truncate_chars_from_dir_middle
  LP_MARK_SHORTEN_PATH="..."
  LP_PATH_CHARACTER_KEEP=1

  typeset lp_path lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory" '/' "$lp_path"
  assertEquals "root directory formatting" '{format}/' "$lp_path_format"

  _lp_path_format '{format}' '' '' '' '['
  assertEquals "root directory ignore separator" '/' "$lp_path"
  assertEquals "root directory formatting ignore separator" '{format}/' "$lp_path_format"

  PWD="/tmp"
  _lp_path_format ''
  assertEquals "tmp directory" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting" '/tmp' "$lp_path_format"

  _lp_path_format '' '' '' '' '^'
  assertEquals "tmp directory custom separator" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting custom separator" '/^tmp' "$lp_path_format"

  PWD=$HOME
  _lp_path_format '{format}'
  assertEquals "home directory" '~' "$lp_path"
  assertEquals "home directory formatting" '{format}~' "$lp_path_format"

  PWD="/tmp/_lp/a"
  _lp_path_format ''
  assertEquals "short directory" "$PWD" "$lp_path"
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  LP_PATH_LENGTH=1

  PWD="/tmp/_lp/a/very"
  _lp_path_format ''
  assertEquals "short directory" "$PWD" "$lp_path"
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  PWD="/avery/muchlong/pathname"
  _lp_path_format ''
  assertEquals "short directory" "/avery/m...g/pathname" "$lp_path"
  assertEquals "short directory formatting" "/avery/m...g/pathname" "$lp_path_format"

  LP_MARK_SHORTEN_PATH="."
  PWD="/avery/muchlong/pathname"
  _lp_path_format ''
  assertEquals "short directory" "/a.y/m.g/pathname" "$lp_path"
  assertEquals "short directory formatting" "/a.y/m.g/pathname" "$lp_path_format"

  LP_PATH_LENGTH=$(( ${#PWD} - 1 ))
  _lp_path_format ''
  assertEquals "medium directory" "/a.y/muchlong/pathname" "$lp_path"
  assertEquals "medium directory formatting" "/a.y/muchlong/pathname" "$lp_path_format"

  LP_PATH_KEEP=2
  _lp_path_format ''
  assertEquals "medium directory" "/avery/m.g/pathname" "$lp_path"
  assertEquals "medium directory formatting" "/avery/m.g/pathname" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="/tmp/_lp/a/very"
  }

  LP_PATH_KEEP=0
  PWD="/tmp/_lp/a/very/long/pathname"
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory" "/tmp/_lp/a/very/l.g/pathname" "$lp_path"
  assertEquals "full directory formatting" "{n}/{n}tmp/{n}_lp/{n}a/{v}very/{s}l.g/{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '///'
  assertEquals "full directory with multichar separator" "/tmp/_lp/a/very/l.g/pathname" "$lp_path"
  assertEquals "full directory formatting with multichar separator" "{n}////{n}tmp///{n}_lp///{n}a///{v}very///{s}l.g///{l}pathname" "$lp_path_format"

  LP_PATH_KEEP=2
  PWD="/tmp/averylong/superduperlong/obviouslytoolong/dir"

  LP_PATH_LENGTH=33
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory length $LP_PATH_LENGTH" "/tmp/a.g/s.g/obviouslytoolong/dir" "$lp_path"
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}a.g/{s}s.g/{n}obviouslytoolong/{l}dir" "$lp_path_format"

  LP_PATH_LENGTH=32
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory length $LP_PATH_LENGTH" "/tmp/a.g/s.g/o.g/dir" "$lp_path"
  assertEquals "full directory formatting length $LP_PATH_LENGTH" "{n}/{n}tmp/{s}a.g/{s}s.g/{s}o.g/{l}dir" "$lp_path_format"
}

function test_path_format_unique() {
  pathSetUp

  typeset HOME="/home/user"
  typeset PWD="/"

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  typeset COLUMNS=100
  LP_PATH_LENGTH=100
  LP_PATH_KEEP=0
  LP_PATH_VCS_ROOT=1
  LP_PATH_METHOD=truncate_chars_to_unique_dir

  typeset lp_path lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory" '/' "$lp_path"
  assertEquals "root directory formatting" '{format}/' "$lp_path_format"

  _lp_path_format '{format}' '' '' '' '['
  assertEquals "root directory ignore separator" '/' "$lp_path"
  assertEquals "root directory formatting ignore separator" '{format}/' "$lp_path_format"

  PWD="/tmp"
  _lp_path_format ''
  assertEquals "tmp directory" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting" '/tmp' "$lp_path_format"

  _lp_path_format '' '' '' '' '^'
  assertEquals "tmp directory custom separator" '/tmp' "$lp_path"
  assertEquals "tmp directory no formatting custom separator" '/^tmp' "$lp_path_format"

  PWD=$HOME
  _lp_path_format '{format}'
  assertEquals "home directory" '~' "$lp_path"
  assertEquals "home directory formatting" '{format}~' "$lp_path_format"

  PWD="/tmp/_lp/a"
  _lp_path_format ''
  assertEquals "short directory" "$PWD" "$lp_path"
  assertEquals "short directory formatting" "$PWD" "$lp_path_format"

  LP_PATH_LENGTH=13

  PWD="/tmp/_lp/a/very"
  _lp_path_format ''
  assertEquals "short directory" "/t/_lp/a/very" "$lp_path"
  assertEquals "short directory formatting" "/t/_lp/a/very" "$lp_path_format"

  LP_PATH_LENGTH=1
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "shortened directory" "/t/_/a/very" "$lp_path"
  assertEquals "shortened directory formatting" "{n}/{s}t/{s}_/{n}a/{l}very" "$lp_path_format"

  LP_PATH_LENGTH=13
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory" "/t/_lp/a/very" "$lp_path"
  assertEquals "medium directory formatting" "{n}/{s}t/{n}_lp/{n}a/{l}very" "$lp_path_format"

  LP_PATH_KEEP=2
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory" "/tmp/_/a/very" "$lp_path"
  assertEquals "medium directory formatting" "{n}/{n}tmp/{s}_/{n}a/{l}very" "$lp_path_format"

  LP_PATH_KEEP=3
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "medium directory" "/tmp/_lp/a/very" "$lp_path"
  assertEquals "medium directory formatting" "{n}/{n}tmp/{n}_lp/{n}a/{l}very" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="/tmp/_lp/a/very"
  }

  LP_PATH_KEEP=0
  PWD="/tmp/_lp/a/very/long/pathname"
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory " "/t/_/a/very/l/pathname" "$lp_path"
  assertEquals "full directory formatting" "{n}/{s}t/{s}_/{n}a/{v}very/{s}l/{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '^' '{^}'
  assertEquals "full directory with separator" "/t/_/a/very/l/pathname" "$lp_path"
  assertEquals "full directory formatting with separator" "{n}/{^}^{s}t{^}^{s}_{^}^{n}a{^}^{v}very{^}^{s}l{^}^{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '///'
  assertEquals "full directory with multichar separator" "/t/_/a/very/l/pathname" "$lp_path"
  assertEquals "full directory formatting with multichar separator" "{n}////{s}t///{s}_///{n}a///{v}very///{s}l///{l}pathname" "$lp_path_format"

  pathTearDown
}

function test_path_format_last_dir() {
  typeset HOME="/home/user"
  typeset PWD="/"

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  LP_PATH_VCS_ROOT=1
  LP_PATH_METHOD=truncate_to_last_dir

  typeset lp_path lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory" '/' "$lp_path"
  assertEquals "root directory formatting" '{format}/' "$lp_path_format"

  _lp_path_format '{format}' '' '' '' '['
  assertEquals "root directory ignore separator" '/' "$lp_path"
  assertEquals "root directory formatting ignore separator" '{format}/' "$lp_path_format"

  PWD="/tmp"
  _lp_path_format ''
  assertEquals "tmp directory" 'tmp' "$lp_path"
  assertEquals "tmp directory no formatting" 'tmp' "$lp_path_format"

  _lp_path_format '' '' '' '' '^'
  assertEquals "tmp directory no custom separator" 'tmp' "$lp_path"
  assertEquals "tmp directory no formatting custom separator" 'tmp' "$lp_path_format"

  PWD=$HOME
  _lp_path_format '{format}'
  assertEquals "home directory" '~' "$lp_path"
  assertEquals "home directory formatting" '{format}~' "$lp_path_format"

  PWD="/tmp/_lp/a"
  _lp_path_format ''
  assertEquals "short directory" "a" "$lp_path"
  assertEquals "short directory formatting" "a" "$lp_path_format"

  PWD="/tmp/_lp/a/very"
  _lp_path_format ''
  assertEquals "short directory" "very" "$lp_path"
  assertEquals "short directory formatting" "very" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "shortened directory" "very" "$lp_path"
  assertEquals "shortened directory formatting" "{l}very" "$lp_path_format"

  _lp_find_vcs() {
    lp_vcs_root="$PWD"
  }

  PWD="/tmp/_lp/a/very"
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory vcs" "very" "$lp_path"
  assertEquals "full directory vcs formatting" "{v}very" "$lp_path_format"

  LP_PATH_VCS_ROOT=0
  _lp_path_format '{n}' '{l}' '{v}' '{s}'
  assertEquals "full directory" "very" "$lp_path"
  assertEquals "full directory formatting" "{l}very" "$lp_path_format"

  PWD="/tmp/_lp/a/very/long/pathname"
  _lp_path_format '{n}' '{l}' '{v}' '{s}' '^' '{^}'
  assertEquals "full directory with separator" "pathname" "$lp_path"
  assertEquals "full directory formatting with separator" "{l}pathname" "$lp_path_format"

  _lp_path_format '{n}' '{l}' '{v}' '{s}' '///'
  assertEquals "full directory with multichar separator" "pathname" "$lp_path"
  assertEquals "full directory formatting with multichar separator" "{l}pathname" "$lp_path_format"
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

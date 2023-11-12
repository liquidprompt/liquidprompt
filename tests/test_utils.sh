
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ../liquidprompt --no-activate

function test_strip_escape {
  typeset ret

  # The escape sequences are different on Bash and Zsh
  __lp_strip_escapes "${_LP_OPEN_ESC}bad text${_LP_CLOSE_ESC}a normal string without ${_LP_OPEN_ESC}color${_LP_CLOSE_ESC}colors"
  assertEquals "basic text removal" "a normal string without colors" "$ret"

  __lp_strip_escapes "${_LP_OPEN_ESC}"$'\a\b'"${_LP_CLOSE_ESC}str${_LP_OPEN_ESC}"$'\001\E'"${_LP_CLOSE_ESC}ing"
  assertEquals "control character internal removal" "string" "$ret"

  __lp_strip_escapes "${_LP_OPEN_ESC}"$'\a\b'"${_LP_CLOSE_ESC}st"$'\t'"r${_LP_OPEN_ESC}"$'\001\E'"${_LP_CLOSE_ESC}ing"
  assertEquals "control character external removal" $'st\tring' "$ret"

  __lp_strip_escapes "${_LP_OPEN_ESC}"$'\a\b'"${_LP_CLOSE_ESC}st\\\\r${_LP_OPEN_ESC}"$'\001\E'"${_LP_CLOSE_ESC}ing"
  assertEquals "control character escaped removal" $'st\\ring' "$ret"
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

  typeset command

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
  # We cannot use SHUNIT_TMPDIR because we need to know the start of the path
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

  LP_ENABLE_PATH=1

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  LP_ENABLE_HYPERLINKS=0
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

  LP_ENABLE_PATH=1

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_SHORTEN_PATH=1
  LP_ENABLE_HYPERLINKS=0
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

  LP_ENABLE_PATH=1
  LP_ENABLE_SHORTEN_PATH=1
  LP_ENABLE_HYPERLINKS=0
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

  LP_ENABLE_PATH=1
  LP_ENABLE_SHORTEN_PATH=1
  LP_ENABLE_HYPERLINKS=0
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

  LP_ENABLE_PATH=1
  LP_ENABLE_SHORTEN_PATH=1
  LP_ENABLE_HYPERLINKS=0
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

function test_no_path_format() {
  typeset HOME="/home/user"
  typeset PWD="/"

  LP_ENABLE_PATH=0

  _lp_path_format '{format}'
  assertEquals "$?" "2"
}

function test_path_links() {
  typeset HOME="/home/user"
  typeset PWD="/"
  typeset SSH_CONNECTION="1.2.3.4 111 5.6.7.8 222"

  _lp_find_vcs() {
    return 1
  }

  LP_ENABLE_PATH=1
  LP_ENABLE_SHORTEN_PATH=0
  LP_ENABLE_HYPERLINKS=0
  LP_PATH_VCS_ROOT=1

  typeset lp_path lp_path_format

  _lp_path_format '{format}'
  assertEquals "root directory" '/' "$lp_path"
  assertContains "root directory formatting" "$lp_path_format" '{format}/'

  LP_ENABLE_HYPERLINKS=1

  typeset url="https://test.io/"
  typeset label="liquid link"
  typeset expected_link="$_LP_OPEN_ESC"$'\E]8;;'"${url}"$'\E'"${_LP_BACKSLASH}${_LP_CLOSE_ESC}${label}${_LP_OPEN_ESC}"$'\E]8;;\E'"${_LP_BACKSLASH}$_LP_CLOSE_ESC"
  _lp_create_link "$url" "$label"
  assertEquals "typical OSC-8 escape sequence" "$expected_link" "$lp_link"

  url="https://test&eacute;.io/?var=1&dbg=2"
  label="liquid\tlink"
  expected_link="$_LP_OPEN_ESC"$'\E]8;;'"${url}"$'\E'"${_LP_BACKSLASH}${_LP_CLOSE_ESC}${label}${_LP_OPEN_ESC}"$'\E]8;;\E'"${_LP_BACKSLASH}$_LP_CLOSE_ESC"
  _lp_create_link "$url" "$label"
  assertEquals "typical OSC-8 escape sequence with complex text" "$expected_link" "$lp_link"

  typeset pathword="home"
  typeset PWD="/home/nojhan"
  typeset USER="nojhan"

  typeset SSH_CLIENT="ssh"
  typeset expected_url="sftp://$USER@5.6.7.8:111/$PWD/"
  expected_link="$_LP_OPEN_ESC"$'\E]8;;'"${expected_url}"$'\E'"${_LP_BACKSLASH}${_LP_CLOSE_ESC}home${_LP_OPEN_ESC}"$'\E]8;;\E'"${_LP_BACKSLASH}$_LP_CLOSE_ESC"
  _lp_create_link_path "$pathword"
  assertEquals "SSH: path element linked to SFTP" "$expected_link" "$lp_link_path"

  unset SSH_CLIENT SSH2_CLIENT SSH_TTY
  ps() {
    printf "su"
  }
  typeset expected_url="file://$PWD/"
  expected_link="$_LP_OPEN_ESC"$'\E]8;;'"${expected_url}"$'\E'"${_LP_BACKSLASH}${_LP_CLOSE_ESC}home${_LP_OPEN_ESC}"$'\E]8;;\E'"${_LP_BACKSLASH}$_LP_CLOSE_ESC"
  _lp_create_link_path "$pathword"
  assertEquals "su: path element linked to FILE" "$expected_link" "$lp_link_path"

  typeset REMOTEHOST="spongebob"
  _lp_create_link_path "$pathword"
  assertEquals "telnet: path element not linked" "$pathword" "$lp_link_path"
}

function test_lp_fill {
    typeset lp_fill

    COLUMNS=80
    _lp_fill "Left" "Right" " "
    assertEquals "full width" 80 ${#lp_fill}

    COLUMNS=3
    _lp_fill "L" "R" "-"
    assertEquals "single fill" "L-R" "$lp_fill"

    _lp_fill "L" "R" ""
    assertEquals "defaults to space" "L R" "$lp_fill"

    COLUMNS=5
    _lp_fill "L" "R" "~"
    assertEquals "simple fill 5" "L~~~R" "$lp_fill"

    COLUMNS=6
    _lp_fill "L" "R" "+-"
    assertEquals "multi-fill 6" "L+-+-R" "$lp_fill"

    _lp_fill "L" "R" "123" 1
    assertEquals "multi-fill 6 split" "L1231R" "$lp_fill"

    _lp_fill "L${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" "R" "123" 0
    assertEquals "multi-fill 6 with escape and no split" "L${_LP_OPEN_ESC}${_LP_CLOSE_ESC}123 R" "$lp_fill"

    _lp_fill "L${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" "${_LP_OPEN_ESC}${_LP_CLOSE_ESC}R" "123" 0
    assertEquals "multi-fill 6 with double escapes and no split" "L${_LP_OPEN_ESC}${_LP_CLOSE_ESC}123 ${_LP_OPEN_ESC}${_LP_CLOSE_ESC}R" "$lp_fill"

    _lp_fill "L" "R" "${_LP_OPEN_ESC}${_LP_CLOSE_ESC}123" 1
    assertEquals "multi-fill 6 with wrong escape and split" "L1231R" "$lp_fill"

    _lp_fill "L${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" "R" "123" 1
    assertEquals "multi-fill 6 with escape and split" "L${_LP_OPEN_ESC}${_LP_CLOSE_ESC}1231R" "$lp_fill"

    _lp_fill "L" "R" "${_LP_OPEN_ESC}${_LP_CLOSE_ESC}123${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" 1
    assertEquals "multi-fill 6 with double escapes and split" "L1231R" "$lp_fill"

    COLUMNS=11
    _lp_fill "Left" "Right" "="
    assertEquals "regular fill 11" "Left==Right" "$lp_fill"

    _lp_fill "Le" "Ri" "+-"
    assertEquals "multi-fill 11 split default" "Le+-+-+-+Ri" "$lp_fill"

    _lp_fill "Le" "Ri" "+-" 0
    assertEquals "multi-fill 11 no split" "Le+-+-+- Ri" "$lp_fill"

    _lp_fill "Le" "Ri" "+-" 1
    assertEquals "multi-fill 11 explicit split" "Le+-+-+-+Ri" "$lp_fill"

    _lp_fill "Le" "Ri" "123" 1
    assertEquals "multi-fill 11 with split" "Le1231231Ri" "$lp_fill"

    _lp_fill "Le${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" "Ri" "123" 0
    assertEquals "multi-fill 11 with escape and no split" "Le${_LP_OPEN_ESC}${_LP_CLOSE_ESC}123123 Ri" "$lp_fill"

    _lp_fill "Le${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" "Ri" "123${_LP_OPEN_ESC}${_LP_CLOSE_ESC}" 1
    assertEquals "multi-fill 11 with double escape and split" "Le${_LP_OPEN_ESC}${_LP_CLOSE_ESC}1231231Ri" "$lp_fill"

    # The following tests require a UTF-8 locale to be set.
    # The Windows runners have issues with these Unicode characters.
    if [[ ! ( ${LC_CTYPE-} == *UTF-8 || ${LANG-} == *UTF-8 || ${LC_ALL-} == *UTF-8 ) \
          || ${RUNNER_OS-} == "Windows" ]]; then
        # Skip all the following tests.
        startSkipping
    fi

    COLUMNS=32
    _lp_fill "Left part·" "·right part" "⣀⠔⠉⠢" 1
    assertEquals "beautiful fill" "Left part·⣀⠔⠉⠢⣀⠔⠉⠢⣀⠔⠉·right part" "$lp_fill"
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

function test_hash_color {
    PS1="$ "
    lp_activate --no-config # For having _lp_foreground
    _lp_hash_color "Debug"
    assertContains "$lp_hash_color" "Debug"
    # FIXME How to test color?
}

function test_join {
    _lp_join "_" "A" "B " " " " C" " D " "EE"
    assertEquals "A_B _ _ C_ D _EE" "$lp_join"

    _lp_join "-" "A"
    assertEquals "A" "$lp_join"

    _lp_join "+" ""
    assertEquals "" "$lp_join"

    typeset -a arr
    arr=(1 2 3)
    _lp_join "/" "${arr[@]}"
    assertEquals "1/2/3" "$lp_join"
}

function test_grep_fields {
    filename=$(mktemp)

    printf 'key1:value1\nkey2:value2\n' > "$filename"
    _lp_grep_fields "$filename" ":" "key1" "key2"
    assertEquals 2 ${#lp_grep_fields[@]}
    assertEquals "value1" ${lp_grep_fields[_LP_FIRST_INDEX+0]}
    assertEquals "value2" ${lp_grep_fields[_LP_FIRST_INDEX+1]}

    # Two-char delimiter, reverse orders of keys.
    printf 'key1:=value1\nkey2:=value2\n' > "$filename"
    _lp_grep_fields "$filename" ":=" "key2" "key1"
    assertEquals 2 ${#lp_grep_fields[@]}
    assertEquals "value2" ${lp_grep_fields[_LP_FIRST_INDEX+0]}
    assertEquals "value1" ${lp_grep_fields[_LP_FIRST_INDEX+1]}

    # No end of line.
    printf '[section]\nkey1=value1' > "$filename"
    _lp_grep_fields "$filename" "=" "key1"
    assertEquals 1 ${#lp_grep_fields[@]}
    assertEquals "value1" ${lp_grep_fields[_LP_FIRST_INDEX+0]}

    # Bad keys with spaces.
    printf ' key1 :NOPE\nkey1:value1\nNOPE:NOPE\n key1:NOPE\nkey1 :NOPE' > "$filename"
    _lp_grep_fields "$filename" ":" "key1"
    assertEquals 1 ${#lp_grep_fields[@]}
    assertEquals "value1" ${lp_grep_fields[_LP_FIRST_INDEX+0]}

    # Delimiter in key name/value.
    printf 'key1=value1\nkey2=value=key2=?\nkey3==val\n' > "$filename"
    _lp_grep_fields "$filename" "=" "key1" "key2" "key3"
    assertEquals 3 ${#lp_grep_fields[@]}
    assertEquals "value1" ${lp_grep_fields[_LP_FIRST_INDEX+0]}
    assertEquals "value=key2=?" ${lp_grep_fields[_LP_FIRST_INDEX+1]}
    assertEquals "=val" ${lp_grep_fields[_LP_FIRST_INDEX+2]}

    # Empty file.
    printf '\n' > "$filename"
    _lp_grep_fields "$filename" ":=" "nokey"
    assertTrue "found a non existing key" '[[ -z "${lp_grep_fields[_LP_FIRST_INDEX+0]+x}" ]]'

    # Really empty file.
    printf '' > "$filename"
    _lp_grep_fields "$filename" ":=" "nokey"
    assertTrue "found a non existing key" '[[ -z "${lp_grep_fields[_LP_FIRST_INDEX+0]+x}" ]]'

    rm -f "$filename"
}

function test_version {
    _LP_VERSION=(1 2 3 beta 4)

    _lp_version_greatereq 1 2 3 beta 4
    assertTrue "equal version" "$?"

    _lp_version_greatereq 1 2 3 beta 5
    assertFalse "lesser version number" "$?"
    _lp_version_greatereq 1 2 3 rc 1
    assertFalse "lesser version string" "$?"
    _lp_version_greatereq 1 2 4 beta 4
    assertFalse "lesser version patch" "$?"
    _lp_version_greatereq 1 3 3 beta 4
    assertFalse "lesser version minor" "$?"
    _lp_version_greatereq 2 2 3 beta 4
    assertFalse "lesser version major" "$?"

    _lp_version_greatereq 1 2 3 beta 3
    assertTrue "greater version number" "$?"
    _lp_version_greatereq 1 2 3 alpha 4
    assertTrue "greater version string" "$?"
    _lp_version_greatereq 1 2 2 beta 4
    assertTrue "greater version patch" "$?"
    _lp_version_greatereq 1 1 3 beta 4
    assertTrue "greater version minor" "$?"
    _lp_version_greatereq 0 2 3 beta 4
    assertTrue "greater version major" "$?"

    _lp_version_string # Defaults to _LP_VERSION
    assertEquals "1.2.3-beta.4" "$lp_version"

    _lp_version_string 5 4 3 rc 2
    assertEquals "5.4.3-rc.2" "$lp_version"

    _lp_version_string 5 4 3 rc
    assertEquals "5.4.3-rc" "$lp_version"

    _lp_version_string 5 4 3
    assertEquals "5.4.3" "$lp_version"

    _lp_version_string 5 4
    assertEquals "5.4" "$lp_version"
}

function test_substitute {
    typeset sub
    sub=(
        "When"  "NOK"
        "What?" "NOPE"
        "What"  "OK"
    )
    _lp_substitute "What" "${sub[@]}"
    assertEquals "OK" "$lp_substitute"
}

. ./shunit2

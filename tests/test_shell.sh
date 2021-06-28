
# Error on unset variables
set -u

function test_test {
  assertTrue "[[ form of test" '[[ 1 -eq 1 ]]'

  assertTrue "[[ -n" '[[ -n foo ]]'
  assertTrue "[[ -n quoted" '[[ -n "foo" ]]'
  assertFalse "[[ -n empty quoted" '[[ -n "" ]]'

  assertFalse "[[ -z" '[[ -z foo ]]'
  assertFalse "[[ -z quoted" '[[ -z "foo" ]]'
  assertTrue "[[ -z empty quoted" '[[ -z "" ]]'
}

function test_redirection {
  assertTrue "Redirection stdout" 'echo foo >/dev/null'
  assertEquals "Redirection stdout" "" "$(echo foo >/dev/null)"
  assertTrue "Redirection stderr" 'echo foo 2>/dev/null'
  assertEquals "Redirection stdout" "foo" "$(echo foo 2>/dev/null)"
  assertTrue "Redirection stdout and stderr" 'echo foo >/dev/null 2>&1'
  assertEquals "Redirection stdout and stderr" "" "$(echo foo >/dev/null 2>&1)"
}

function test_block {
  assertTrue "Basic block return code" '{ : ; }'
  assertFalse "Basic block return code" '{ false; }'
  assertTrue "Basic block redirection" '{ echo foo; } >/dev/null'
  assertEquals "Basic block redirection" "" "$({ echo foo; } >/dev/null)"
}

function test_case {
  case abcd in
    ab*)
      assertTrue ${SHUNIT_TRUE}
      ;;
    *)
      fail "Case failed glob match"
      ;;
  esac

  case abcd in
    abcd|efgh)
      assertTrue ${SHUNIT_TRUE}
      ;;
    *)
      fail "Case failed or (|) match"
      ;;
  esac

  case abcd in
    efgh)
      : ;;
    *)
      :
      # Missing ;; on the last statement
  esac
  assertTrue "Missing ';;' on case statement not ignored" $?

  case abcd in
    efgh)
      : ;;
  esac
  assertTrue "Missing default on case statement not ignored" $?
}

function test_unset {
  assertTrue "var should start unset" '[[ -z ${var+x} ]]'
  var=""
  assertFalse "var should now be set" '[[ -z ${var+x} ]]'
  unset var
  assertTrue "var should again be unset" '[[ -z ${var+x} ]]'

  assertFalse "function should start unset" 'typeset -f local_function'
  function local_function { :; }
  assertTrue "function should now be set" 'typeset -f local_function >/dev/null'
  unset -f local_function
  assertFalse "function should again be unset" 'typeset -f local_function'
}

function test_local {
  typeset a
  a=2
  assertEquals "Local assignment" 2 "$a"

  typeset b=3
  assertEquals "Local inline assignment" 3 "$b"

  function local_function {
    typeset c=4
  }

  local_function
  assertNull "c should not be set" "${c+x}"

  function local_function {
    assertEquals "c should inherit from outer scope" 5 "$c"
    typeset c=4
    assertEquals "c should be overridden by inner scope" 4 "$c"
  }

  c=5
  local_function
  assertEquals "c should not be modified" 5 "$c"

  function local_function {
    typeset d=6 e=7
    assertEquals "d should be set in inner scope" 6 "$d"
    assertEquals "e should be set in inner scope" 7 "$e"
  }

  local_function
  assertNull "d should not be set" "${d+x}"
  assertNull "e should not be set" "${e+x}"

  unset -f local_function
}

function test_here_string {
  assertEquals "Here string failed" "foobar" $(cat <<< "foobar")
}

function test_read {
  typeset IFS=' '
  # The check of the vars must be done in the same subshell as the read, as
  # they won't exist after the pipeline terminates
  printf '%s %s %s' foo bar baz | { read a b c
    assertEquals "read first var" "foo" "$a"
    assertEquals "read second var" "bar" "$b"
    assertEquals "read last var" "baz" "$c"
  }

  printf '%s %s %s' foo bar baz | { read a eof
    assertEquals "read first var" "foo" "$a"
    assertEquals "read ending vars" "bar baz" "$eof"
  }

  # Same as above, but with here-string
  read a eof <<<"foo bar baz"
  assertEquals "read first var" "foo" "$a"
  assertEquals "read ending vars" "bar baz" "$eof"

  # Test -r
  read -r a b <<<"foo \bar"
  assertEquals "read first var" "foo" "$a"
  assertEquals "read backslash var" "\bar" "$b"

  # Test empty vars
  read a b <<<"foo"
  assertEquals "read first var" "foo" "$a"
  assertEquals "read empty var" "" "$b"
}

function test_parameter_expansion_unset {
  assertEquals "Parameter expansion unset replace unset" "foo" "${var:-foo}"
  assertEquals "Parameter expansion unset replace unset" "foo" "${var-foo}"
  # zsh treats `typeset var` equal to `typeset var=`, while ksh and bash treat
  # them differently. This makes the `${var-replace}` form not safe
  typeset var=
  assertEquals "Parameter expansion unset replace empty" "foo" "${var:-foo}"
  assertEquals "Parameter expansion unset replace empty" "" "${var-foo}"
  var=bar
  assertEquals "Parameter expansion unset don't replace" "bar" "${var:-foo}"
  assertEquals "Parameter expansion unset don't replace" "bar" "${var-foo}"
  unset var

  # This form is only useful if the `set -u` option is set, to prevent the shell
  # From erroring on accessing an unset variable. Think of it as a declaration
  # that you know it might be unset and it doesn't matter.
  assertEquals "Parameter expansion unset replace unset with null" "" "${var-}"

  assertEquals "Parameter expansion unset replace unset quoted" "foo" "${var-"foo"}"
  assertEquals "Parameter expansion unset replace unset with dash" "foo-bar" "${var-foo-bar}"
}

function test_parameter_expansion_set {
  assertEquals "Parameter expansion unset replace set" "" "${var:+foo}"
  assertEquals "Parameter expansion unset replace set" "" "${var+foo}"
  # zsh treats `typeset var` equal to `typeset var=""`
  # This makes the `${var-replace}` form not safe
  typeset var=""
  assertEquals "Parameter expansion unset replace nonempty" "" "${var:+foo}"
  assertEquals "Parameter expansion unset replace notset" "foo" "${var+foo}"
  var=bar
  assertEquals "Parameter expansion unset do replace" "foo" "${var:+foo}"
  assertEquals "Parameter expansion unset do replace" "foo" "${var+foo}"
}

function test_parameter_expansion_assign {
  assertEquals "Parameter expansion assign unset" "foo" "${var:=foo}"
  assertEquals "Parameter expansion assign unset assigned" "foo" "$var"
  unset var
  assertEquals "Parameter expansion assign unset" "foo" "${var=foo}"
  assertEquals "Parameter expansion assign unset assigned" "foo" "$var"
  unset var

  typeset var=""
  assertEquals "Parameter expansion assign empty" "foo" "${var:=foo}"
  assertEquals "Parameter expansion assign unset assigned" "foo" "$var"
  var=""
  assertEquals "Parameter expansion assign empty" "" "${var=foo}"
  assertEquals "Parameter expansion assign empty assigned" "" "$var"

  var=bar
  assertEquals "Parameter expansion don't assign" "bar" "${var:=foo}"
  assertEquals "Parameter expansion not assigned" "bar" "$var"
  assertEquals "Parameter expansion don't assign" "bar" "${var=foo}"
  assertEquals "Parameter expansion not assigned" "bar" "$var"
}

function test_parameter_expansion_cut {
  typeset var=abcdabcd

  assertEquals "Parameter expansion shortest starting cut" cdabcd "${var#ab}"
  assertEquals "Parameter expansion shortest starting cut" $var "${var#b}"
  assertEquals "Parameter expansion shortest starting cut glob" cdabcd "${var#*b}"
  assertEquals "Parameter expansion longest starting cut glob" cd "${var##*ab}"

  assertEquals "Parameter expansion shortest trailing cut" abcdab "${var%cd}"
  assertEquals "Parameter expansion shortest trailing cut" $var "${var%c}"
  assertEquals "Parameter expansion shortest trailing cut glob" abcdab "${var%c*}"
  assertEquals "Parameter expansion longest trailing cut glob" ab "${var%%cd*}"

  assertEquals "Parameter expansion nothing starting cut" "$var" "${var#foo}"
  assertEquals "Parameter expansion nothing starting cut glob" "$var" "${var##*foo}"
  assertEquals "Parameter expansion nothing trailing cut" "$var" "${var%foo}"
  assertEquals "Parameter expansion nothing trailing cut glob" "$var" "${var%%foo*}"
}

function test_parameter_expansion_replace {
  typeset var=abcdabcd

  assertEquals "Parameter expansion replace" cdabcd "${var/ab}"
  assertEquals "Parameter expansion replace ?" dabcd "${var/ab?}"
  assertEquals "Parameter expansion replace *" d "${var/a*c}"
  assertEquals "Parameter expansion replace all" cdcd "${var//ab}"
  assertEquals "Parameter expansion replace all ?" dd "${var//ab?}"
  assertEquals "Parameter expansion replace all *" d "${var//a*c}"

  assertEquals "Parameter expansion replace start" cdabcd "${var/#ab}"
  assertEquals "Parameter expansion replace start no match" $var "${var/#b}"

  assertEquals "Parameter expansion replace end" abcdab "${var/%cd}"
  assertEquals "Parameter expansion replace end no match" $var "${var/%c}"
}

function test_parameter_expansion_nested {
  typeset foo=bar

  assertEquals "Parameter expansion nested null" "bar" "${var:-$foo}"
  assertEquals "Parameter expansion nested unset" "bar" "${var-$foo}"
  assertEquals "Parameter expansion nested null quoted" "bar" "${var:-"$foo"}"
  assertEquals "Parameter expansion nested unset quoted" "bar" "${var-"$foo"}"
  assertEquals "Parameter expansion nested null brackets" "bar" "${var:-${foo}}"
  assertEquals "Parameter expansion nested unset brackets" "bar" "${var-${foo}}"
}

function test_substring {
  typeset var=abcdabcd

  assertEquals "Parameter expansion substring" "$var" "${var:0}"
  assertEquals "Parameter expansion substring" "bcdabcd" "${var:1}"
  assertEquals "Parameter expansion substring" "" "${var:0:0}"
  assertEquals "Parameter expansion substring" "a" "${var:0:1}"
  assertEquals "Parameter expansion substring" "ab" "${var:0:2}"

  assertEquals "Parameter expansion substring" "c" "${var:6:1}"
  assertEquals "Parameter expansion substring" "cd" "${var:6:2}"
  assertEquals "Parameter expansion substring" "cd" "${var:6:3}"
  assertEquals "Parameter expansion substring" "d" "${var:7:1}"
  assertEquals "Parameter expansion substring" "d" "${var:7:2}"
  assertEquals "Parameter expansion substring" "" "${var:8:1}"

  assertEquals "Parameter expansion substring" "d" "${var: -1:1}"
  assertEquals "Parameter expansion substring" "" "${var: -1:0}"
  assertEquals "Parameter expansion substring" "bcd" "${var: -3:5}"

  assertEquals "Parameter expansion substring" "bcd" "${var: -3}"

  # Negative second parameters were not supported until Bash 4.2
}

function test_ansi_c_quoted_string {
  typeset newline='
'
  assertEquals "ANSI C quoted newline" "$newline" $'\n'
  assertEquals "ANSI C quoted tab" "	" $'\t'
}

function test_advanced_test {
  assertTrue "[[ -z empty var" '[[ -z ${var-} ]]'
  assertTrue "[[ -z empty var quoted" '[[ -z "${var-}" ]]'
  assertFalse "[[ -n empty var" '[[ -n ${var-} ]]'
  assertFalse "[[ -n empty var quoted" '[[ -n "${var-}" ]]'

  assertTrue "[[ -f" '[[ -f ./shunit2 ]]'
  assertFalse "[[ -f not a file" '[[ -f / ]]'

  assertTrue "[[ -r file" '[[ -r ./shunit2 ]]'
  assertTrue "[[ -r dir" '[[ -r / ]]'
  assertFalse "[[ -r locked file" '[[ -r /root ]]'

  assertTrue "[[ -w file" '[[ -w ./shunit2 ]]'
  assertFalse "[[ -w locked file" '[[ -w /root ]]'

  assertTrue "[[ -d dir" '[[ -d / ]]'
  assertFalse "[[ -d dir" '[[ -d ./shunit2 ]]'

  assertTrue "[[ =" '[[ 1 = 1 ]]'
  assertFalse "[[ =" '[[ 1 = 0 ]]'
  assertTrue "[[ ==" '[[ 1 == 1 ]]'
  assertFalse "[[ ==" '[[ 1 == 0 ]]'

  assertTrue "[[ !=" '[[ 1 != 0 ]]'
  assertFalse "[[ !=" '[[ 1 != 1 ]]'

  assertTrue "[[ == *" '[[ abcd == ab* ]]'
  assertFalse "[[ == *" '[[ abcd == ef* ]]'
  assertFalse "[[ == *" '[[ abcd == b* ]]'
  assertTrue "[[ == *" '[[ abcd == *b* ]]'
  assertFalse "[[ == *" '[[ abcd == *ef* ]]'
  assertTrue "[[ == *" '[[ abcd == * ]]'

  assertTrue "[[ == ?" '[[ abcd == abc? ]]'
  assertFalse "[[ == ?" '[[ abcd == ab? ]]'
  assertFalse "[[ == ?" '[[ abcd == ?b? ]]'
  assertTrue "[[ == ?" '[[ abcd == ???? ]]'
  assertFalse "[[ == ?" '[[ abcd == ? ]]'
  assertTrue "[[ == ?" '[[ abcd == ?* ]]'
  assertFalse "[[ == ?" '[[ "" == ? ]]'

  assertTrue "[[ -eq" '[[ 1 -eq 1 ]]'
  assertFalse "[[ -eq" '[[ 1 -eq 0 ]]'
  assertTrue "[[ -ne" '[[ 1 -ne 0 ]]'
  assertFalse "[[ -ne" '[[ 1 -ne 1 ]]'

  assertTrue "[[ &&" '[[ 1 -eq 1 && 0 -eq 0 ]]'
  assertFalse "[[ &&" '[[ 1 -eq 1 && 1 -eq 0 ]]'

  assertTrue "[[ ||" '[[ 1 -eq 1 || 1 -eq 1 ]]'
  assertTrue "[[ ||" '[[ 1 -eq 1 || 1 -eq 0 ]]'
  assertFalse "[[ ||" '[[ 0 -eq 1 || 1 -eq 0 ]]'

  assertTrue "[[ -gt" '[[ 1 -gt 0 ]]'
  assertFalse "[[ -gt" '[[ 1 -gt 1 ]]'
  assertFalse "[[ -gt" '[[ 1 -gt 2 ]]'

  assertTrue "[[ !" '[[ ! 1 == 0 ]]'
  assertFalse "[[ !" '[[ ! 1 == 1 ]]'
}

function test_echo {
  # Actually testing that echo -n doesn't print a newline is hard, since the
  # command substitution strips trailing newline chars. This test should be
  # enough, since if echo doesn't support the -n, it will print it literally
  assertEquals "echo -n was ignored as an option" "$(echo -n foo)" "$(echo foo)"
}

function test_printf {
  assertEquals "printf string" "test string" "$(printf 'test string')"
  assertEquals "printf string substitute" "test string" "$(printf %s 'test string')"
  assertEquals "printf literal escape" "\012" "$(printf %s '\012')"
  assertEquals "printf ignored extra arguments" "abc" "$(printf %s 'a' 'b' 'c')"
  assertEquals "printf ignored extra arguments" $'a\nb\nc' "$(printf '%s\n' 'a' 'b' 'c')"
}

function test_arithmetic_command {
  assertTrue "Command truthy" "(( 1 ))"
  assertFalse "Command falsey" "(( 0 ))"
  assertTrue "Command addition" "(( 1 + 1 ))"

  assertTrue "Command or" "(( 1 || 1 ))"
  assertTrue "Command or" "(( 1 || 0 ))"
  assertFalse "Command or" "(( 0 || 0 ))"
  assertTrue "Command and" "(( 1 && 1 ))"
  assertFalse "Command and" "(( 1 && 0 ))"
  assertTrue "Command nesting" "(( 1 || ( 1 && 1 ) ))"

  typeset a=2
  assertTrue "Command equals" "(( a == 2 ))"
  assertFalse "Command equals false" "(( a == 1 ))"
  assertTrue "Command not equals" "(( a != 1 ))"
  assertFalse "Command not equals false" "(( a != 2 ))"
  assertTrue "Command equals with addition" "(( a = 1 + 1 ))"

  assertTrue "Command less than" "(( a < 3 ))"
  assertFalse "Command less than" "(( a < 2 ))"
  assertFalse "Command less than" "(( a < 1 ))"
  assertTrue "Command less than equal" "(( a <= 3 ))"
  assertTrue "Command less than equal" "(( a <= 2 ))"
  assertFalse "Command less than equal" "(( a <= 1 ))"
  assertTrue "Command greater than" "(( a > 1 ))"
  assertFalse "Command greater than" "(( a > 2 ))"
  assertFalse "Command greater than" "(( a > 3 ))"
  assertTrue "Command greater than equal" "(( a >= 1 ))"
  assertTrue "Command greater than equal" "(( a >= 2 ))"
  assertFalse "Command greater than equal" "(( a >= 3 ))"

  typeset b=1
  assertTrue "Command true" "(( b ))"
  b=0
  assertFalse "Command false" "(( b ))"

  (( b = 1 ))
  assertTrue "Command assignment true" $?
  assertEquals "Command assignment result" 1 $b
  (( b = 0 ))
  assertFalse "Command assignment false" $?
  assertEquals "Command assignment result" 0 $b

  assertTrue "Command negation" "(( ! 0 ))"
  assertFalse "Command negation" "(( ! 1 ))"
}

function test_integer {
  typeset -i int=1
  assertTrue "Int equals" "(( int == 1 ))"
  assertFalse "Int equals" "(( int == 2 ))"
  assertTrue "Int true" "(( int ))"

  # This assignment returns 0, which evaluates as false
  (( int = 0 ))
  assertFalse "Int assignment" $?
  assertFalse "Int false" "(( int ))"

  int+=1
  assertEquals "Int increment" 1 $int

  int+=5
  assertEquals "Int increment" 6 $int
}

function test_array {
  # Since some shells do index 1 based instead of 0 based, we need to keep
  # assumptions out of the code. If we assign an array with the array=(...)
  # notation, then we can only itterate over it, never access an element.
  # If we assign by index (array[idx]=...), then we can access by element, but
  # must make sure we never use index 0, often by adding 1 to all indexes used

  typeset -a array_a
  array_a=(foo foo foo)

  for item in "${array_a[@]}"; do
    assertEquals "array element" "foo" "$item"
  done

  typeset IFS=' '
  assertEquals "whole array" "foo foo foo" "${array_a[*]}"
  assertEquals "size of array" 3 "${#array_a[@]}"

  typeset -a array_b
  array_b[1]=foo
  array_b[2]=bar
  array_b[5]=baz

  assertEquals "array index element" "foo" "${array_b[1]}"
  assertEquals "array index element" "bar" "${array_b[2]}"
  assertEquals "array index element" "baz" "${array_b[5]}"
  assertNull "null array index element" "${array_b[3]:+x}"
}

function test_source {
  file="${SHUNIT_TMPDIR}/sourced_file"
  printf '%s' 'foo=bar' > "$file"
  typeset foo

  source "$file"
  assertTrue "sourcing" $?
  assertEquals "sourced var" "bar" "$foo"

  rm "$file"
}

function test_command {
  assertTrue "sh command doesn't exist" 'command -v sh >/dev/null'
  assertFalse "no-command-foo-bar command exists, who would have thought" 'command -v no-command-foo-bar >/dev/null'
}

function test_dynamic_function_call {
  typeset foo=bar baz=qux

  function my_bar {
    :
  }
  function my_qux {
    false
  }

  assertTrue "called my_bar" 'my_$foo'
  assertFalse "called my_qux" 'my_$baz'

  unset -f my_bar my_qux
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ./shunit2

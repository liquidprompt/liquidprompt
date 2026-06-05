
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
  _LP_FIRST_INDEX=1
else
  _LP_FIRST_INDEX=0
fi

# Zsh is very dumb about arrays. When accessing by subscript, it is 1 indexed.
# When accessing by slice, it is 0 indexed.

function test_array_element {
  typeset check
  typeset -a array_a
  array_a=(foo foo foo)

  for item in "${array_a[@]}"; do
    assertEquals "array element" "foo" "$item"
  done

  array_a=(foo bar baz)

  # shunit2 needs IFS to contain a space.
  IFS="/ "
  check="${array_a[*]}"
  assertEquals "whole array" "foo/bar/baz" "$check"
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

function test_array_slice {
  typeset check
  typeset -a array_a
  array_a=(foo bar baz)
  assertEquals "array slice" "foo" "${array_a[@]:0:1}"

  typeset -a array_c
  array_c=( "${array_a[@]:0:2}" )
  check="${array_c[*]}"
  assertEquals "array slice" "foo/bar" "$check"
  array_c=( "${array_a[@]:1:3}" )
  check="${array_c[*]}"
  assertEquals "array slice" "bar/baz" "$check"
  array_c=( "${array_a[@]:1}" )
  check="${array_c[*]}"
  assertEquals "array slice" "bar/baz" "$check"
  array_c=( "${array_a[@]: -1}" )
  check="${array_c[*]}"
  assertEquals "array slice" "baz" "$check"
  array_c=( "${array_a[@]: -2}" )
  check="${array_c[*]}"
  assertEquals "array slice" "bar/baz" "$check"

  array_c=( "${array_a[@]: $((-2 + 1))}" )
  check="${array_c[*]}"
  assertEquals "array slice dynamic index" "baz" "$check"

  typeset -a array_d
  array_c=( ${array_d[@]+"${array_d[@]:1}"} )
  assertEquals "slice empty array" 0 "${#array_c[@]}"

  typeset -a array_e
  array_e=( "" foobar quz )
  assertNull "access empty string" "${array_e[_LP_FIRST_INDEX]-x}"
  assertNull "slice empty string" "${array_e[@]:0:1}"
  check="${array_e[*]}"
  assertEquals "concat empty string" "/foobar/quz" "$check"
  array_c=( ${array_e[@]+"${array_e[@]:0:2}"} )
  check="${array_c[*]}"
  assertEquals "concat empty string alt" "/foobar" "$check"
  # This does not work:
  #assertEquals "concat empty string one step" "/foobar" "${array_e[*]:0:2}"

  typeset -a array_f
  typeset string="/foobar/quz"
  array_f=( ${string} )
  assertNull "access empty string" "${array_f[_LP_FIRST_INDEX]-x}"
  assertNull "slice empty string" "${array_f[@]:0:1}"
  check="${array_f[*]}"
  assertEquals "concat empty string" "/foobar/quz" "$check"
  array_c=( ${array_f[@]+"${array_f[@]:0:2}"} )
  check="${array_c[*]}"
  assertEquals "concat empty string alt" "/foobar" "$check"

  IFS=1
  i=1
  check="${array_f[@]:1:$i+0}"
  IFS=" "
  assertEquals "dynamic unquoted slice" "foobar" "$check"
}

function test_array_test_set {
  typeset -a array_a
  assertFalse "array element 1 not set" '[[ -n ${array_a[@]+"${array_a[1]+x}"} ]]'
  array_a[1]=1
  assertTrue "array element 1 set" '[[ -n ${array_a[@]+"${array_a[1]+x}"} ]]'
  assertFalse "array element 2 not set" '[[ -n ${array_a[@]+"${array_a[2]+x}"} ]]'
  array_a[3]=1
  assertTrue "array element 3 set" '[[ -n ${array_a[@]+"${array_a[3]+x}"} ]]'
  # This is true in Zsh, as described by the manual.
  #assertFalse "array element 2 not set" '[[ -n ${array_a[@]+"${array_a[2]+x}"} ]]'
}

. ./shunit2


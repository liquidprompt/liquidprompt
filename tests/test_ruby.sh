
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

# Liquid Prompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

LP_ENABLE_RUBY_VENV=1
LP_RUBY_RVM_PROMPT_OPTIONS=("i" "v" "g" "s")

typeset -a rbenv_outputs rbenv_return_strings rvm_outputs rvm_return_strings

# Add test cases to these arrays like below

# Example from rbenv documentation
rbenv_outputs+=(
"1.9.3-p327"
)
rbenv_return_strings+=(
"1.9.3-p327"
)

# Example from rvm documentation
rvm_outputs+=(
"ruby-3.2.2"
)
rvm_return_strings+=(
"ruby-3.2.2"
)


function test_rbenv {

  rbenv() {
    printf '%s\n' "$__rbenv_output"
  }

  _LP_RUBY_VENV_PROGRAM=rbenv

  for (( index=0; index < ${#rbenv_outputs[@]}; index++ )); do
    __rbenv_output=${rbenv_outputs[$index]}

    _lp_ruby_env
    assertEquals "rbenv returns at index ${index}" "${rbenv_return_strings[$index]}" "$lp_ruby_env"
  done
}

function test_rbenv_default {

  rbenv() {
    printf 'system\n'
  }

  _LP_RUBY_VENV_PROGRAM=rbenv

  unset lp_ruby_env
  _lp_ruby_env
  assertTrue "rbenv system returned not 1" '[[ "$?" == 1 ]]'
  assertNull "rbenv system returned string" "${lp_ruby_env+x}"
}

function test_rvm {

  rvm-prompt() {
    printf '%s\n' "$__rvm_output"
  }

  _LP_RUBY_VENV_PROGRAM=rvm

  for (( index=0; index < ${#rvm_outputs[@]}; index++ )); do
    __rvm_output=${rvm_outputs[$index]}

    _lp_ruby_env
    assertEquals "rvm-prompt returns at index ${index}" "${rvm_return_strings[$index]}" "$lp_ruby_env"
  done
}


function test_rmv_default {

  rvm-prompt() {
    printf '%s\n' "$__rvm_output"
  }

  _LP_RUBY_VENV_PROGRAM=rvm

  for __rvm_output in "system" ""; do
    echo "$__rvm_output"
    unset lp_ruby_env
    _lp_ruby_env
    [[ "$?" == 1 ]] || fail "rbenv system returned not 1"
    assertNull "rbenv system returned string" "${lp_ruby_env+x}"
  done
}

. ./shunit2

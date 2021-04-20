
# Error on unset variables
set -u

. ../liquidprompt --no-activate

# Liquidprompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

LP_ENABLE_RUBY_VENV=1

typeset -a rbenv_outputs rbenv_return_strings

# Add test cases to these arrays like below

# Example from rbenv documentation
rbenv_outputs+=(
"1.9.3-p327 (set by /Users/user/.rbenv/version)"
)
rbenv_return_strings+=(
"1.9.3-p327"
)


function test_rbenv {

  rbenv() {
    printf '%s\n' "$__rbenv_output"
  }

  lp_activate

  for (( index=0; index < ${#rbenv_outputs[@]}; index++ )); do
    __rbenv_output=${rbenv_outputs[$index]}

    _lp_ruby_env
    assertEquals "rbenv returns at index ${index}" "${rbenv_return_strings[$index]}" "$lp_ruby_env"
  done
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ./shunit2

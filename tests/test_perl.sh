
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit ksh_arrays
fi

. ../liquidprompt --no-activate

# Liquid Prompt depends on PS1 being set to detect if it has installed itself.
PS1="$ "

LP_ENABLE_PERL_VENV=1

typeset -a perlbrew_outputs perlbrew_return_strings

# Add test cases to these arrays like below

# Example from perlbrew execution
perlbrew_outputs+=(
"Currently using perl-5.38.0"
)
perlbrew_return_strings+=(
"5.38.0"
)

# Example from plenv execution
plenv_outputs+=(
"5.10.1 (set by /Users/user/.plenv/version)"
)
plenv_return_strings+=(
"5.10.1"
)


function test_perlbrew {

  perlbrew() {
    printf '%s\n' "$__perlbrew_output"
  }

  _LP_PERL_VENV_PROGRAM=perlbrew

  for (( index=0; index < ${#perlbrew_outputs[@]}; index++ )); do
    __perlbrew_output=${perlbrew_outputs[$index]}

    _lp_perl_env
    assertEquals "perlbrew returns at index ${index}" "${perlbrew_return_strings[$index]}" "$lp_perl_env"
  done
}

function test_plenv {

  plenv() {
    printf '%s\n' "$__plenv_output"
  }

  _LP_PERL_VENV_PROGRAM=plenv

  for (( index=0; index < ${#plenv_outputs[@]}; index++ )); do
    __plenv_output=${plenv_outputs[$index]}

    _lp_perl_env
    assertEquals "plenv returns at index ${index}" "${plenv_return_strings[$index]}" "$lp_perl_env"
  done
}


. ./shunit2

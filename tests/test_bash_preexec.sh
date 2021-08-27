#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2031,SC2030
set -u

# Note: we do not call __lp_set_prompt directly in this file, as we do
# elsewhere; the idea is to check that it is properly integrated with
# bash-preexec.sh.

if [[ -z ${BASH_VERSION-} ]]; then
  echo "$0 is irrelevant for non-bash shells."
  exit 0
fi

# Install bash-preexec.sh
if [[ ! -f bash-preexec.sh ]]; then
  echo "Installing bash-preexec.sh in $(pwd)..."
  bash_preexec_version=0.4.1
  curl -O https://raw.githubusercontent.com/rcaloras/bash-preexec/$bash_preexec_version/bash-preexec.sh
  echo "Installed bash-preexec.sh in $(pwd)..."
fi

function setup_bash_preexec() {
  set +u
  source ./bash-preexec.sh

  # bash-preexec doesn't install itself when sourced, it puts its install
  # command into PROMPT_COMMAND. Call it here to finish setup.
  __bp_install
  set -u
}

function setup_liquidprompt() {
  HOME=/home/user
  PWD=$HOME
  PS1="$ "
  . ../liquidprompt --no-activate

  # lp_theme activates liquid prompt a second time, which serves to double-check
  # that we only add __lp_set_prompt to bash-preexec's precmd_functions _once_
  LP_RUNTIME_ENABLED=1
  LP_RUNTIME_THRESHOLD=1
  LP_ENABLE_ERROR=1
  LP_ENABLE_TITLE=1
  lp_activate --no-config
  lp_theme default
}

function setup() {
    setup_bash_preexec
    setup_liquidprompt
}

### Begin actual test functions. (Above this line are setup helpers.)

function test_bash_preexec_with_LP_RUNTIME {
  (
    setup

    sleep 1
    $PROMPT_COMMAND

    assertTrue '[[ -n ${_LP_RUNTIME_SECONDS-} ]] && (( _LP_RUNTIME_SECONDS > 0 ))'
  )
}

# Check it works with bash_preexec off
function test_no_bash_preexec_with_LP_RUNTIME {
  (
    setup_liquidprompt

    sleep 1
    $PROMPT_COMMAND

    assertTrue '[[ -n ${_LP_RUNTIME_SECONDS-} ]] && (( _LP_RUNTIME_SECONDS > 0 ))'
  )
}

function test_bash_preexec_with_LP_ERR {
  (
    setup

    false # should get "1" in prompt
    $PROMPT_COMMAND
    assertContains $lp_error_color 1
  )
}

# Check it works with bash_preexec off
function test_no_bash_preexec_with_LP_ERR {
  (
    setup_liquidprompt

    false # should get "1" in prompt
    $PROMPT_COMMAND
    assertContains $lp_error_color 1
  )
}

function test_bash_preexec_with_LP_ENABLE_TITLE {
  (
    setup

    $PROMPT_COMMAND
    assertNotNull "${_lp_generated_title-}"
  )
}

# Check it works with bash_preexec off
function test_no_bash_preexec_with_LP_ENABLE_TITLE {
  (
    setup_liquidprompt

    $PROMPT_COMMAND
    assertNotNull "${_lp_generated_title-}"
  )
}

function test_bash_preexec_with_prompt_off {
  (
    setup_bash_preexec

    precmd_functions_size_before_liquidprompt="${#precmd_functions[@]}"
    preexec_functions_size_before_liquidprompt="${#preexec_functions[@]}"

    setup_liquidprompt
    # We expect liquidprompt to add new entries to precmd_functions and
    # preexec_functions, so the arrays should no longer be equal.
    assertNotEquals "${#precmd_functions[@]}" "$precmd_functions_size_before_liquidprompt"
    assertNotEquals "${#preexec_functions[@]}" "$preexec_functions_size_before_liquidprompt"

    # This just checks that we did in fact get liquidprompt turned on.
    false # should get "1" in prompt
    $PROMPT_COMMAND
    assertNotEquals "$PS1" "$ "

    # Check that calling prompt_on twice doesn't insert duplicate copies of the
    # hooks
    precmd_functions_size_after_liquidprompt=${#precmd_functions[@]}
    preexec_functions_size_after_liquidprompt=${#preexec_functions[@]}
    prompt_on
    assertEquals "${#precmd_functions[@]}" "$precmd_functions_size_after_liquidprompt"
    assertEquals "${#preexec_functions[@]}" "$preexec_functions_size_after_liquidprompt"


    # Here's the function we're actually here to test.
    prompt_off

    # With prompt off, it should just be back to plain old "$ "
    false
    $PROMPT_COMMAND
    assertEquals "$PS1" "$ "

    # And, having run prompt_off, precmd_functions and preexec_functions should
    # be back to their original values.
    assertEquals \
      "$precmd_functions_size_before_liquidprompt" \
      "${#precmd_functions[@]}"
    assertEquals \
      "$precmd_functions_size_before_liquidprompt" \
      "${#preexec_functions[@]}"
  )
}

. ./shunit2

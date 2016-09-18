source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"

eval_prompt
assert_ps1_plain_is "0.64 ${DETACHED_SESSION_COUNT}d [${_LP_USER_SYMBOL}:/tmp/liquidprompt-tests] 2s $_LP_MARK_SYMBOL "

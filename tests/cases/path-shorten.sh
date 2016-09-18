LP_PATH_LENGTH=5
source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"

mkdir -p this/is/a/very/very/very/long/path
cd       this/is/a/very/very/very/long/path

eval_prompt

assert_ps1_plain_is "0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:/tmp … path] 2s $_LP_MARK_SYMBOL "

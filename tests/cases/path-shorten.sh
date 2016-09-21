mkdir -p this/is/a/very/very/very/long/path
cd       this/is/a/very/very/very/long/path

assert_path () {
    assert_ps1_plain_is "0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:$1] 2s $_LP_MARK_SYMBOL "
}

echo "$PWD"

for t in \
    {0..8}:'/tmp … path' \
    9:'/tmp … /path' \
    10:'/tmp … g/path'
do
    IFS=: read -r ns p <<< "$t"
    for n in $ns; do
        LP_PATH_LENGTH="$n"
        source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"
        eval_prompt "LP_PATH_LENGTH=$n -> $p"
        assert_path "$p"
    done
done

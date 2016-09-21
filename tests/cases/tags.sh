assert_tag () {
    assert_ps1_plain_is "$1 0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:/tmp/liquidprompt-tests] 2s $_LP_MARK_SYMBOL "
}

source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"

for tag in MYTAG -1 0 1 '$foo' '"' "'" '{' '}' '[qux]' ; do
    prompt_tag "$tag"
    eval_prompt "tag: $tag"
    assert_tag "$tag"
done

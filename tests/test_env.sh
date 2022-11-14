
# Error on unset variables
set -u

. ../liquidprompt --no-activate


function test_proxy {
    LP_ENABLE_PROXY=1

    http_proxy=""
    _lp_http_proxy
    assertEquals "$?" "1"

    https_proxy="I see"
    _lp_http_proxy
    assertContains "$lp_http_proxy" "I see"

    https_proxy=""
    all_proxy="dead pixels"
    _lp_http_proxy
    assertContains "$lp_http_proxy" "dead pixels"
}

function test_env_vars {

    # For having NO_COL in _lp_env_vars
    PS1=
    lp_activate

    LP_ENABLE_ENV_VARS=1

    LP_ENV_VARS=(
        "EDITOR e:%s"
        "VERBOSE V"
        "DESKTOP_SESSION %s nodesk"
        "USERDEFINED D U"
        "UNSET 0"
        "UNSET2 0 2"
    )

    EDITOR="kak"
    VERBOSE=0
    DESKTOP_SESSION="notion"
    USERDEFINED=""
    unset UNSET
    unset UNSET2

    LP_MARK_ENV_VARS_SEP=","

    _lp_env_vars
    _lp_join "${LP_MARK_ENV_VARS_SEP}" "${lp_env_vars[@]}"
    assertEquals "e:kak,V,notion,D,2" "$lp_join"

    LP_ENV_VARS=()
    _lp_env_vars
    assertEquals "$?" "1"

    LP_ENV_VARS=("NOPE")
    _lp_env_vars
    assertEquals "$?" "1"
}

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ./shunit2

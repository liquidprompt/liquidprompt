
# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ../liquidprompt --no-activate

function test_git {

    LP_ENABLE_GIT=1
    LP_ENABLE_FOSSIL=0
    LP_ENABLE_SVN=0
    LP_ENABLE_BZR=0
    LP_ENABLE_VCS_ROOT=0
    LP_ENABLE_VCS_REMOTE=1

    wd="${SHUNIT_TMPDIR}/test_remote/"
    mkdir -p "$wd"
    cd "$wd"

    _lp_are_vcs_enabled
    assertTrue "VCS are enabled here." "$?"

    git init

    _lp_find_vcs
    assertTrue "We detect a VCS updir." "$?"
    assertEquals "We found a Git repo." "git" "$lp_vcs_type"
    assertEquals "We see the repo." "$wd" "$lp_vcs_root"

    _lp_vcs_active
    assertTrue "Git detects the repository." "$?"

    _lp_vcs_branch
    assertEquals "Default branch is master." "master" "$lp_vcs_branch"

    git branch -m notsomain

    _lp_vcs_branch
    assertEquals "Branch change is detected." "notsomain" "$lp_vcs_branch"

    git remote add notsoremote git@nojhan.github:nojhan/liquidprompt.git

    _lp_git_remote
    assetEquals "Remote is found." "notsoremote." "$lp_vcs_remote"
}

. ./shunit2


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

    PS1=""
    lp_activate

    wd="${SHUNIT_TMPDIR}/test_remote/"
    mkdir -p "$wd"
    cd "$wd"

    _lp_are_vcs_enabled
    assertTrue "VCS are enabled here." "$?"

    git init
    git config --local user.email "author@example.com"
    git config --local user.name "A U Thor"
    # We need a commit to have a branch that can have a remote.
    touch test
    git add test
    git commit -m "test" --no-verify --no-gpg-sign
    # Ensure we use "main" and not "master".
    git branch -m main

    _lp_find_vcs
    assertTrue "We detect a VCS updir." "$?"
    assertEquals "We found a Git repo." "git" "$lp_vcs_type"
    assertEquals "We see the repo." "$wd" "$lp_vcs_root/"

    _lp_vcs_active
    assertTrue "Git detects the repository." "$?"

    git checkout -b notsomain

    _lp_vcs_branch
    assertEquals "Branch change is detected." "notsomain" "$lp_vcs_branch"

    # Use a local remote or else one could have problems.
    git branch -u main

    _lp_git_remote
    assertEquals "Remote is found." "." "$lp_vcs_remote"


    mkdir remote/
    cp -r .git remote/

    git remote add foo ./remote/
    git fetch foo
    git checkout -b other

    _lp_vcs_branch
    assertEquals "Branch change is detected." "other" "$lp_vcs_branch"

    git branch -u foo/main

    _lp_git_remote
    assertEquals "Remote foo is found." "foo" "$lp_vcs_remote"
}

. ./shunit2

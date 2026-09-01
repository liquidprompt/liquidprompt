
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
    LP_ENABLE_VCS_ROOT=1
    LP_ENABLE_VCS_REMOTE=1
    _LP_GITSTATUS_DATA=0

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

function test_git_symlinks {
    LP_ENABLE_GIT=1
    LP_ENABLE_FOSSIL=0
    LP_ENABLE_SVN=0
    LP_ENABLE_BZR=0
    LP_ENABLE_VCS_ROOT=1
    LP_ENABLE_VCS_REMOTE=0
    _LP_GITSTATUS_DATA=0

    lp_activate

    repo_dir="${SHUNIT_TMPDIR}/symlink_repo"
    mkdir -p "${repo_dir}/subdir"
    cd "$repo_dir"

    git init -q
    git config --local user.email "author@example.com"
    git config --local user.name "A U Thor"
    touch test.txt
    git add test.txt
    git commit -q -m "initial commit" --no-verify --no-gpg-sign
    git branch -m main

    outside_dir="${SHUNIT_TMPDIR}/outside"
    mkdir -p "$outside_dir"
    ln -s "${repo_dir}" "${outside_dir}/link_to_repo"
    ln -s "${repo_dir}/subdir" "${outside_dir}/link_to_sub"

    # Test 1: Symlink pointing directly to repo root works even without LP_ENABLE_VCS_RESOLVE_SYMLINKS
    cd "${outside_dir}/link_to_repo"
    LP_ENABLE_VCS_RESOLVE_SYMLINKS=0
    _lp_find_vcs
    assertTrue "Direct symlink to repo root detects VCS." "$?"
    assertEquals "git" "$lp_vcs_type"

    # Test 2: Symlink to subdirectory fails when LP_ENABLE_VCS_RESOLVE_SYMLINKS=0
    cd "${outside_dir}/link_to_sub"
    LP_ENABLE_VCS_RESOLVE_SYMLINKS=0
    _lp_find_vcs
    assertFalse "Symlinked subdir should not detect VCS when resolution is disabled." "$?"

    # Test 3: Symlink to subdirectory succeeds when LP_ENABLE_VCS_RESOLVE_SYMLINKS=1
    cd "${outside_dir}/link_to_sub"
    LP_ENABLE_VCS_RESOLVE_SYMLINKS=1
    _lp_find_vcs
    assertTrue "Symlinked subdir detects VCS when LP_ENABLE_VCS_RESOLVE_SYMLINKS=1." "$?"
    assertEquals "git" "$lp_vcs_type"
    _lp_vcs_branch
    assertEquals "Branch detected in symlinked subdir." "main" "$lp_vcs_branch"

    # Test 4: Symlinked subdirectory respects LP_DISABLED_VCS_PATHS on physical path
    cd "${outside_dir}/link_to_sub"
    LP_ENABLE_VCS_RESOLVE_SYMLINKS=1
    LP_DISABLED_VCS_PATHS=("${repo_dir}")
    _lp_find_vcs
    assertEquals "Returns code 2 when physical target is disabled." "2" "$?"
    assertEquals "VCS type is set to disabled for physical target." "disabled" "$lp_vcs_type"

    # Test 5: Symlinked subdirectory respects LP_DISABLED_VCS_PATHS on logical path
    cd "${outside_dir}/link_to_sub"
    LP_ENABLE_VCS_RESOLVE_SYMLINKS=1
    LP_DISABLED_VCS_PATHS=("${outside_dir}")
    _lp_find_vcs
    assertEquals "Returns code 2 when logical symlink path is disabled." "2" "$?"
    assertEquals "VCS type is set to disabled for logical path." "disabled" "$lp_vcs_type"
    LP_DISABLED_VCS_PATHS=()
}

. ./shunit2

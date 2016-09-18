source "$SCRIPT_DIR/tests/support/mocked-liquidprompt.sh"

# create a repo
{
    mkdir remoterepo
    git -C remoterepo init --bare
    git clone "file://$PWD/remoterepo" repo
    cd repo || exit 1
    git config user.name  'Foo Bar'
    git config user.email 'foo@bar.com'
    git checkout -b funky/branch >&2
} > /dev/null

assert_ends_with ()
{
    assert_ps1_plain_is "0.64 ${DETACHED_SESSION_COUNT}d [$_LP_USER_SYMBOL:/tmp/liquidprompt-tests/repo] $1"
}


# initial repo
eval_prompt 'initial repo'
assert_ends_with 'funky/branch 2s ± '

# make some changes
touch some-file > /dev/null
eval_prompt 'some changes'
assert_ends_with 'funky/branch* 2s ± '

# stage some changes
git add some-file > /dev/null
eval_prompt 'staged changes'
assert_ends_with 'funky/branch 2s ± '

# commit the file
git commit -m 'Initial commit' > /dev/null
eval_prompt 'initial commit'
assert_ends_with 'funky/branch 2s ± '

# make some changes to tracked files
echo $'foo\nbar' >> some-file
eval_prompt 'change tracked file'
assert_ends_with 'funky/branch(+2/-0) 2s ± '

# stage the changes
git add some-file > /dev/null
eval_prompt 'stage changes to tracked file'
assert_ends_with 'funky/branch(+0/-0) 2s ± '

# commit the file
git commit -m 'Second commit' > /dev/null
eval_prompt 'second commit'
assert_ends_with 'funky/branch 2s ± '

# push to origin/master
git push -u origin funky/branch &> /dev/null
sha="$(git --no-pager show -s --format='%H' HEAD)"
eval_prompt 'push to origin/master'
assert_ends_with 'funky/branch 2s ± '

# reset to be behind origin/master
git reset --hard HEAD~ > /dev/null
eval_prompt 'reset to be behind origin/master'
assert_ends_with 'funky/branch(-1) 2s ± '

# set origin/master to be behind us
{
    git push -f
    git reset --hard "$sha"
} &> /dev/null
eval_prompt 'reset origin/mater to be behind us'
assert_ends_with 'funky/branch(1) 2s ± '

# make some changes to tracked files
echo $'foo\nbar' >> some-file
eval_prompt 'make changes to tracked file again'
assert_ends_with 'funky/branch(+2/-0,1) 2s ± '

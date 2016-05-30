Contributing to Liquid Prompt
=============================

Contributing a patch
--------------------

The public stable branch for end users is `master`.


How to do the right thing?
--------------------------

    $ git clone -o upstream git://github.com/nojhan/liquidprompt.git
    $ cd liquidprompt

    # Run liquidprompt and check that your issue is still on that branch
    $ source liquidprompt

    # Prepare a fix (include the issue number in the branch name if an issue
    # already exists)
    $ git checkout -b fix/my-fix
    # Prepare a new feature
    $ git checkout -b feature/my-feature

    # Hack, commit, hack, commit...

    # Fork the project on GitHub (if you haven't yet)

    # Add the remote target for pushes
    $ git remote add github git@github.com:$GITHUB_USER/liquidprompt.git

    # Check that your local repo is up to date
    $ git fetch
    # Rebase your work on the latest state of `master`
    $ git rebase upstream/master

    # Push your commits
    $ git push github fix/my-fix
    $ git push github feature/my-feature

    # Create the pull request on GitHub. Check that Github chose the `master`
    # branch as the starting point for your branch.


How to make a good pull request?
--------------------------------

1. Check that your Git authorship settings are correct:

        $ git config -l | grep ^user\.

2. All the commits in the pull request must be on the same topic. If instead
   you propose fixes on different topics, use separate branches in your repo
   and make a pull request for each.
3. Good commit messages:
     - first line must be 72 chars max and is a summary of the commit
     - second line must be empty
     - following lines (72 chars max) are optional and take this space freely
       to express what that changes does.
       Use references to GitHub issues number (ex: `#432`) if applicable
4. Use a good title for your pull request.
5. Put details, web links, in the pull request body. Use Markdown fully to
   format the content (see
   [Markdown syntax](http://daringfireball.net/projects/markdown/syntax)).
   For example use triple backquotes for code blocks.


Never, ever, merge the branches `master` of the main repo into one
of your own branches. Instead, always rebase your own work on top the `master`
branch.

How my patch will be applied?
-----------------------------

Before being applied, your pull request will be reviewed, by the maintainer
and also by other users. You can also help the project by reviewing others
pull requests.

If your patch is accepted it will be applied either:
- by "merging" your branch
- by cherry-picking your commit on top of the `master` branch. This makes the
  history linear, and so easier to track.

In any case, your authorship will be preserved in the commit.

What if my patch is not applied?
--------------------------------

If you don't even get a review, add a "ping" comment with increasing delay
between pings: 1 week, 2 weeks, then every month.

If a stable version is released while your pull request has still not been
merged on any working branch of the main repo, it would be helpful to ease
the maitainer's work by rebasing your branch on top of the latest `master`
and push it again to your GitHub repo. Be careful (for example create a
branch or a tag before your rebase) because your may lose all your work in
that process.


Olivier Mengué, maintainer.
http://github.com/dolmen

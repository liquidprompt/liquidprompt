Contributing to Liquid Prompt
=============================

Contributing a patch
--------------------

The public stable branch for end users is `master`.

The main branch for development is `develop`. This is on top of this branch
that you must write your patches.

Any pull request built on top of `master` instead of `develop`
is additionnal merge work for maintainers, and you want to avoid this if you
aim for quick integration of your work.

If you wrote your patch on the wrong branch the maintainers may choose to close
the pull request and ask you to rewrite it on top of the current 'develop'.


How to do the right thing?
--------------------------

    $ git clone -b develop -o upstream git://github.com/nojhan/liquidprompt.git
    $ cd liquidprompt

    # Run liquidprompt and check that your issue is still on that branch
    $ source liquidprompt

    # Prepare a fix (include the issue number in the branch name if an issue
    # already exists)
    $ git checkout -b fix/my-fix
    # Prepare a new feature
    $ git checkout -b feature/my-feature

    # Hack, commit, hack, commit...

    # Fork the project on Github (if you haven t yet)

    # Add the remote target for pushes
    $ git remote add github git@github.com:$GITHUB_USER/liquidprompt.git

    # Check that your local repo is up to date
    $ git fetch
    # Rebase your work on the lastest state of `develop`
    $ git rebase upstream/develop

    # Push
    $ git push github fix/my-fix
    $ git push github fix/my-feature

    # Create the pull request on Github. Check that Github choose the `develop`
    # branch as the starting point for your branch.


How to make a good pull request?
--------------------------------

1. Check that your git settings for authorship are right:
     $ git config -l | grep ^user\.
2. All the commits in the pull request must be on the same topic. If instead
   you propose fixes on different topics, use separate branches in your repo
   and make a pull request for each.
3. Good commit messages:
     - first line must be 72 chars max and is a summary of the commit
     - second line must be empty
     - following lines (72 chars max) are optional and take this space freely
       to express what that changes does.
       Use references to Github issues number (ex: #432) if applicable
4. Use a good title for your pull request
5. Put details, web links, in the pull request body. Use Markdown fully to
   format the content (see Github help on formatting). For example use triple
   backquote for code blocks.

How my patch will be applied?
-----------------------------

Before being applied, your pull request will be reviewed, by the maintainer
and also by other users. You can also help the project by reviewing others
pull requests.

If your patch is accepted it will be applied either:
- by "merging" your branch
- by cherry-picking your commit on top of the `develop` branch. This makes the
  history linear, and so easier to track.

In any case, your authorship will be preserved in the commit.


Olivier Mengué.
http://github.com/dolmen

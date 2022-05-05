Version Control Data Functions
******************************

.. contents::
   :local:

These functions are designed to be used by themes.

Generic
-------

The generic interface functions are designed to provide a level of abstraction
over the type of VCS that a user might be using. By using the generic interface,
a theme can provide a common look for all VCS types.
See the default theme function :func:`_lp_vcs_details_color` for an example of
this.

.. function:: _lp_find_vcs() -> var:lp_vcs_type, var:lp_vcs_root, \
   var:lp_vcs_dir, var:lp_vcs_subtype

   Returns ``true`` if the current directory is part of a version control
   repository. If not, returns ``1``. Returns the VCS type ID, subtype if one
   exists, the VCS data directory, and the repository root directory.

   If the current directory is disabled for version control using
   :attr:`LP_DISABLED_VCS_PATHS` (checked using :func:`_lp_are_vcs_enabled`),
   returns ``2``, and the returned type is set to "disabled".

   :func:`_lp_find_vcs` will only search for VCS types that are not disabled. If
   all VCS types are disabled in the config, :func:`_lp_find_vcs` will return
   ``1``, as no repository will be found.

   This function does a lightweight check for the existence of a version control
   repository, only looking for the existence of a database. It does not check
   if the database is valid or healthy. Use :func:`_lp_vcs_active` to test for
   that.

   .. note::

      *lp_vcs_dir* will not be set for Fossil repositories. Protect it with
      ``"${lp_vcs_dir-}"``.

   .. note::

      *lp_vcs_subtype* will not be set usually. The only currently supported
      subtypes are "vcsh" and "svn", which are subtypes of "git".

   .. versionadded:: 2.0

   .. versionchanged:: 2.1
      Added the *lp_vcs_dir* and *lp_vcs_subtype* return values.
      Added support for checking the :envvar:`GIT_DIR` environment variable.

.. function:: _lp_are_vcs_enabled()

   Returns ``true`` if the current directory is not excluded by the config
   option :attr:`LP_DISABLED_VCS_PATHS`.

.. note::

   All following generic functions need :func:`_lp_find_vcs` to be run first, as
   they need ``lp_vcs_type`` to be set.

.. function:: _lp_vcs_active()

   Returns ``true`` if the detected VCS is enabled in Liquidprompt and the
   current directory is a valid repository of that type. This check should be
   done before running any other ``_lp_vcs_*`` data functions, but can be
   omitted for speed reasons if the checks done by :func:`_lp_find_vcs` are good
   enough.

   .. versionadded:: 2.0

.. note::

   Unless otherwise documented, the following functions return ``0`` for good
   data, ``1`` for no data, and ``2`` for unsupported function.

.. function:: _lp_vcs_bookmark() -> var:lp_vcs_bookmark

   Returns ``true`` if a bookmark is active in the repository. Returns the
   bookmark name.

   Most VCS providers do not support bookmarks.

   .. versionadded:: 2.0

.. function:: _lp_vcs_branch() -> var:lp_vcs_branch

   Returns ``true`` if a branch is active in the repository. Returns the branch
   name.

   For some VCS providers, a branch is always active.

   .. versionadded:: 2.0

.. function:: _lp_vcs_commit_id() -> var:lp_vcs_commit_id

   Returns the full commit ID of the current commit. The return code is not
   defined.

   Some VCS providers use hashes, while others use incrementing revision
   numbers. All VCS providers support some form of ID. The returned string
   should be unique enough that a user can identify the commit.

   .. versionadded:: 2.0

.. function:: _lp_vcs_commits_off_remote() -> var:lp_vcs_commit_ahead, var:lp_vcs_commit_behind

   Returns ``true`` if there are commits on the current branch that are not on
   the remote tracking branch, or commits on the remote tracking branch that are
   not on this branch. Returns ``1`` if there are no differing commits. Returns
   ``2`` if there is no matching remote tracking branch. Returns ``3`` or higher
   if the VCS provider does not support remote tracking branches.

   Returns the number of commits behind and ahead.

   Most VCS providers do not support remote tracking branches.

   .. versionadded:: 2.0

.. function:: _lp_vcs_head_status() -> var:lp_vcs_head_status, var:lp_vcs_head_details

   Return ``true`` if the repo is in a special or unusual state. Return the
   special status, and any extra details (like progress in a rebase) if
   applicable.

   Many VCS providers do not have such information. This info is unlikely to be
   similar across VCSs, and should probably be displayed to a user without
   manipulation.

   .. note::

      The details are optional, and might not be set. Protect it with
      ``"${lp_vcs_head_details-}"``.

   .. versionadded:: 2.0

.. function:: _lp_vcs_staged_files() -> var:lp_vcs_staged_files

   Returns ``true`` if any staged files exist in the repository. In other words,
   tracked files that contain staged changes. Returns the number of staged
   files.

   Many VCS providers do not support staging.

   .. versionadded:: 2.0

.. function:: _lp_vcs_staged_lines() -> var:lp_vcs_staged_i_lines, var:lp_vcs_staged_d_lines

   Returns ``true`` if any staged lines exist in the repository. In other words,
   tracked files that contain staged changes. Returns the number of staged
   lines.

   Many VCS providers do not support staging.

   .. versionadded:: 2.0

.. function:: _lp_vcs_stash_count() -> var:lp_vcs_stash_count

   Returns ``true`` if there are stashes the repository. Returns the
   number of stashes.

   Some VCS providers refer to stashes as "shelves".

   Some VCS providers do not support stashes.

   .. versionadded:: 2.0

.. function:: _lp_vcs_tag() -> var:lp_vcs_tag

   Returns ``true`` if a tag is active in the repository. Returns the
   tag name.

   A tag will only be returned if it is a unique ID that points only to the
   current commit.

   If multiple tags match, only one is returned. Which tag is selected is not
   defined.

   Some VCS providers do not support unique tags.

   .. versionadded:: 2.0

.. function:: _lp_vcs_uncommitted_files() -> var:lp_vcs_uncommitted_files

   Returns ``true`` if any uncommitted files exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted files.

   Some VCS providers refer to uncommitted files as "modified" files.

   .. versionadded:: 2.0

.. function:: _lp_vcs_uncommitted_lines() -> var:lp_vcs_uncommitted_i_lines, var:lp_vcs_uncommitted_d_lines

   Returns ``true`` if any uncommitted lines exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted lines.

   Some VCS providers refer to uncommitted lines as "modified" or "changed"
   lines.

   .. versionadded:: 2.0

.. function:: _lp_vcs_unstaged_files() -> var:lp_vcs_unstaged_files

   Returns ``true`` if any unstaged files exist in the repository. In other
   words, tracked files that contain unstaged changes. Returns the number of
   unstaged files.

   Many VCS providers do not support staging.

   .. versionadded:: 2.0

.. function:: _lp_vcs_unstaged_lines() -> var:lp_vcs_unstaged_i_lines, var:lp_vcs_unstaged_d_lines

   Returns ``true`` if any unstaged lines exist in the repository. In other
   words, tracked files that contain unstaged changes. Returns the number of
   unstaged lines.

   Many VCS providers do not support staging.

   .. versionadded:: 2.0

.. function:: _lp_vcs_untracked_files() -> var:lp_vcs_untracked_files

   Returns ``true`` if any untracked files exist in the repository. Returns the
   number of untracked files.

   Some VCS providers refer to untracked files as "extra" files.

   .. versionadded:: 2.0

Bazaar
------

.. warning::
   Bazaar is no longer being actively developed, and depends on Python 2, which
   is no longer supported. `Breezy <https://www.breezy-vcs.org/>`_ is a fork
   that can work with Bazaar repositories. To use Breezy in place of Bazaar, set
   a wrapper function::

      bzr() { brz "$@"; }

.. note::
   Bazaar does not support bookmarks.
   A nick is somewhat like a bookmark, but there is no command to view a naked
   branch name, so the ``nick`` command is used for branches.

.. note::
   Bazaar does not support a staging area.

.. note::
   Bazaar does not support getting details of remote tracking branches.
   Bazaar does not keep a local copy of the remote state, so checking this
   would be impossible anyway.

.. note::
   Bazaar does not have extra head statuses. A Bazaar merge can be partially
   complete, but there is no command to test for it.

.. function:: _lp_bzr_active()

   Returns ``true`` if Bazaar is enabled in Liquidprompt and the current
   directory is a valid Bazaar repository. This check should be done before
   running any other ``_lp_bzr_*`` data functions if accessing the Bazaar
   data functions directly instead of through the generic interface.

   Can be disabled by :attr:`LP_ENABLE_BZR`.

   .. versionadded:: 2.0

.. function:: _lp_bzr_branch() -> var:lp_vcs_branch

   Returns ``true`` if a branch is active in the repository. Returns the branch
   name.

   .. versionchanged:: 2.0
      Return method changed from stdout.
      No branch now returns ``false``.

.. function:: _lp_bzr_commit_id() -> var:lp_vcs_commit_id

   Returns the revision number of the current commit. The return code is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_bzr_stash_count() -> var:lp_vcs_stash_count

   Returns ``true`` if there are shelves the repository. Returns the
   number of shelves.

   .. versionadded:: 2.0

.. function:: _lp_bzr_tag() -> var:lp_vcs_tag

   Returns ``true`` if a tag is active in the repository. Returns the
   tag name.

   If multiple tags match, only one is returned. Which tag is selected is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_bzr_uncommitted_files() -> var:lp_vcs_uncommitted_files

   Returns ``true`` if any uncommitted files exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted files.

   .. versionadded:: 2.0

.. function:: _lp_bzr_uncommitted_lines() -> var:lp_vcs_uncommitted_i_lines, var:lp_vcs_uncommitted_d_lines

   Returns ``true`` if any uncommitted lines exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted lines.

   .. versionadded:: 2.0

.. function:: _lp_bzr_untracked_files() -> var:lp_vcs_untracked_files

   Returns ``true`` if any untracked files exist in the repository. Returns the
   number of untracked files.

   .. versionadded:: 2.0

Fossil
------

.. note::
   Fossil does not support bookmarks.

.. note::
   Fossil does not support a staging area.

.. note::
   Fossil does not support unique tags. Fossil tags can refer to multiple
   checkin IDs, so a matching tag is not a useful unique ID.

.. note::
   Fossil does not support remote tracking branches. Fossil by default keeps the
   local repository in sync with the remote. Even if a user disables that, it is
   not possible to have a local and remote branch named the same not in sync.

.. function:: _lp_fossil_active()

   Returns ``true`` if Fossil is enabled in Liquidprompt and the current
   directory is a valid Fossil repository. This check should be done before
   running any other ``_lp_fossil_*`` data functions if accessing the Fossil
   data functions directly instead of through the generic interface.

   Can be disabled by :attr:`LP_ENABLE_FOSSIL`.

   .. versionadded:: 2.0

.. function:: _lp_fossil_branch() -> var:lp_vcs_branch

   Returns ``true`` if a branch is active in the repository. Returns the branch
   name.

   .. versionchanged:: 2.0
      Return method changed from stdout.
      No branch now returns ``false`` and nothing instead of "no-branch".

.. function:: _lp_fossil_commit_id() -> var:lp_vcs_commit_id

   Returns the full commit hash of the current commit. The return code is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_fossil_head_status() -> var:lp_vcs_head_status

   Return ``true`` if the repository is in a special or unusual state. Return
   the special status.

   Does not return any extra details.

   .. versionadded:: 2.0

.. function:: _lp_fossil_stash_count() -> var:lp_vcs_stash_count

   Returns ``true`` if there are stashes the repository. Returns the
   number of stashes.

   .. versionadded:: 2.0

.. function:: _lp_fossil_uncommitted_files() -> var:lp_vcs_uncommitted_files

   Returns ``true`` if any uncommitted files exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted files.

   .. versionadded:: 2.0

.. function:: _lp_fossil_uncommitted_lines() -> var:lp_vcs_uncommitted_i_lines, var:lp_vcs_uncommitted_d_lines

   Returns ``true`` if any uncommitted lines exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted lines.

   .. versionadded:: 2.0

.. function:: _lp_fossil_untracked_files() -> var:lp_vcs_untracked_files

   Returns ``true`` if any untracked files exist in the repository. Returns the
   number of untracked files.

   .. versionadded:: 2.0

Git
---

.. note::
   Git does not support bookmarks.

.. function:: _lp_git_active()

   Returns ``true`` if Git is enabled in Liquidprompt and the current directory
   is a valid Git repository. This check should be done before running any other
   ``_lp_git_*`` data functions if accessing the Git data functions directly
   instead of through the generic interface.

   Can be disabled by :attr:`LP_ENABLE_GIT`.

   .. versionadded:: 2.0

.. function:: _lp_git_branch() -> var:lp_vcs_branch

   Returns ``true`` if a branch is active in the repository. Returns the branch
   name.

   .. versionchanged:: 2.0
      Return method changed from stdout.
      No branch now returns ``false`` and nothing instead of commit ID.

.. function:: _lp_git_commit_id() -> var:lp_vcs_commit_id

   Returns the full commit hash of the current commit. The return code is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_git_commits_off_remote() -> var:lp_vcs_commit_ahead, var:lp_vcs_commit_behind

   Returns ``true`` if there are commits on the current branch that are not on
   the remote tracking branch, or commits on the remote tracking branch that are
   not on this branch. Returns ``1`` if there are no differing commits. Returns
   ``2`` if there is no matching remote tracking branch.

   Returns the number of commits behind and ahead.

   .. versionadded:: 2.0

.. function:: _lp_git_head_status() -> var:lp_vcs_head_status, var:lp_vcs_head_details

   Return ``true`` if the repository is in a special or unusual state. Return
   the special status, and any extra details (like progress in a rebase) if
   applicable.

   .. versionadded:: 2.0

.. function:: _lp_git_staged_files() -> var:lp_vcs_staged_files

   Returns ``true`` if any staged files exist in the repository. In other words,
   tracked files that contain staged changes. Returns the number of staged
   files.

   .. versionadded:: 2.0

.. function:: _lp_git_staged_lines() -> var:lp_vcs_staged_i_lines, var:lp_vcs_staged_d_lines

   Returns ``true`` if any staged lines exist in the repository. In other words,
   tracked files that contain staged changes. Returns the number of staged
   lines.

   .. versionadded:: 2.0

.. function:: _lp_git_stash_count() -> var:lp_vcs_stash_count

   Returns ``true`` if there are stashes the repository. Returns the
   number of stashes.

   .. versionadded:: 2.0

.. function:: _lp_git_tag() -> var:lp_vcs_tag

   Returns ``true`` if a tag is active in the repository. Returns the
   tag name.

   If multiple tags match, only one is returned. Which tag is selected is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_git_uncommitted_files() -> var:lp_vcs_uncommitted_files

   Returns ``true`` if any uncommitted files exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted files.

   .. versionadded:: 2.0

.. function:: _lp_git_uncommitted_lines() -> var:lp_vcs_uncommitted_i_lines, var:lp_vcs_uncommitted_d_lines

   Returns ``true`` if any uncommitted lines exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted lines.

   .. versionadded:: 2.0

.. function:: _lp_git_unstaged_files() -> var:lp_vcs_unstaged_files

   Returns ``true`` if any unstaged files exist in the repository. In other
   words, tracked files that contain unstaged changes. Returns the number of
   unstaged files.

   .. versionadded:: 2.0

.. function:: _lp_git_unstaged_lines() -> var:lp_vcs_unstaged_i_lines, var:lp_vcs_unstaged_d_lines

   Returns ``true`` if any unstaged lines exist in the repository. In other
   words, tracked files that contain unstaged changes. Returns the number of
   unstaged lines.

   .. versionadded:: 2.0

.. function:: _lp_git_untracked_files() -> var:lp_vcs_untracked_files

   Returns ``true`` if any untracked files exist in the repository. Returns the
   number of untracked files.

   .. versionadded:: 2.0

Mercurial
---------

.. note::
   Mercurial does not support a staging area.

.. note::
   Mercurial remote tracking branches are disabled (see
   :func:`_lp_hg_commits_off_remote`).

.. function:: _lp_hg_active()

   Returns ``true`` if Mercurial is enabled in Liquidprompt and the current
   directory is a valid Mercurial repository. This check should be done before
   running any other ``_lp_hg_*`` data functions if accessing the Mercurial data
   functions directly instead of through the generic interface.

   Can be disabled by :attr:`LP_ENABLE_HG`.

   .. versionadded:: 2.0

.. function:: _lp_hg_bookmark() -> var:lp_vcs_bookmark

   Returns ``true`` if a bookmark is active in the repository. Returns the
   bookmark name.

   Mercurial bookmarks work more like Git branches.

   .. versionadded:: 2.0

.. function:: _lp_hg_branch() -> var:lp_vcs_branch

   Returns ``true`` if a branch is active in the repository. Returns the branch
   name.

   All Mercurial commits have a branch, so this function should always return
   ``true``. A closer analog to Git branches are Mercurial bookmarks (see
   :func:`_lp_hg_bookmark`).

   .. versionchanged:: 2.0
      Return method changed from stdout.
      No branch now returns ``false``.

.. function:: _lp_hg_commit_id() -> var:lp_vcs_commit_id

   Returns the full global revision ID of the current commit. The return code is
   not defined.

   .. versionadded:: 2.0

.. function:: _lp_hg_commits_off_remote()

   Returns ``2`` (disabled).

   Mercurial does not keep a local copy of the remote state, so checking this
   will require a connection to the remote server. This means it is often
   prohibitively time expensive, and therefore should not be used in a prompt.
   See `issue #217`_.

   .. versionadded:: 2.0

   .. _`issue #217`: https://github.com/nojhan/liquidprompt/issues/217

.. function:: _lp_hg_head_status() -> var:lp_vcs_head_status

   Return ``true`` if the repository is in a special or unusual state. Return
   the special status.

   Does not return any extra details.

   This function depends on :func:`_lp_find_vcs` being run first to set
   ``lp_vcs_root``.

   .. versionadded:: 2.0

.. function:: _lp_hg_stash_count() -> var:lp_vcs_stash_count

   Returns ``true`` if there are shelves the repository. Returns the
   number of shelves.

   .. versionadded:: 2.0

.. function:: _lp_hg_tag() -> var:lp_vcs_tag

   Returns ``true`` if a tag is active in the repository. Returns the
   tag name.

   If multiple tags match, only one is returned. Which tag is selected is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_hg_uncommitted_files() -> var:lp_vcs_uncommitted_files

   Returns ``true`` if any uncommitted files exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted files.

   .. versionadded:: 2.0

.. function:: _lp_hg_uncommitted_lines() -> var:lp_vcs_uncommitted_i_lines, var:lp_vcs_uncommitted_d_lines

   Returns ``true`` if any uncommitted lines exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted lines.

   .. versionadded:: 2.0

.. function:: _lp_hg_untracked_files() -> var:lp_vcs_untracked_files

   Returns ``true`` if any untracked files exist in the repository. Returns the
   number of untracked files.

   .. versionadded:: 2.0

Subversion
----------

.. note::
   Subversion does not support bookmarks.

.. note::
   Subversion does not support a staging area.

.. note::
   Subversion does not support stashes.

.. note::
   Subversion does not have extra head statuses. A Subversion merge is no
   different than a manual file change, so the repository has no extra state to
   track.

.. note::
   Subversion does not support remote tracking branches (as it is not a
   distributed version control system).

.. note::
   Subversion does not support tags. What are generally agreed upon as being
   tags are internally branches. These are returned by :func:`_lp_svn_branch`.

.. function:: _lp_svn_active()

   Returns ``true`` if Subversion is enabled in Liquidprompt and the current
   directory is a valid Subversion repository. This check should be done before
   running any other ``_lp_svn_*`` data functions if accessing the Subversion
   data functions directly instead of through the generic interface.

   Can be disabled by :attr:`LP_ENABLE_SVN`.

   .. versionadded:: 2.0

.. function:: _lp_svn_branch() -> var:lp_vcs_branch

   Returns ``true`` if a branch is active in the repository. Returns the branch
   name.

   Subversion "tags" are really branches under a "tag" directory. Tags are
   returned as their directory name, prefixed with "tag/".

   .. versionchanged:: 2.0
      Return method changed from stdout.
      No branch now returns ``false`` and nothing instead of the current
      directory.

.. function:: _lp_svn_commit_id() -> var:lp_vcs_commit_id

   Returns the revision number of the current commit. The return code is not
   defined.

   .. versionadded:: 2.0

.. function:: _lp_svn_uncommitted_files() -> var:lp_vcs_uncommitted_files

   Returns ``true`` if any uncommitted files exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted files.

   .. versionadded:: 2.0

.. function:: _lp_svn_uncommitted_lines() -> var:lp_vcs_uncommitted_i_lines, var:lp_vcs_uncommitted_d_lines

   Returns ``true`` if any uncommitted lines exist in the repository. In other
   words, tracked files that contain uncommitted changes. Returns the number of
   uncommitted lines.

   .. versionadded:: 2.0

.. function:: _lp_svn_untracked_files() -> var:lp_vcs_untracked_files

   Returns ``true`` if any untracked files exist in the repository. Returns the
   number of untracked files.

   .. versionadded:: 2.0


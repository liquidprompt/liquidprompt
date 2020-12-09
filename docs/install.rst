Installation
************

.. contents::
   :local:

.. toctree::
   :maxdepth: 1

   install/packages

Download
========

You can either download the latest release from Github, or using your OS package
manager with our :doc:`install/packages`.

To download to ``~/liquidprompt``, run::

   git clone https://github.com/nojhan/liquidprompt.git ~/liquidprompt

If you do not have ``git``, you can download and extract the source in zip or
gzip format directly from the `release page
<https://github.com/nojhan/liquidprompt/releases/latest>`_.

Installation via Antigen
------------------------

To install via `Antigen <https://antigen.sharats.me/>`_, simply add the
following line in your ``.zshrc`` after activating Antigen::

   antigen bundle nojhan/liquidprompt

Dependencies
============

Liquidprompt uses commands that should be available on a large variety of Unix
systems:

   * ``awk``
   * ``grep``
   * ``logname``
   * ``ps``
   * ``sed``
   * ``uname``
   * ``who``

Some features depend on specific commands. If you do not install them, the
corresponding feature will not be available, but no error will be displayed. See
the :doc:`config` for more information about available features and what tools
they require.

   * Battery status requires ``acpi`` on GNU/Linux.
   * Temperature status requires ``acpi`` or ``sensors`` on GNU/Linux.
   * Terminal formatting requires ``tput``.
   * Detached session status looks for ``screen`` and/or ``tmux``.
   * VCS support features require ``git``, ``hg``, ``svn``, ``bzr`` or
     ``fossil`` for their respective repositories.

Test Drive
==========

To test the prompt immediately after download, run::

   source ~/liquidprompt/liquidprompt

Adjust the path if you installed to a different location that the suggested
``~/liquidprompt``.

Shell Installation
==================

To use Liquidprompt every time you start a shell, add the following lines to
your ``.bashrc`` (if you use Bash) or ``.zshrc`` (if you use zsh)::

   # Only load Liquidprompt in interactive shells, not from a script or from scp
   [[ $- = *i* ]] && source ~/liquidprompt/liquidprompt

Adjust the path if you installed to a different location that the suggested
``~/liquidprompt``.

.. warning::
   Check in your ``.bashrc`` that the :envvar:`PROMPT_COMMAND` variable is not
   set, or else the prompt will not be available. If you must set it or use a
   add-on that sets it, make sure to set :envvar:`PROMPT_COMMAND` **before** you
   source Liquidprompt to avoid history and timing issues. Do not export
   :envvar:`PROMPT_COMMAND`.

Next up are the :doc:`config`.

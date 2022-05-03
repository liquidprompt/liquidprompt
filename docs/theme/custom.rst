Custom Themes
*************

.. contents::
   :local:

Defining a Theme
================

A theme should be contained in one file with a ``.theme`` file suffix. There
should be no "top level" code in the file, or in other words, all code should be
contained in functions. Sourcing the file should run no code, as a user sourcing
the theme file might not want to activate it yet.

Prompt Function
---------------

Every theme must have a prompt function that is called for every prompt to
generate the prompt. It *must* be set to ``_lp_<theme_id>_theme_prompt()``.

This function could do anything, but generally it should generate a prompt and
store it in :envvar:`PS1`.

Directory Function
------------------

Optionally, a theme can have a directory function. It must be set to
``_lp_<theme_id>_theme_directory()``.

This function is called every time the user changes directories. This allows the
theme to only run generating code that depends on the current directory when it
is needed.

Activate Function
-----------------

Optionally, a theme can have an activate function. It must be set to
``_lp_<theme_id>_theme_activate()``.

This function is called when the theme is first activated, and every time the
user runs :func:`lp_activate`. Prompt pieces that never change (such as hostname
and username) should be generated here. This is also where the theme's default
values should be set. This function will always be called after the user config
is already loaded.

Other Functions
---------------

If a theme is moderately complicated, it will need other functions defined to
help generate a prompt. These should be named following the :doc:`../functions`
guidelines concerning underscore prefixes.

The prefix of a function should always be either ``_<theme_id>_`` or
``_lp_<theme_id>_`` to prevent overwriting functions already defined by the
user.

Getting Data
============

A theme must call :doc:`../functions/data` to be able to display useful
information to the user. A theme might also need to use :doc:`../functions/util`
to process that data.

Examples
========

The :doc:`included/alternate_vcs` is a good example of creating a theme based on
the default theme.

The :doc:`included/powerline` is a good example of creating a detailed theme.

Sharing Your Theme
==================

First see the `Theme sharing`_ wiki page for things you should do to make your
theme shareable.

The `Themes`_ wiki page is where you can share your theme with other users.

.. _`Themes`: https://github.com/nojhan/liquidprompt/wiki/Themes
.. _`Theme sharing`: https://github.com/nojhan/liquidprompt/wiki/Theme-sharing

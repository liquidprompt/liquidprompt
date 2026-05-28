Theming
*******

Liquid Prompt has a strong data and theming engine, allowing it to be extremely
flexible and customizable.

There are multiple methods of customizing your prompt that are easy to
get confused. These are:

* Presets: a preset is simply an example config file. Parts or all of a preset
  can be copied to your own config file, or you can source the presets inside
  your config file, letting you combine, extend, or override any of the
  configuration options. If you just want to change icons and/or colors,
  presets are a good starting place. See ``contrib/presets`` for examples.
  Presets can generally be combined, and some themes may use —or be compatible
  with— different presets. See :doc:`config`.
* Themes: a theme is a set of shell functions that control everything about
  prompt generation. Liquid Prompt ships with a theme named ``default`` enabled
  by default, as well as a few more (see :doc:`theme/included`). This is a
  layer beyond simple configuration options. You can write your own themes, but
  this is complicated and generally not necessary to make the modifications
  most users want to make.
* Templates: a template (previously called "themes" in Liquid Prompt version 1)
  is specific to the :doc:`theme/default`, allowing for a user to re-order the
  sections of the default theme. This gives more control than just the
  configuration options can give, but is much simpler to do than writing a full
  theme.

See the `Liquid Prompt Theme List`_ on the wiki for user created themes.

If you want to create your own theme, see :doc:`theme/custom`.

.. _`Liquid Prompt Theme List`: https://github.com/liquidprompt/liquidprompt/wiki/Themes

.. toctree::
   :maxdepth: 2

   theme/default
   theme/included
   theme/custom

.. contents::
   :local:

Switching Themes
================

In a nutshell
-------------

To use a theme, just source its file in your shell configuration file,
after having load the liquidprompt, and then call ``lp_theme``::

   source <your_path>/liquidprompt
   source <your_path>/themes/unfold/unfold.theme
   lp_theme unfold


More Details
------------

Liquid Prompt can switch between themes on the fly. The shell does not need to
be reloaded, and no files need to be sourced after the initial source.

To load (but not activate) a theme, simply source the theme file. For example,
to load the included Alternate VCS Details theme, source the theme file::

   $ source themes/alternate_vcs/alternate_vcs.theme

Now both the default theme and Alternate VCS are loaded. To show what themes are
loaded and available, run :func:`lp_theme`::

   $ lp_theme --list
   default
   alternate_vcs

To switch to a different theme, call :func:`lp_theme` with the name of the theme
as the argument::

   $ lp_theme alternate_vcs

The prompt will immediately take on the new theme.

To switch back to the default theme, call :func:`lp_theme` again with
``default`` as the argument instead.

If you add the theme source commands to your shell startup file, you will have
your favorite themes ready to be switched to at any time.


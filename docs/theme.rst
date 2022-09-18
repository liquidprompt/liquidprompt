Theming
*******

Liquid Prompt has a strong data and theming engine, allowing it to be extremely
flexible and customizable.

The :doc:`theme/default` has a templating engine (previously called "themes" in
Liquid Prompt version 1), that allows for custom prompt ordering in the default
theme.

Liquid Prompt ships with some :doc:`theme/included` other than the default as
well.

See the `Liquid Prompt Theme List`_ on the wiki for user created themes.

If you want to create your own theme, see :doc:`theme/custom`.

.. _`Liquid Prompt Theme List`: https://github.com/nojhan/liquidprompt/wiki/Themes

.. toctree::
   :maxdepth: 2

   theme/default
   theme/included
   theme/custom

.. contents::
   :local:


Switching Themes
----------------

Liquid Prompt can switch between themes on the fly. The shell does not need to be
reloaded, and no files need to be sourced after the initial source.

To load (but not activate) a theme, simply source the theme file. For example,
to load the included Powerline theme, source the theme file::

   $ source themes/powerline/powerline.theme

Now both the default theme and Powerline are loaded. To show what themes are
loaded and available, run :func:`lp_theme`::

   $ lp_theme --list
   default
   powerline_full
   powerline

To switch to a different theme, call :func:`lp_theme` with the name of the theme
as the argument::

   $ lp_theme powerline

The prompt will immediately take on the new theme.

To switch back to the default theme, call :func:`lp_theme` again with
``default`` as the argument instead.

If you add the theme source commands to your shell startup file, you will have
your favorite themes ready to be switched to at any time.


Themes overview
---------------

Default
_______

Available via ``lp_theme default``:

.. image:: theme/default-med.png


Alternate VCS
_____________

Theme available after::

   $ source themes/alternate_vcs/alternate_vcs.theme

and ``lp_theme alternate_vcs``.

.. image:: theme/included/alternate_vcs-long.png


Powerline themes
________________

All themes available after::

   $ source themes/powerline/powerline.theme


- :ref:`Powerline <powerline>` (``lp_theme powerline``):

  .. image:: theme/included/powerline-med.png

- :ref:`Power2lines <power2lines>` (``lp_theme power2lines``):

  .. image:: theme/included/power2lines-med.png

- :ref:`Powerpuff <powerpuff>` (``lp_theme powerpuff``):

  .. image:: theme/included/powerpuff-med.png

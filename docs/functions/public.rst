Public Functions
****************

These functions are designed to be used by users on the command line or in
their config.

.. function:: lp_activate()

   Reload the user config.

   This function is called when sourcing ``liquidprompt``, unless the flag
   ``--no-activate`` is passed.

   The config is sourced, and the environment scanned again for programs needed
   for specific features.

   Lastly, :func:`prompt_on` is called to enabled the prompt.

   .. versionadded:: 2.0

.. function:: lp_title([title_string])

   Not to be confused with :func:`_lp_title`.

   Set *title_string* as the terminal title. This overrides any title set by the
   current theme.

   .. note::
      The input string is not escaped in any way; if it contains characters
      that the shell will interpret, the user must escape them if that behavior
      is not desired.

   To unset the manual title, call :func:`lp_title` with no arguments.

   To set a blank title, call :func:`lp_title` with an empty string argument
   (``''``).

   This function will do nothing and return ``2`` if :attr:`LP_ENABLE_TITLE`
   is ``0``.

   .. versionadded:: 2.0

.. function:: lp_theme(theme_id | --list)

   Load and activate the theme named *theme_id*. The theme functions must be
   loaded into memory before :func:`lp_theme` can be called, normally by
   sourcing the theme file.

   The optional flag ``--list`` will instead list all currently loaded
   themes.

   This function supports shell autocompletion.

   .. versionadded:: 2.0

.. function:: lp_terminal_format(foreground_color, [background_color], \
                                 [bold], [underline], \
                                 [fallback_foreground_color], \
                                 [fallback_background_color]) \
                                 -> var:lp_terminal_format

   Generate a shell escaped terminal formatting string for use in :envvar:`PS1`.

   The start of the formatting string always resets back to terminal defaults.

   *foreground_color* and *background_color* accept an
   `ANSI escape color code`_ integer to set the color of the foreground and
   background, respectively. The behavior depends on the integer:

   * ``>= 0 && < max_color`` - The color is used directly.
   * ``>= max_color`` - If the terminal reports that the number of colors it
     supports is less than the input color code, the
     *fallback_foreground_color* or *fallback_background_color* is used instead.
   * ``-1`` - No color is set. This does not mean that the previous color will
     continue over, as all formatting is reset to default at the start of the
     sequence. This means the default coloring is effectively set.
   * ``-2`` - The previous color of the field is set. If no color was
     previously set, no color will be set. Note that the output is a static
     formatting string; the string will not keep the same color as the terminal
     previously had, but the color that was last selected when
     :func:`lp_terminal_format` was last run.
   * ``-3`` - Same as ``-2``, except the opposite field color is copied. In
     other words, if *foreground_color* is set to ``-3``, it will copy the
     color of *background_color* the last time :func:`lp_terminal_format`
     was run.

   *bold* and *underline* enable their respective formats when set to ``1``.
   If omitted or set to ``0``, they are not enabled. To use fallback colors,
   they will need to be set to be able to set the other options.

   *fallback_foreground_color* and *fallback_background_color* are used when the
   normal colors are higher than the terminal supported colors. The special
   negative inputs do not work for these options, and they are not checked for
   compatibility before being used, so it is recommended that they are in the
   range ``0-7``.
   When setting *foreground_color* or *background_color* to negative inputs,
   these options are never checked.

   For example, to set the error color to a bright, bold pink, with a fallback
   color of red::

      lp_terminal_format 204 -1 1 0 1
      LP_COLOR_ERR=$lp_terminal_format

   To set the prompt mark color to black on a white background::

      lp_terminal_format 0 7
      LP_COLOR_MARK=$lp_terminal_format

   .. versionadded:: 2.0

   .. _`ANSI escape color code`: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

.. function:: prompt_on()

   Enable the prompt generation and setting.

   This function is called when sourcing ``liquidprompt``, unless the flag
   ``--no-activate`` is passed.

.. function:: prompt_off()

   Disable the prompt generation and setting, and restore the old :envvar:`PS1`.

   If the shell is Bash, also restore the old :envvar:`PROMPT_COMMAND`.

   If the shell is Zsh, also restore the old prompt theme.

.. function:: prompt_OFF()

   Same as :func:`prompt_off`, except instead of restoring the previous
   :envvar:`PS1`, it is set to "$ " on Bash, "% " on Zsh.

.. function:: prompt_tag([prefix_string])

   Sets a prefix that will be displayed before every prompt. Postpends a space
   to the input string.

   Internally, this function sets :attr:`LP_PS1_PREFIX` to *prefix_string*.
   If a trailing space is not wanted, set :attr:`LP_PS1_PREFIX` manually.

   To unset the prefix, call :func:`prompt_tag` with no arguments.

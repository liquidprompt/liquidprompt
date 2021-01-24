Internal Functions
******************

.. contents::
   :local:

These functions are designed to be used only by Liquidprompt internals and data
functions. These functions should not be used by users or themes, as they are
not guaranteed to be stable between versions. There are documented here for
information for those developing Liquidprompt.

Config
------

.. function:: __lp_source_config([--no-config])

   Load the user config and default config values. This function is called by
   :func:`lp_activate`.

   Also setup color variables that can be used by the user for their color
   config. Those variables are local to this function.

   If the ``--no-config`` flag is passed, defaults are set, but no config file
   is sourced.

   .. versionchanged:: 2.0
      Renamed from ``_lp_source_config``.
      Added ``--no-config`` flag.

Formatting
----------

.. function:: __lp_background_color(color) -> var:ab_color

   Returns the terminal escape code to set the background color to the
   `ANSI escape color code`_ integer *color*. No checking is done for invalid
   color codes.

   .. versionadded:: 1.12

   .. versionchanged:: 2.0
      Renamed from ``background_color``.

.. function:: __lp_foreground_color(color) -> var:af_color

   Returns the terminal escape code to set the foreground color to the
   `ANSI escape color code`_ integer *color*. No checking is done for invalid
   color codes.

   .. versionadded:: 1.12

   .. versionchanged:: 2.0
      Renamed from ``foreground_color``.

.. _`ANSI escape color code`: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

Git
---

.. function:: __lp_git_diff_shortstat_files(diff_shortstat) -> var:lp_git_diff_shortstat_files

   Processes the input *diff_shortstat* as the output of a ``git diff
   --shortstat`` command, returning the number of changed files. This allows for
   the comparison of any two states, as :func:`__lp_git_diff_shortstat_files`
   does not run any specific ``git diff`` command.

   .. versionadded:: 2.0

.. function:: __lp_git_diff_shortstat_lines(diff_shortstat) -> var:lp_git_diff_shortstat_lines

   Processes the input *diff_shortstat* as the output of a ``git diff
   --shortstat`` command, returning the number of changed lines. This allows for
   the comparison of any two states, as :func:`__lp_git_diff_shortstat_files`
   does not run any specific ``git diff`` command.

   .. versionadded:: 2.0

.. function:: __lp_git_diff_shortstat_staged() -> var:_lp_git_diff_shortstat_staged

   Returns the output of a ``git diff --shortstat`` command, comparing the
   staging area to the HEAD commit.

   The return variable is supposed to be a cache, set as local in
   :func:`__lp_set_prompt`, preventing duplicate calls to ``git``.

   .. versionadded:: 2.0

.. function:: __lp_git_diff_shortstat_uncommitted() -> var:_lp_git_diff_shortstat_uncommitted

   Returns the output of a ``git diff --shortstat`` command, comparing the
   working directory to the HEAD commit.

   The return variable is supposed to be a cache, set as local in
   :func:`__lp_set_prompt`, preventing duplicate calls to ``git``.

   .. versionadded:: 2.0

.. function:: __lp_git_diff_shortstat_unstaged() -> var:_lp_git_diff_shortstat_unstaged

   Returns the output of a ``git diff --shortstat`` command, comparing the
   working directory to the staging area.

   The return variable is supposed to be a cache, set as local in
   :func:`__lp_set_prompt`, preventing duplicate calls to ``git``.

   .. versionadded:: 2.0

Load
----

.. function:: __lp_cpu_count() -> var:_lp_CPUNUM

   Returns the number of CPUs on the machine. The implementation depends on the
   operating system.

   .. versionadded:: 2.0

OS
--

.. function:: __lp_hostname_hash() -> var:lp_hostname_hash

   Returns the hash of the hostname as computed by ``cksum``.

   .. versionadded:: 2.0

Path
----

.. function:: __lp_path() -> var:lp_path

   Sets :attr:`lp_path` to the current path. Internally, calls either
   :func:`__lp_shorten_path` or :func:`__lp_set_dirtrim` to do so, depending on
   the values of :attr:`LP_PATH_KEEP` and :attr:`LP_ENABLE_SHORTEN_PATH`.

   Only :func:`__lp_shorten_path` actually sets ``lp_path``, other config
   options will initialize ``lp_path`` with a shell escape sequence so the
   shell will print the path.

   .. versionadded:: 2.0

.. function:: __lp_pwd_tilde() -> var:lp_pwd_tilde

   Returns :envvar:`PWD` with the user's home directory replace with a tilde
   ("~").

   .. versionchanged:: 2.0
      Renamed from ``_lp_get_home_tilde_collapsed``.
      Return method changed from stdout.

.. function:: __lp_set_dirtrim() -> var:PROMPT_DIRTRIM

   In Bash shells, :envvar:`PROMPT_DIRTRIM` is the number of directories to keep
   at the end of the displayed path (if "\w" is present in :envvar:`PS1`).
   Liquid Prompt can calculate this number under two conditions, path shortening
   must be disabled and :envvar:`PROMPT_DIRTRIM` must be already set.

   .. versionchanged:: 2.0
      Renamed from ``_lp_set_dirtrim``.

.. function:: __lp_shorten_path() -> var:lp_shorten_path

   Shorten the path of the current working directory if the path is longer than
   :attr:`LP_PATH_LENGTH`. Show as much of the current working directory path as
   possible. If shortened display a leading mark, such as ellipses, to indicate
   that part is missing. Show at least :attr:`LP_PATH_KEEP` leading directories
   and current directory.

   .. versionchanged:: 2.0
      Renamed from ``_lp_shorten_path``.
      Removed handling of cases where no shortening is required, as that should
      be handled by :attr:`__lp_path` on activate.
      Return variable changed from ``LP_PWD``.

Prompt
------

.. function:: __lp_set_prompt()

   Setup features that need to be handled outside of the themes, like
   :func:`_lp_error` (since last return code must be recorded first), non
   printing features like :attr:`LP_ENABLE_RUNTIME_BELL` and
   :attr:`LP_ENABLE_TITLE`, track current directory changes, and initialize data
   source cache variables. This function also calls the current theme functions.

   .. versionchanged:: 2.0
      Renamed from ``_lp_set_prompt``.

Runtime
-------

.. function:: __lp_runtime_before()

   Hooks into the shell to run directly after the user hits return on a command,
   to record the current time before the command runs.

   .. versionchanged:: 2.0
      Renamed from ``_lp_runtime_before``.

.. function:: __lp_runtime_after()

   Hooks into the shell to run directly after the user command returns, to
   record the current time, and calculate how long the command ran for.

   .. versionchanged:: 2.0
      Renamed from ``_lp_runtime_after``.

Theme
-----

.. function:: __lp_theme_list() -> var:lp_theme_list

   Returns an array of Liquidprompt themes currently loaded in memory. Looks for
   functions matching ``_lp_*_theme_prompt``.

   .. versionadded:: 2.0

.. function:: __lp_theme_bash_complete() -> var:COMPREPLY

   Uses :func:`__lp_theme_list` to provide Bash autocompletion for
   :func:`lp_theme`.

   .. versionadded:: 2.0

.. function:: __lp_theme_zsh_complete()

   Uses :func:`__lp_theme_list` to provide Zsh autocompletion for
   :func:`lp_theme`.

   .. versionadded:: 2.0

Temperature
-----------
.. function:: __lp_temp_detect() -> var:_LP_TEMP_FUNCTION

   Attempts to run the possible temperature backend functions below to find one
   that works correctly. When one correctly returns a value, it is saved to
   ``_LP_TEMP_FUNCTION`` for use by :func:`_lp_temperature`.

   .. versionchanged:: 2.0
      Renamed from ``_lp_temp_detect``.

.. function:: __lp_temp_acpi() -> var:lp_temperature

   A temperature backend using ``acpi``.

   .. versionchanged:: 2.0
      Renamed from ``_lp_temp_acpi``.
      Return variable changed from ``temperature``.

.. function:: __lp_temp_sensors() -> var:lp_temperature

   A temperature backend using lm-sensors provided ``sensors``.

   .. versionchanged:: 2.0
      Renamed from ``_lp_temp_sensors``.
      Return variable changed from ``temperature``.

Utility
---------

.. function:: __lp_escape(string) -> var:ret

   Escape shell escape characters so they print correctly in :envvar:`PS1`.

   In Bash, backslashes (``\``) are used to escape codes, so backslashes are
   replaced by two backslashes.

   In Zsh, percents (``%``) are used to escape codes, so percents are replaced
   by two percents.

   .. versionchanged:: 2.0
      Renamed from ``_lp_escape``.
      Return method changed from stdout.

.. function:: __lp_floating_scale(number, scale) -> var:ret

   Returns the input floating point *number* multiplied by the input *scale*.
   The input *scale* must be a power of 10.

   Shells do not support floating point math, so this is used to scale up
   floating point numbers to integers with the needed precision.

   .. versionadded:: 2.0

.. function:: __lp_is_function(function)

   Returns ``true`` if *function* is the name of a function.

   .. versionadded:: 2.0

.. function:: __lp_line_count(string) -> var:count

   Count the number of newline characters (``\n``) in *string*. A faster drop-in
   replacement for ``wc -l``.

   .. versionadded:: 2.0

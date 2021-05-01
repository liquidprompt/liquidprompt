Default Theme Functions
***********************

.. contents::
   :local:

These functions are designed to be used by the default theme, but are documented
here so that other themes can use these functions to reduce duplication if
sections from the default theme are wanted.

Theme Functions
---------------

.. function:: _lp_default_theme_activate()

   Setup the defaults and static pieces of the default theme.

   Uses colors:

   * :attr:`LP_COLOR_IN_MULTIPLEXER`
   * :attr:`LP_COLOR_MARK`
   * :attr:`LP_COLOR_MARK_ROOT`
   * :attr:`LP_COLOR_PATH_ROOT`
   * :attr:`LP_COLOR_USER_ALT`
   * :attr:`LP_COLOR_USER_LOGGED`
   * :attr:`LP_COLOR_USER_ROOT`

   And marks:

   * :attr:`LP_MARK_BRACKET_OPEN`
   * :attr:`LP_MARK_BRACKET_CLOSE`
   * :attr:`LP_MARK_DEFAULT`

   .. versionadded:: 2.0

.. function:: _lp_default_theme_directory()

   Setup the colors for the directory when the current working directory
   changes.

   Uses colors:

   * :attr:`LP_COLOR_NOWRITE`
   * :attr:`LP_COLOR_PATH`
   * :attr:`LP_COLOR_WRITE`

   And mark :attr:`LP_MARK_PERM`.

   .. versionadded:: 2.0

.. function:: _lp_default_theme_prompt()

   Runs :func:`_lp_default_theme_prompt_data` then
   :func:`_lp_default_theme_prompt_template`.

   .. versionadded:: 2.0

.. function:: _lp_default_theme_prompt_data()

   Runs all of the below theme data functions, and writes values to the
   :doc:`../theme/default` variables. Can be used to generate all the default
   theme sections, then modify them before running a user template.

   .. versionadded:: 2.0

.. function:: _lp_default_theme_prompt_template()

   If :attr:`LP_PS1_FILE` is set, sources it.

   Then, if :attr:`LP_PS1` is set, uses it as :envvar:`PS1`. Otherwise, uses the
   default theme layout to construct :envvar:`PS1`. Can be used to set different
   template sections than the default theme, but still use the same template
   engine.

   .. versionadded:: 2.0

Theme Data Functions
--------------------

These functions wrap :doc:`data` with color and/or other formatting. Their
return codes are the same as the data functions they wrap unless otherwise
documented.

The interface of the functions will not change between minor versions, but the
specific text and formatting may change.

.. function:: _lp_analog_time_color() -> var:lp_analog_time_color

   Returns :func:`_lp_analog_time` with color from :attr:`LP_COLOR_TIME`.

   .. versionadded:: 2.0

.. function:: _lp_aws_profile_color() -> var:lp_aws_profile_color

   Returns :func:`_lp_aws_profile` with color from :attr:`LP_COLOR_AWS_PROFILE`.

   .. versionadded:: 2.1

.. function:: _lp_battery_color() -> var:lp_battery_color

   Returns data from :func:`_lp_battery`, colored with:

   * :attr:`LP_COLOR_CHARGING_ABOVE`
   * :attr:`LP_COLOR_CHARGING_UNDER`
   * :attr:`LP_COLOR_DISCHARGING_ABOVE`
   * :attr:`LP_COLOR_DISCHARGING_UNDER`
   * :attr:`LP_COLORMAP`

   And using marks:

   * :attr:`LP_MARK_ADAPTER`
   * :attr:`LP_MARK_BATTERY`

   Adds battery value if :attr:`LP_PERCENTS_ALWAYS` is ``1``.

   .. versionchanged:: 2.0
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_dirstack_color() -> var:lp_dirstack_color

    Returns :func:`_lp_dirstack`, prefixed with :attr:`LP_MARK_DIRSTACK`, all
    colored with :attr:`LP_COLOR_DIRSTACK`.

    .. versionadded:: 2.0

.. function:: _lp_error_color() -> var:lp_error_color

   Returns :func:`_lp_error` with color from :attr:`LP_COLOR_ERR`.

   .. versionadded:: 2.0

.. function:: _lp_hostname_color() -> var:lp_hostname_color

   Returns :func:`_lp_hostname`, with added data from :func:`_lp_chroot`.
   Color from :attr:`LP_COLOR_HOST`, :attr:`LP_COLOR_SSH`,
   :attr:`LP_COLOR_HOST_HASH`, and :attr:`LP_COLOR_TELNET`, depending on the
   output of :func:`_lp_connection`.

   Added color from :func:`_lp_connected_display`: either
   :attr:`LP_COLOR_X11_ON` or :attr:`LP_COLOR_X11_OFF`.

   Return code is :func:`_lp_hostname` ORed with :func:`_lp_chroot`: both must
   return no data for :func:`_lp_hostname_color` to return no data.

   .. versionadded:: 2.0

.. function:: _lp_http_proxy_color() -> var:lp_http_proxy_color

   Returns :func:`_lp_http_proxy` with color from :attr:`LP_COLOR_PROXY`.

   .. versionadded:: 2.0

.. function:: _lp_jobcount_color() -> var:lp_jobcount_color

   Returns :func:`_lp_detached_sessions` with color from :attr:`LP_COLOR_JOB_D`
   and :func:`_lp_jobcount` with colors from :attr:`LP_COLOR_JOB_R` and
   :attr:`LP_COLOR_JOB_Z`.

   Return code is :func:`_lp_detached_sessions` ORed with :func:`_lp_jobcount`:
   both must return no data for :func:`_lp_jobcount_color` to return no data.

   .. versionchanged:: 2.0
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_kubernetes_context_color() -> var:lp_kubernetes_context_color

   Returns data from :func:`_lp_kubernetes_context`, colored with
   :attr:`LP_COLOR_KUBECONTEXT` and using mark :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1

.. function:: _lp_load_color() -> var:lp_load_color

   Returns :func:`_lp_load` with color from :attr:`LP_COLORMAP` and mark from
   :attr:`LP_MARK_LOAD`.

   Adds load value if :attr:`LP_PERCENTS_ALWAYS` is ``1``.

   .. versionchanged:: 2.0
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_python_env_color() -> var:lp_python_env_color

   Returns :func:`_lp_python_env` with color from :attr:`LP_COLOR_VIRTUALENV`.

   .. versionadded:: 2.0

.. function:: _lp_ruby_env_color() -> var:lp_ruby_env_color

   Returns :func:`_lp_ruby_env` with color from :attr:`LP_COLOR_VIRTUALENV`.

   .. versionadded:: 2.1

.. function:: _lp_runtime_color() -> var:lp_runtime_color

   Returns :func:`_lp_runtime_format` with color from :attr:`LP_COLOR_RUNTIME`.

   .. versionchanged:: 2.0
      Renamed from ``_lp_runtime``.
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_software_collections_color() -> var:lp_software_collections_color

   Returns :func:`_lp_software_collections` with color from
   :attr:`LP_COLOR_VIRTUALENV`.

   .. versionadded:: 2.0

.. function:: _lp_sudo_active_color() -> var:lp_sudo_active_color

   Returns :func:`_lp_sudo_active` with color and marks from
   :attr:`LP_COLOR_MARK_SUDO` if sudo is active, or
   :attr:`LP_COLOR_MARK_NO_SUDO` if not.

   Does not return ``1`` if sudo is not active, as the return string is still
   needed.

   .. versionchanged:: 2.0
      Renamed from ``_lp_sudo_check``.
      Always defined instead of only when :attr:`LP_ENABLE_SUDO` is enabled.
      Return variable changed from ``LP_COLOR_MARK``.

.. function:: _lp_temperature_color() -> var:lp_temperature_color

   Returns :func:`_lp_temperature` with color from :attr:`LP_COLORMAP` and mark
   from :attr:`LP_MARK_TEMP`.

   .. versionchanged:: 2.0
      Renamed from ``_lp_temperature``.
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_terraform_env_color() -> var:lp_terraform_env_color

   Returns :func:`_lp_terraform_env` with color from :attr:`LP_COLOR_TERRAFORM`.

   .. versionadded:: 2.1

.. function:: _lp_time_color() -> var:lp_time_color

   Returns :func:`_lp_time` with color from :attr:`LP_COLOR_TIME`.

   .. versionadded:: 2.0

.. function:: _lp_vcs_details_color() -> var:lp_vcs_details_color

   Returns data from all generic :doc:`data/vcs`, colored with:

   * :attr:`LP_COLOR_CHANGES`
   * :attr:`LP_COLOR_COMMITS`
   * :attr:`LP_COLOR_COMMITS_BEHIND`
   * :attr:`LP_COLOR_DIFF`
   * :attr:`LP_COLOR_UP`

   And using marks:

   * :attr:`LP_MARK_STASH`
   * :attr:`LP_MARK_UNTRACKED`

   This function should only be called when in a VCS repository; use
   :func:`_lp_find_vcs` or :func:`_lp_vcs_active` before.

   The return code is undefined; a string should always be returned.

   .. versionadded:: 2.0

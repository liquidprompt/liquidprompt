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
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

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

.. function:: _lp_cmake_color() -> var:lp_cmake_color

   Returns data from :func:`_lp_cmake`.
   `lp_cmake_compiler` and `lp_cmake_generator` are colored according to their
   hash (see :func:`_lp_hash_color`). `lp_cmake_buildtype` has as configurable
   color, depending on its value:

   - *Debug*, colored with :attr:`LP_COLOR_CMAKE_DEBUG` (magenta, by default),
   - *RelWithDebInfo*, colored with :attr:`LP_COLOR_CMAKE_RWDI` (blue, by
     default),
   - *Release*, colored with :attr:`LP_COLOR_CMAKE_RELEASE` (cyan, by default),
   - any other value would be colored according to its hash.

   .. versionadded:: 2.2

.. function:: _lp_container_color() -> var:_lp_container_color

   Returns :func:`_lp_container`, surrounded by « and »
   colored with :attr:`LP_COLOR_CONTAINER` if the value is true.
   Returns no data if the value is false.

   .. versionadded:: 2.1
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

.. function:: _lp_dev_env_color() -> var:lp_dev_env_color

   Assemble data related to development environment and returns a single string.
   The returned string starts with :attr:`LP_MARK_DEV_OPEN` and ends with
   :attr:`LP_MARK_DEV_CLOSE`, with each section separated by
   :attr:`LP_MARK_DEV_MID`.

   Data are collected from:

   - :attr:`LP_SCLS`
   - :attr:`LP_AWS_PROFILE`
   - :attr:`LP_CONTAINER`
   - :attr:`LP_VENV`
   - :attr:`LP_NODE_VENV`
   - :attr:`LP_PERL_VENV`
   - :attr:`LP_RUBY_VENV`
   - :attr:`LP_TFSPACE`
   - :attr:`LP_KUBECONTEXT`
   - :attr:`LP_CMAKE`

   .. versionadded:: 2.2

.. function:: _lp_dirstack_color() -> var:lp_dirstack_color

    Returns :func:`_lp_dirstack`, prefixed with :attr:`LP_MARK_DIRSTACK`, all
    colored with :attr:`LP_COLOR_DIRSTACK`.

    .. versionadded:: 2.0

.. function:: _lp_disk_color() -> var:lp_disk_color

   Returns information about available space of the hard drive hosting the
   current directory.

   If :attr:`LP_ALWAYS_DISPLAY_VALUES` is ``false``, displays a colored mark
   (using :attr:`LP_MARK_DISK`), if the available disk space goes below
   :attr:`LP_DISK_THRESHOLD` or :attr:`LP_DISK_THRESHOLD_PERC`.
   If it is ``true``, displays the corresponding value, either as a percentage
   (if :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` is ``true``) or as a
   human-readable quantity (if :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` is
   ``false``).

   The mark and the value itself are colored with :attr:`LP_COLOR_DISK`, while
   the unit is colored with :attr:`LP_COLOR_DISK_UNITS`.

   .. versionadded:: 2.2

.. function:: _lp_env_vars_color() -> var:lp_env_vars_color

   Returns the elements of the array set by :func:`_lp_env_vars`,
   joined with the :attr:`LP_MARK_ENV_VARS_SEP` marker,
   and surrounded by :attr:`LP_MARK_ENV_VARS_OPEN`
   and :attr:`LP_MARK_ENV_VARS_CLOSE`.

   If a matching environment variable is set,
   it is colored with :attr:`LP_COLOR_ENV_VARS_SET`,
   if it is unset, it is colored with :attr:`LP_COLOR_ENV_VARS_UNSET`.

   See also :attr:`LP_ENV_VARS`.

   .. versionadded:: 2.2

.. function:: _lp_error_color() -> var:lp_error_color

   Returns :func:`_lp_error` with color from :attr:`LP_COLOR_ERR`.

   .. versionadded:: 2.0

.. function:: _lp_error_meaning_color() -> var:lp_error_meaning_color

   Returns :func:`_lp_error_meaning` with color from :attr:`LP_COLOR_ERR`
   and surrounded by parentheses.

   .. versionadded:: 2.2

.. function:: _lp_hostname_color() -> var:lp_hostname_color

   Returns :func:`_lp_hostname`, with added data from :func:`_lp_chroot`.
   Color from :attr:`LP_COLOR_HOST`, :attr:`LP_COLOR_SSH`,
   ``LP_COLOR_HOST_HASH``, and :attr:`LP_COLOR_TELNET`, depending on the
   output of :func:`_lp_connection`.

   Added color from :func:`_lp_connected_display`: either
   :attr:`LP_COLOR_X11_ON` or :attr:`LP_COLOR_X11_OFF`.

   Return code is :func:`_lp_hostname` `ORed` with :func:`_lp_chroot`: both must
   return no data for :func:`_lp_hostname_color` to return no data.

   .. versionadded:: 2.0

.. function:: _lp_http_proxy_color() -> var:lp_http_proxy_color

   Returns :func:`_lp_http_proxy` with color from :attr:`LP_COLOR_PROXY`.

   .. versionadded:: 2.0

.. function:: _lp_jobcount_color() -> var:lp_jobcount_color

   Returns :func:`_lp_detached_sessions` with color from :attr:`LP_COLOR_JOB_D`
   and :func:`_lp_jobcount` with colors from :attr:`LP_COLOR_JOB_R` and
   :attr:`LP_COLOR_JOB_Z`.

   Return code is :func:`_lp_detached_sessions` `ORed` with
   :func:`_lp_jobcount`: both must return no data for :func:`_lp_jobcount_color`
   to return no data.

   .. versionchanged:: 2.0
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_kubernetes_context_color() -> var:lp_kubernetes_context_color

   Returns data from :func:`_lp_kubernetes_context`, colored with
   :attr:`LP_COLOR_KUBECONTEXT` and using mark :attr:`LP_MARK_KUBECONTEXT`.

   .. versionadded:: 2.1
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

.. function:: _lp_load_color() -> var:lp_load_color

   Returns :func:`_lp_load` with color from :attr:`LP_COLORMAP` and mark from
   :attr:`LP_MARK_LOAD`.

   Adds load value if :attr:`LP_PERCENTS_ALWAYS` is ``1``.

   .. versionchanged:: 2.0
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_node_env_color() -> var:lp_node_env_color

   Returns :func:`_lp_node_env` with color from :attr:`LP_COLOR_NODE_VENV`.

   .. versionadded:: 2.1
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

.. function:: _lp_os_color() -> var:lp_os_color

   Gather information about the Operating System.

   Any string encountered in the process may be replaced by a user-defined
   counterpart, using the :attr:`LP_MARK_OS` configuration array.

   If the string was not replaced, it is colored with a random color
   depending on its hash (see :func:`_lp_hash_color`).

   All fields gathered via the :func:`_lp_os` function
   are joined with the :attr:`LP_MARK_OS_SEP` string,
   in the following order: arch, family, kernel, distribution, codename.
   The corresponding data are returned as a single string
   via the ``lp_os_color`` variable.

   The function returns ``2`` if the user disabled the feature
   with :attr:`LP_ENABLE_OS`,
   ``1`` if no field was filled in with data,
   and ``true`` otherwise.

   .. versionadded:: 2.2

.. function:: _lp_python_env_color() -> var:lp_python_env_color

   Returns :func:`_lp_python_env` with color from :attr:`LP_COLOR_VIRTUALENV`.

   .. versionadded:: 2.0
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

.. function:: _lp_ram_color() -> var:lp_ram_color

   Returns information about available RAM.

   If :attr:`LP_ALWAYS_DISPLAY_VALUES` is ``false``, displays a colored mark
   (using :attr:`LP_MARK_RAM`), if the available ram goes below
   :attr:`LP_RAM_THRESHOLD` or :attr:`LP_RAM_THRESHOLD_PERC`.
   If it is ``true``, displays the corresponding value, either as a percentage
   (if :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` is ``true``) or as a
   human-readable quantity (if :attr:`LP_DISPLAY_VALUES_AS_PERCENTS` is
   ``false``).

   The mark and the value itself are colored with :attr:`LP_COLOR_RAM`, while
   the unit is colored with :attr:`LP_COLOR_RAM_UNITS`.

   .. versionadded:: 2.2

.. function:: _lp_perl_env_color() -> var:lp_perl_env_color

   Returns :func:`_lp_perl_env` with color from :attr:`LP_COLOR_PERL_VENV`.

   .. versionadded:: 2.2

.. function:: _lp_ruby_env_color() -> var:lp_ruby_env_color

   Returns :func:`_lp_ruby_env` with color from :attr:`LP_COLOR_RUBY_VENV`.

   .. versionadded:: 2.1
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

.. function:: _lp_runtime_color() -> var:lp_runtime_color

   Returns :func:`_lp_runtime_format` with color from :attr:`LP_COLOR_RUNTIME`.

   .. versionchanged:: 2.0
      Renamed from ``_lp_runtime``.
      Return code matches data function.
      Return method changed from stdout.

.. function:: _lp_shell_level_color() -> var:lp_shell_level_color

    Returns :func:`_lp_shell_level`, prefixed with :attr:`LP_MARK_SHLVL`, all
    colored with :attr:`LP_COLOR_SHLVL`.

    .. versionadded:: 2.1

.. function:: _lp_software_collections_color() -> var:lp_software_collections_color

   Returns :func:`_lp_software_collections` with color from
   :attr:`LP_COLOR_VIRTUALENV`.

   .. versionadded:: 2.0
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

.. function:: _lp_sudo_active_color() -> var:lp_sudo_active_color

   Returns :func:`_lp_sudo_active` with color and marks from
   :attr:`LP_COLOR_MARK_SUDO` if ``sudo`` is active, or
   ``LP_COLOR_MARK_NO_SUDO`` if not.

   Does not return ``1`` if ``sudo`` is not active, as the return string is
   still needed.

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
   .. versionchanged:: 2.2
      No longer include squared brackets, superseded by
      :attr:`LP_MARK_DEV_OPEN`, :attr:`LP_MARK_DEV_MID` and
      :attr:`LP_MARK_DEV_CLOSE`.

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

.. function:: _lp_wifi_signal_strength_color() -> var:lp_wifi_signal_strength_color

   Returns :func:`_lp_wifi_signal_strength` with color from :attr:`LP_COLORMAP`
   and mark from :attr:`LP_MARK_WIFI`.

   .. versionadded:: 2.1

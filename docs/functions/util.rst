Utility Functions
*****************

These functions are designed to be used by themes.

.. function:: _lp_as_text(string) -> stdout

   .. deprecated:: 2.1
      Use :func:`__lp_strip_escapes` instead.

   Return *string* with all shell escaped substrings removed.

.. function:: _lp_bool(variable, [code])

   .. deprecated:: 2.0

   Stores the *code* in a variable named *variable*. If *code* is not set, uses
   the last return code instead.

.. function:: __lp_bytes_to_human(bytes, [precision]) -> var:lp_bytes, var:lp_bytes_units

   Convert the given bytes into a human readable format, using binary
   multiple-byte units. E.g.: KiB instead of KB, 1024 instead of 1000.

   Precision can be 0, 1 or 2 digits. If not given, precision is two digits.

   Converted value goes into ``lp_bytes`` and its unit in ``lp_bytes_units``.

   Note that after petabytes (PiB) of data, Bash and Zsh will start failing
   at integer computations.

   .. versionadded:: 2.2

.. function:: _lp_color_map(value, scale=100) -> var:ret

   Returns a color from the configured or default color map based on *value*
   and optional *scale*.

   Values below 0 or above *scale* will be capped.

   The returned string is a fully escaped terminal formatting sequence.

.. function:: _lp_create_link(url, text) -> var:lp_link

   Adds the *url* link to the given *text*.

   See :attr:`LP_ENABLE_HYPERLINKS`.

.. function:: _lp_create_link_path(path) -> lp_link_path

   Adds a link on the given path, with the protocol scheme
   depending on the current connection type.

   If the current connection is *SSH*, adds an ``SFTP://`` URL,
   if it is *su* or *lcl* (see :func:`_lp_connection`), adds a ``file://`` one.

   See also :attr:`LP_ENABLE_HYPERLINKS` and :func:`_lp_create_link`.

.. function:: _lp_fill(left, right, [fillstring, [splitends]]) -> var:lp_fill

   Adds as much *fillstring* (e.g. spaces) between *left* and *right*,
   so as to make the resulting string the same width as the current terminal.

   If *fillstring* is omitted, it defaults to one space.

   If *fillstring* is a string with several characters
   and *splitends* is 1 (the default),
   then the final occurrence of *fillstring*
   will have its end cut, so as to fit the terminal width.

   If *fillstring* has multiple characters and *splitends* is 0,
   some spaces will be inserted after the last occurrence of *fillstring*,
   so as to match the exact width of the terminal.

  .. note:: Any escaped sequence in *fillstring* will be removed automatically.
            The end of *left* and the beginning of *right* may be used to add
            escaped sequences at the beginning and, respectively, the end of
            the filling sequence.

   If the available number of columns in the terminal is smaller than
   the width of *left* and *right* combined, then
   the function will return code 1 and set *lp_fill* to
   *left* and *right*, concatenated.

   For example, ``_lp_fill "Left part·" "·right part" "⣀⠔⠉⠢" 1`` will render
   (in a terminal being 32 characters large):

      Left part·⣀⠔⠉⠢⣀⠔⠉⠢⣀⠔⠉·right part

   .. versionadded:: 2.2

.. function:: _lp_formatted_title(title)

   Sets the theme generated title to *title*. The input is escaped using
   :func:`__lp_strip_escapes` to strip terminal formatting from being added to
   the title.

   This function will do nothing and return ``2`` if :attr:`LP_ENABLE_TITLE`
   is disabled.

   .. versionadded:: 2.0

.. function:: _lp_grep_fields(filename, delimiter, keys...) -> var:lp_grep_fields

   Parse the given filename for one key/value pairs of the form
   "<key><delimiter><value>" (e.g. "this=that") on each line. Sets an array
   containing the parsed values, for each key in the same order the function was
   called.

   .. code-block:: sh
      :caption: Example of use

      _lp_grep_fields "CMakeCache.txt" "=" "CMAKE_C_COMPILER:FILEPATH" "CMAKE_CXX_COMPILER:FILEPATH"
      cmake_c_compiler=${lp_grep_fields[_LP_FIRST_INDEX+0]-}
      cmake_cxx_compiler=${lp_grep_fields[_LP_FIRST_INDEX+1]-}

   .. note::
      Bash and Zsh are using different array indexing schemes.
      To write portable code, you should use ``_LP_FIRST_INDEX``.

   .. warning::
      It is strongly advised not to loop over the items in `lp_grep_fields`. If
      a searched key is missing in the file, its corresponding entry in the
      array will be silently skipped, and thus the indices you would expect may
      lead to unset variables. Just use explicit indexing to access the parsed
      values.

   Returns 1 if the file does not exists.

   .. versionadded:: 2.2

.. function:: _lp_hash_color(str) -> var:lp_hash_color

   Colorize the given string with a color depending on its hash. The color is
   chosen among: (green, yellow, blue, purple, cyan). Note that the red color is
   not a candidate, as it should be reserved for alerts.

   .. versionadded:: 2.2

.. function:: _lp_join(delimiter, items...) -> var:lp_join

   Join all strings in items with the given delimiter.
   Example: ``_lp_join ", " "a" "b" "c"`` will render ``lp_join="a, b, c"``

   .. versionadded:: 2.2

.. function:: _lp_raw_title(title)

   Sets the theme generated title to *title*. The input is not escaped in any
   way: if the input contains terminal formatting, use
   :func:`_lp_formatted_title` instead.

   This function will do nothing and return ``2`` if :attr:`LP_ENABLE_TITLE`
   is disabled.

   .. versionadded:: 2.0

.. function:: _lp_sb(string) -> stdout

   .. deprecated:: 2.0
      Use the return code of the source data function to determine if any
      string was returned.

   If *string* is set and not empty, returns *string* padded with an extra space
   on the right and the left.

.. function:: _lp_sl(string) -> stdout

   .. deprecated:: 2.0
      Use the return code of the source data function to determine if any
      string was returned.

   If *string* is set and not empty, returns *string* padded with an extra space
   on the left.

.. function:: _lp_sr(string) -> stdout

   .. deprecated:: 2.0
      Use the return code of the source data function to determine if any
      string was returned.

   If *string* is set and not empty, returns *string* padded with an extra space
   on the right.

.. function:: _lp_smart_mark([vcs_type], [vcs_subtype]) -> var:lp_smart_mark

   Returns a string set to the configured mark matching *vcs_type*. If
   *vcs_type* is not set, uses the value of ``lp_vcs_type`` instead.

   If the type is "git", matches *vcs_subtype* to see if the repository is of
   type VCSH or ``git-svn`` instead, and return their marks if so. If
   *vcs_subtype* is not set, uses the value of ``lp_vcs_subtype`` instead.

   .. versionchanged:: 2.1
      Added *vcs_subtype* argument.

.. function:: _lp_substitute(string, pairs_array) -> var:lp_substitute

   If the given string is found in the given array of pairs,
   return the second element of the pair for which
   the first element matches the string.

   For instance:

   .. code-block:: shell

       pairs=(
           "A" "B" # Replace A by B.
           "something" "dead pixels"
           "I see" "nothing"
       )
       _lp_substitute "something" "${pairs[@]}"
       # "$lp_substitute" == "dead pixels"

   .. versionadded:: 2.2

.. function:: _lp_title(title) -> stdout

   Not to be confused with :func:`lp_title`.

   .. deprecated:: 2.0
      Use :attr:`_lp_formatted_title` instead.

   Formats *title* with title escape codes. The input is escaped using
   :func:`__lp_strip_escapes` to strip terminal formatting from being added to
   the title. The output should be added to :envvar:`PS1` to be printed as a
   title.

   This function will do nothing if :attr:`LP_ENABLE_TITLE` is disabled.

.. function:: _lp_version_greatereq(major, minor, [patch, [string, [number]]])

   Returns true (0) if Liquid Prompt version is greater than
   or equal to the the given version.
   Returns 1 (false) if there is a *minor* or less version difference,
   and 2 (false) if it is a *major* difference.

   See also :func:`_lp_version_string`.

   .. warning:: This only supports the following input values for `strings`:
                "alpha", "beta" and "rc".

   .. versionadded:: 2.2

.. function:: _lp_version_string([major, [minor, [patch, [string, [number]]]]]) -> var:lp_version

   Formats the given version number in a version string of the form:
   "${major}.${minor}.${patch}-${string}.${number}"

   If no version is given, formats the current version number of Liquid Prompt.
   If a version number is given, *major* and *minor* are both mandatory.

   See also :func:`_lp_version_greatereq`.

   .. versionadded:: 2.2


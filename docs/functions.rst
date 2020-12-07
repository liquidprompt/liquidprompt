Functions
*********

Functions starting with ``lp`` or any other alphanumeric character are **public**
functions designed to be used by users on the command line or in their config.

Functions starting with ``_lp`` are **theme** level functions, designed to be used
by themes. These include data, theme, and utility functions.

Functions starting with ``__lp`` are **internal** functions, designed to be used
only by Liquidprompt internals. These functions should not be used by users or
themes, as they are not guaranteed to not change between versions.

.. toctree::
   :maxdepth: 1

   functions/public
   functions/data
   functions/theme
   functions/util
   functions/internal

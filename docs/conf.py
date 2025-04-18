# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
import time
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'Liquid Prompt'
copyright = '2011-%s, Liquid Prompt team' % time.strftime('%Y')
author = 'Mark Vander Stel'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx_rtd_theme',
    'sphinxcontrib.spelling',
]

# This value determines how to group the document tree into manual pages
man_pages = [
    ('functions', 'liquidprompt', 'Liquid Prompt functions', [], 3),
    ('config', 'liquidprompt', 'Liquid Prompt configuration', [], 5),
    ('theme', 'liquidprompt', 'Liquid Prompt theming', [], 7),
]

# A URL to cross-reference manpage directives
manpages_url = 'https://manpages.debian.org/{path}'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'venv', 'Thumbs.db', '.DS_Store']

highlight_language = 'shell'

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
html_theme = 'sphinx_rtd_theme'

# Adds a logo to the navbar.
html_logo = 'liquidprompt_emblem.svg'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# These paths are either relative to html_static_path
# # or fully qualified paths (eg. https://...)
html_css_files = [
     'liquid.css',
]

# linkchecker dislikes anchor tags in github links: https://github.com/sphinx-doc/sphinx/issues/9016
# breezy-vcs.org has been having intermittent dns problems ("Temporary failure in name # resolution") for a while now
linkcheck_ignore = [
        r'^https://github.com/rcaloras/bash-preexec/blob/master/README.md#install$',
        r'^https://www.breezy-vcs.org/$',
        r'^https://spaceship-prompt.sh/$',
        r'^https://dn-works.com/',
]

nitpick_ignore_regex = [
    # Environment variables are defined by external programs, so we do not
    # write documentation for them.
    ('envvar', r'.*'),
    # Our returned values are done in variables, not types.
    ('py:class', r'.*'),
]

# This is not Python code, so don't ignore Python specific things.
spelling_ignore_python_builtins=False
spelling_ignore_importable_modules=False

#!/bin/bash

file="docs/config.rst"

usage="This tool extracts the default configuration from the documentation,
so that the resulting file can be used as a preset configuration.

Usage:
    ./tools/config-from-doc.sh [--verbose] [|…|] > my_output.conf

Ex.:
    ./tools/config-from-doc.sh > default_commented.conf

It must be started from the root directory of the liquidprompt repository,
so that it finds the right documentation file.
    
By default, every key=value are commented out.
You must edit it manually to get a working configuration file.

You may enable warning about the parsing with the '--verbose' flag.
Warnings will be printed to stderr and will not appear in the output file.

The output is made so that it can be easily manipulated.
For instance if you want to get rid of comments and enable every feature:
    ./tools/config-from-doc.sh | grep '^#\S' | sed 's/=0$/=1/' > full_raw.conf
"

if [ -t 1 ]; then
    # Error if the output is a terminal
    printf 'ERROR: This script must be redirected to a file or piped.\n\n' 1>&2
    printf "%s" "$usage" 1>&2
    exit 2
fi

if [[ $# -gt 1 ]]; then
    printf "ERROR: This script does not accept more than one argument.\n\n" 1>&2
    printf "%s" "$usage" 1>&2
    exit 2
fi

verbose=0
if [[ $# -eq 1 ]]; then
    if [[ "$1" != "--verbose" ]]; then
        printf "ERROR: unknown argument: \"%s\".\n\n" "${1}" 1>&2
        printf "%s" "$usage" 1>&2
        exit 2
    else
        verbose=1
    fi
fi

printf "# This file shows the default presets configuration for Liquid Prompt.
#
# You may edit it and load it from your shell configuration file
# to have your own permanent configuration.
#
# For instance:
# source ~/whatever/my_liquidprompt.conf
# source ~/liquidprompt/liquidprompt
#
# Entries are commented out and show the default values.
# There is no need to uncomment them if you do not change
# their value from the default.
#
# Note that the file is automatically extracted from the documentation,
# but does not show all the help for each entry.
# You should refer to the full documentation to get more details,
# in the 'Config Options' section:
# https://liquidprompt.readthedocs.io/en/stable/config.html
# You can also load multiple presets files in sequence.
# See the 'contrib/presets/' directories for examples.

"

# We test for $line in the loop is here to ensure that we read the last line,
# even if the file does not ends with a \n.
# This bypass a known behavior of the C standard, not fixed in POSIX.
while IFS='' read -r line || [[ -n "$line" ]] ; do
    if [[ "$line" == *".. attribute:: LP_"* ]]; then
        att="${line##*' '}"
        IFS=' ' read -r t atype
        IFS=' ' read -r v avalue
        if [[ "$t" == ":type:" && "$v" == ":value:" ]]; then
            if [[ "$avalue" == *"lp_terminal_format"* ]]; then
                ((verbose)) && printf "WARNING: attribute %s default shows lp_terminal_format.\n" "$att" 1>&2
            fi
            IFS='' read -r # Empty line
            IFS='' read -r line
            if [[ -n "$line" ]]; then
                if [[ "$line" != *"deprecated"* ]]; then
                    doc=""
                    while [[ -n "$line" ]]; do
                        doc="${doc}"$'\n'"#${line}"
                        IFS='' read -r line
                    done
                    doc="${doc//:attr:/}" # Remove all :attr: tags.
                    doc="${doc//   / }" # Remove all triple spaces (indentations).
                    doc="${doc//\`\`/\`}" # Remove all double back ticks.
                    if [[ "${doc:0-1}" != "." ]]; then
                        ((verbose)) && printf "WARNING: doc for attribute %s do not end with a period.\n" "$att" 1>&2
                    fi

                    # Everything should be good here, we print.
                    moreinfo="https://liquidprompt.readthedocs.io/en/stable/config.html#${att}"
                    # all="#${doc}"$'\n'"# Type: ${atype}, more information: ${moreinfo}"$'\n'"#${att}=${avalue}"$'\n\n'
                    # all="${all//%/%%}" # Escape percents.
                    # printf "%s" "$all"
                    printf '%s\n# Type: %s\n# More information: %s\n#%s=%s\n' \
                        "$doc" "$atype" "$moreinfo" "$att" "$avalue"
                else
                    ((verbose)) && printf "NOTE: attribute %s is deprecated, bypass.\n" "$att" 1>&2
                fi
            else
                ((verbose)) && printf "WARNING: attribute %s does not have doc.\n" "$att" 1>&2
            fi
        else
            ((verbose)) && printf "WARNING: attribute %s does not have type or value.\n" "$att" 1>&2
        fi
    fi
done <"$file"

# vim: ft=sh et sts=4 sw=4 tw=120

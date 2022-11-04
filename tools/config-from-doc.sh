#!/bin/bash

file="../docs/config.rst"

printf "# This file shows the default presets configuration for Liquid Prompt.
#
# You may edit it and load it from your shell configuration file
# to have your own configuration.
#
# For instance:
# cp liquidprompt/liquidpromptrc-dist ~/.liquidpromptrc
#
# Then source it (from your shell config file):
# source ~/.liquidpromptrc
#
# Entries are commented out and show the default values.
# There is no need to uncomment them if you do not change
# their value from the default.
#
# Note that the file is automatically extracted from the documentation,
# but do not show all the help for each entry.
# You should refer to the full documentation to get more details:
# https://liquidprompt.readthedocs.io/ (in the 'Config Options' section).
#
# You can also load multiple presets files in sequence.
# See the 'contrib/presets/' directories for examples.

"

# We test for $line in the loop is here to ensure that we read the last line,
# even if the file does not ends with a \n.
# This bypass a known behavior of the C standard, not fixed in POSIX.
attributes=()
while IFS='' read -r line || [[ -n "$line" ]] ; do
    if [[ "$line" == *".. attribute:: LP_"* ]]; then
        att="${line##*' '}"
        IFS=' ' read -r t atype
        IFS=' ' read -r v avalue
        if [[ "$t" == ":type:" && "$v" == ":value:" ]]; then
            if [[ "$avalue" == *"lp_terminal_format"* ]]; then
                printf "WARNING: attribute $att default shows lp_terminal_format.\n" 1>&2
            fi
            IFS='' read -r # Empty line
            IFS='' read -r line
            if [[ -n "$line" ]]; then
                if [[ "$line" != *"deprecated"* ]]; then 
                    doc="$line"
                    while [[ "$line" != "" ]]; do
                        IFS='' read -r line
                        doc="${doc}${line}"
                    done
                    doc="${doc//:attr:/}" # Remove all :attr: tags.
                    doc="${doc//   / }" # Remove all triple saces (indentations).
                    doc="${doc//\`\`/\`}" # Remove all double back ticks.
                    if [[ "${doc:0-1}" != "." ]]; then
                        printf "WARNING: doc for attribute $att do not end with a period.\n" 1>&2
                    fi

                    # Everything should be good here, we print.
                    moreinfo="https://liquidprompt.readthedocs.io/en/stable/config.html#${att}"
                    all="#${doc}\n# Type: ${atype}, more information: ${moreinfo}\n#${att}=${avalue}\n\n"
                    all="${all//%/%%}" # Escape percents.
                    printf "$all"
                else
                    printf "NOTE: attribute $att is deprecated, bypass.\n" 1>&2
                fi
            else
                printf "WARNING: attribute $att does not have doc.\n" 1>&2
            fi
        else
            printf "WARNING: attribute $att does not have type or value.\n" 1>&2
        fi
    fi
done <"$file"

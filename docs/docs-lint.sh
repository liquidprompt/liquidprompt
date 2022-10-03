#!/bin/sh

error=0

# Error on warnings and turn on nitpicky mode.
make dummy SPHINXOPTS="-b spelling -W --keep-going -n" || error=1
make linkcheck || error=1

exit "$error"

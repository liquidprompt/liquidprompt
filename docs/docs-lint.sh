#!/bin/sh

error=0

# Error on warnings and turn on nitpicky mode.
# Output the HTML so we can check it for leaked RST.
make html SPHINXOPTS="-W --keep-going -n" || error=1

make spelling SPHINXOPTS="-W --keep-going" || error=1

sphinx-lint \
  --ignore venv/ \
  --enable all \
  --disable default-role \
  || error=1

make linkcheck || error=1

exit "$error"

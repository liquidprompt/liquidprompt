#!/bin/bash
set -u

height="${1-300}"
shift
enough=4 # Sleep time in seconds.
emulator="terminator"
geometry="--geometry=1250x$height"
title="--title"
command="--command"
more="--profile=LPscreen"

# If a theme was given, us3 the theme and source all other arguments.
if [[ -z "${1-}" || "$1" == --help ]]; then
  printf '
Usage: %s theme [sourced files...]

Outputs a screenshot of example prompts based on a standard set of input conditions.
Should be run from the Liquid Prompt root directory.
Outputs a binary PNG file on standard output, thus should be redirected to a file.

Example usage: %s unfold themes/unfold/unfold.theme contrib/presets/colors/256-colors-dark.conf > unfold.png

If you see an error "no window with specified ID exists", try increasing the "enough" parameter.
May only work under an X11 graphical server, depending on your ImageMagick configuration.
' "$0" "$0"
  exit 2
fi

# Generate a random ID to ensure recognizing the window.
rid="LP_$(xxd -l 8 -ps /dev/urandom)"

# Default security policy of ImageMagick is to disable printing on standard output,
# so we are forced to pass by a temporary file.
tmp="$(mktemp --suffix=.png tmp_XXXXXXXXXX)"

# Open a window for some seconds and take a screenshot after some seconds.
$emulator $geometry $title $rid $more $command "$(dirname $0)/theme-preview.sh $* ; sleep $enough" & (sleep $enough ; import -window $rid $tmp)

# Output the binary on stdout.
cat $tmp

rm -f $tmp


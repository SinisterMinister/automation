#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "DIGESTS=\(.digests) ANSWERS=\(.answers)"')"

OUTPUT=`echo "$DIGESTS $ANSWERS" | jq -n 'reduce inputs as $in (null; . + $in)'`

jq -n --arg output "$OUTPUT" '.output = $output'
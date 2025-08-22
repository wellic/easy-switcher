#!/usr/bin/env bash

set -uEeo pipefail
#set -x

value=$1
files_codes=${2:-codes.txt}

echo
cat $files_codes | grep "$value"
echo
echo "Whole word:"
cat $files_codes | grep -w "$value"
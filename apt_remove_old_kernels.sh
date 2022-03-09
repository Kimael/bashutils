#!/bin/bash
# 
# Requires: apt, awk
# 
# Run this script without any param for a dry run.
# 
# Run the script with 'root' user
# and with 'exec' param for removing old kernels
# after checking the list printed in the dry run
# 
# TODO remove awk dependency, probably by using 'cut'... (?)
# TODO make it work with '/bin/sh' instead of '/bin/bash'

echo 'Uname raw result:'
uname -a
echo

IN_USE=$(uname -a | awk '{ print $3 }')
echo 'Your in use kernel is '${IN_USE}
echo

OLD_KERNELS=$(
    dpkg --list |
        grep -v "${IN_USE}" |
        grep -Ei 'linux-image|linux-headers|linux-modules' |
        awk '{ print $2 }'
)
echo 'Old Kernels to be removed:'
echo ${OLD_KERNELS}
echo

if [ "$1" == 'exec' ]; then
    for CUR_PACKAGE in ${OLD_KERNELS}
    do
        yes | apt purge "${CUR_PACKAGE}"
    done
fi

echo 'THE END.'
echo

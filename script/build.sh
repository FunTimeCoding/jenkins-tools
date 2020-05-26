#!/bin/sh -e

rm -rf build
script/check.sh --ci-mode
script/measure.sh --ci-mode
script/test.sh --ci-mode
#SYSTEM=$(uname)
#
# TODO: Needs polish.
#if [ "${SYSTEM}" = Linux ]; then
#    script/debian/package.sh
#    script/docker/build.sh
#fi

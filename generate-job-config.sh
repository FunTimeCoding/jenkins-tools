#!/bin/sh -e

# shellcheck disable=SC2016
jjm --locator https://github.com/FunTimeCoding/jenkins-tools.git --build-command 'export PATH="${HOME}/.cabal/bin:${HOME}/.local/bin:/usr/local/bin:${PATH}"
./build.sh' > job.xml

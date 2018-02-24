#!/bin/sh -e

# shellcheck disable=SC2016
jjm --locator https://github.com/FunTimeCoding/jenkins-tools.git --build-command script/build.sh --checkstyle 'build/log/checkstyle-*.xml' --recipients funtimecoding@gmail.com > job.xml

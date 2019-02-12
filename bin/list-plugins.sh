#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
JENKINS_PLUGINS_CACHE=/tmp/jenkins-plugins-cache.txt

if [ ! -f ${JENKINS_PLUGINS_CACHE} ] || [ ! "$(find ${JENKINS_PLUGINS_CACHE} -mmin +2)" = '' ]; then
    ${JENKINS} list-plugins > "${JENKINS_PLUGINS_CACHE}"
fi

cat ${JENKINS_PLUGINS_CACHE}

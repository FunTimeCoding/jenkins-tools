#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
validate_cli
JENKINS_PLUGINS_CACHE="/tmp/jenkins-plugins-cache.txt"

if [ ! -f ${JENKINS_PLUGINS_CACHE} ] || [ "$(find ${JENKINS_PLUGINS_CACHE} -mmin +2)" = "" ]; then
    ${JENKINS_CMD} list-plugins > "${JENKINS_PLUGINS_CACHE}"
fi

cat ${JENKINS_PLUGINS_CACHE}

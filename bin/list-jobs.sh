#!/bin/sh -e

DIR=$(dirname "${0}")
SCRIPT_DIR=$(cd "${DIR}"; pwd)

usage()
{
    echo "Local usage: ${0}"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
${JENKINS_CMD} list-jobs

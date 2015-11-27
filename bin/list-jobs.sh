#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0}"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
${JENKINS_CMD} list-jobs

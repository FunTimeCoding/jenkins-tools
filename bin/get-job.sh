#!/bin/sh -e

DIR=$(dirname "${0}")
SCRIPT_DIR=$(cd "${DIR}"; pwd)

usage()
{
    echo "Local usage: ${0} NAME"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth

if [ "${1}" = "" ]; then
    usage
    exit 1
fi

NAME="${1}"
${JENKINS_CMD} get-job "${NAME}"

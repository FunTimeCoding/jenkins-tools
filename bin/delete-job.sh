#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

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
${JENKINS_CMD} delete-job "${NAME}"

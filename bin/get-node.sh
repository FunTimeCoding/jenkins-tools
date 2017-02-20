#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} NODE_NAME [OUTPUT_FILE]"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
NODE_NAME="${1}"
OUTPUT_FILE="${2}"

if [ "${NODE_NAME}" = "" ]; then
    usage

    exit 1
fi

if [ "${OUTPUT_FILE}" = "" ]; then
    ${JENKINS_COMMAND} get-node "${NODE_NAME}"
    echo
else
    ${JENKINS_COMMAND} get-node "${NODE_NAME}" > "${OUTPUT_FILE}"
    echo >> "${OUTPUT_FILE}"
fi

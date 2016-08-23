#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME [OUTPUT_FILE]"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
JOB_NAME="${1}"
OUTPUT_FILE="${2}"

if [ "${JOB_NAME}" = "" ]; then
    usage

    exit 1
fi

if [ "${OUTPUT_FILE}" = "" ]; then
    ${JENKINS_COMMAND} get-job "${JOB_NAME}"
    echo
else
    ${JENKINS_COMMAND} get-job "${JOB_NAME}" > "${OUTPUT_FILE}"
    echo >> "${OUTPUT_FILE}"
fi

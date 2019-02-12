#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME [OUTPUT_FILE]"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
JOB_NAME="${1}"
OUTPUT_FILE="${2}"

if [ "${JOB_NAME}" = '' ]; then
    usage

    exit 1
fi

# This condition exists to ensure a new line at end of file.
if [ "${OUTPUT_FILE}" = '' ]; then
    ${JENKINS} get-job "${JOB_NAME}"
    echo
else
    ${JENKINS} get-job "${JOB_NAME}" > "${OUTPUT_FILE}"
    echo >> "${OUTPUT_FILE}"
fi

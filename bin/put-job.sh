#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME JOB_CONFIGURATION"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
JOB_NAME="${1}"
JOB_CONFIGURATION="${2}"

if [ "${JOB_NAME}" = '' ] || [ "${JOB_CONFIGURATION}" = '' ]; then
    usage

    exit 1
fi

if [ ! -f "${JOB_CONFIGURATION}" ]; then
    echo "Configuration not found: ${JOB_CONFIGURATION}"

    exit 1
fi

${JENKINS} create-job "${JOB_NAME}" < "${JOB_CONFIGURATION}"

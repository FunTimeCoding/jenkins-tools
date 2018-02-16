#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME JOB_CONFIG"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
JOB_NAME="${1}"
JOB_CONFIG="${2}"

if [ "${JOB_NAME}" = "" ] || [ "${JOB_CONFIG}" = "" ]; then
    usage

    exit 1
fi

if [ ! -f "${JOB_CONFIG}" ]; then
    echo "Config not found: ${JOB_CONFIG}"

    exit 1
fi

${JENKINS} create-job "${JOB_NAME}" < "${JOB_CONFIG}"

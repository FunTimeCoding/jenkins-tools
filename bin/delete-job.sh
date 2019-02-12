#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
JOB_NAME="${1}"

if [ "${JOB_NAME}" = '' ]; then
    usage

    exit 1
fi

${JENKINS} delete-job "${JOB_NAME}"

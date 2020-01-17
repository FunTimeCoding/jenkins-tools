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

curl --insecure --silent --user "${USERNAME}:${PASSWORD}" "https://${HOST_NAME}/job/${JOB_NAME}/api/json" | jq --raw-output .jobs[].name | sort

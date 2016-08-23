#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} NAME"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
NAME="${1}"

if [ "${NAME}" = "" ]; then
    usage

    exit 1
fi

${JENKINS_COMMAND} get-job "${NAME}"
echo

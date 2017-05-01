#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} NODE_NAME"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
NODE_NAME="${1}"

if [ "${NODE_NAME}" = "" ]; then
    usage

    exit 1
fi

${JENKINS} delete-node "${NODE_NAME}"

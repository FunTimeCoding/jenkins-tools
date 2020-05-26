#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)

usage() {
    echo "Local usage: ${0} NODE_NAME [REASON]"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
NODE_NAME="${1}"
REASON="${2}"

if [ "${NODE_NAME}" = '' ]; then
    usage

    exit 1
fi

if [ "${REASON}" = '' ]; then
    ${JENKINS} offline-node "${NODE_NAME}"
else
    ${JENKINS} offline-node "${NODE_NAME}" -m "${REASON}"
fi

echo

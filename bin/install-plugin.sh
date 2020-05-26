#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)

usage() {
    echo "Local usage: ${0} PLUGIN_NAME"
}

PLUGIN_NAME="${1}"

if [ "${PLUGIN_NAME}" = '' ]; then
    usage

    exit 1
fi

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
${JENKINS} install-plugin "${PLUGIN_NAME}"

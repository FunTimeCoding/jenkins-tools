#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
UPDATE_LIST=$(${JENKINS} list-plugins | grep -e ')$' | awk '{ print $1 }')

if [ -z "${UPDATE_LIST}" ]; then
    echo "All plugins up to date."

    exit 0
else
    echo "Outdated plugins:"
    echo "${UPDATE_LIST}"
fi

echo "Updating plugins."
${JENKINS} install-plugin "${UPDATE_LIST}"
echo "Restarting."
${JENKINS} safe-restart

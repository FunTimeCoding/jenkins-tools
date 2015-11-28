#!/bin/sh -e

DIR=$(dirname "${0}")
SCRIPT_DIR=$(cd "${DIR}"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
validate_cli
UPDATE_LIST=$(${JENKINS_CMD} list-plugins | grep -e ')$' | awk '{ print $1 }')

if [ -z "${UPDATE_LIST}" ]; then
    echo "All plugins up to date."

    exit 0
else
    echo "Outdated plugins:"
    echo "${UPDATE_LIST}"
fi

jenkins_auth
echo "Updating plugins."
${JENKINS_CMD} install-plugin "${UPDATE_LIST}"
echo "Restarting."
${JENKINS_CMD} safe-restart

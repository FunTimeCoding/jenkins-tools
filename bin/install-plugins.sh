#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth

# shellcheck disable=SC2153
for PLUGIN in ${PLUGINS}; do
    ${JENKINS_COMMAND} install-plugin "${PLUGIN}"
done

echo "Restarting."
${JENKINS_COMMAND} safe-restart

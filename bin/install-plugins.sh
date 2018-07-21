#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"

# shellcheck disable=SC2153
for PLUGIN in ${PLUGINS}; do
    ${JENKINS} install-plugin "${PLUGIN}"
done

echo "Restarting."
${JENKINS} safe-restart

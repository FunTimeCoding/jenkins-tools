#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
# warnings log-parser cobertura rubyMetrics nodejs
${JENKINS_COMMAND} install-plugin git gravatar robot php embeddable-build-status gitlab-hook disk-usage greenballs
echo "Restarting."
${JENKINS_COMMAND} safe-restart

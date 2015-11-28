#!/bin/sh -e

DIR=$(dirname "${0}")
SCRIPT_DIR=$(cd "${DIR}"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
# warnings log-parser cobertura rubyMetrics nodejs
${JENKINS_CMD} install-plugin git gravatar robot php embeddable-build-status gitlab-hook disk-usage greenballs
echo "Restarting."
${JENKINS_CMD} safe-restart

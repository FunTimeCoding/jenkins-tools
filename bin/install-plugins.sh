#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
#${JENKINS_CMD} install-plugin git disk-usage warnings log-parser gravatar gitlab-hook cobertura rubyMetrics robot php nodejs
${JENKINS_CMD} install-plugin git gravatar robot php
echo "Restarting."
${JENKINS_CMD} safe-restart

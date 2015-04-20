#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"

if [ -f "${JENKINS_CLI}" ]; then
    echo "File ${JENKINS_CLI} already exists."
    exit 1
fi

# Catching fails with "|| true" to determine what went wrong later.
wget "${JENKINS_URL}/jnlpJars/jenkins-cli.jar" -O "${JENKINS_CLI}" > /dev/null 2>&1 || true

if [ ! -f "${JENKINS_CLI}" ]; then
    echo "File ${JENKINS_CLI} could not be downloaded."
    exit 1
fi

if [ ! -s "${JENKINS_CLI}" ]; then
    echo "File ${JENKINS_CLI} is empty. Removing it to attempt to re-download it next time."
    rm "${JENKINS_CLI}"
    exit 1
fi

echo "Download successful."
exit 0

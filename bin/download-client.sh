#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"

if [ -f "${JENKINS_CLIENT}" ]; then
    echo "File ${JENKINS_CLIENT} already exists."

    exit 1
fi

LOCATOR="${JENKINS_LOCATOR}/jnlpJars/jenkins-cli.jar"

# Catching fails with "|| true" to determine what went wrong later.
wget --no-check-certificate --output-document "${JENKINS_CLIENT}" "${LOCATOR}" > /dev/null 2>&1 || true

if [ ! -f "${JENKINS_CLIENT}" ]; then
    echo "File ${JENKINS_CLIENT} could not be downloaded."

    exit 1
fi

if [ ! -s "${JENKINS_CLIENT}" ]; then
    echo "File ${JENKINS_CLIENT} was empty."
    rm "${JENKINS_CLIENT}"

    exit 1
fi

echo "Download successful."

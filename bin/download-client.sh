#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"

if [ -f "${JENKINS_CLIENT}" ]; then
    echo "File ${JENKINS_CLIENT} already exists."

    exit 1
fi

LOCATOR="${JENKINS_LOCATOR}/jnlpJars/jenkins-cli.jar"

if [ "${VERBOSE}" = true ]; then
    echo "Download ${LOCATOR}."
fi

# Catching fails with "|| true" to determine what went wrong later.
wget "${LOCATOR}" -O "${JENKINS_CLIENT}" > /dev/null 2>&1 || true

if [ ! -f "${JENKINS_CLIENT}" ]; then
    echo "File ${JENKINS_CLIENT} could not be downloaded."

    exit 1
fi

if [ ! -s "${JENKINS_CLIENT}" ]; then
    echo "File ${JENKINS_CLIENT} is empty. Deleted it to attempt to re-download it next time."
    rm "${JENKINS_CLIENT}"

    exit 1
fi

echo "Download successful."

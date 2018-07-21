#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} REPOSITORY_LOCATOR"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
REPOSITORY_LOCATOR="${1}"

if [ "${REPOSITORY_LOCATOR}" = "" ]; then
    usage

    exit 1;
fi

echo "REPOSITORY_LOCATOR: ${REPOSITORY_LOCATOR}"
JOB_NAME="${REPOSITORY_LOCATOR##*/}"
JOB_NAME="${JOB_NAME%.git}"
echo "JOB_NAME: ${JOB_NAME}"
jjm -u "${REPOSITORY_LOCATOR}" > "${JOB_NAME}.xml"
http --auth "${USERNAME}:${PASSWORD}" POST "https://${HOST_NAME}/createItem?name=${JOB_NAME}" "@${JOB_NAME}.xml"

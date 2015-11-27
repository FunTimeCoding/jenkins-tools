#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0} REPO_URL"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
validate_cli
REPO_URL="${1}"

if [ "${REPO_URL}" = "" ]; then
    usage
    exit 1;
fi

echo "REPO_URL: ${REPO_URL}"
JOB_NAME="${REPO_URL##*/}"
JOB_NAME="${JOB_NAME%.git}"
echo "JOB_NAME: ${JOB_NAME}"
jjm -u "${REPO_URL}" > "${JOB_NAME}.xml"
http --auth "${USERNAME}:${PASSWORD}" POST "${JENKINS_LOCATOR}/createItem?name=${JOB_NAME}" "@${JOB_NAME}.xml"

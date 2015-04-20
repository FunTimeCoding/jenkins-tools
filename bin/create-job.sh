#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME REPO_URL"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
validate_cli
JOB_NAME="${1}"

if [ "${JOB_NAME}" = "" ]; then
    usage
    exit 1;
fi

REPO_URL="${2}"

if [ "${REPO_URL}" = "" ]; then
    usage
    exit 1;
fi

jjm -t git -u "${REPO_URL}" > "${JOB_NAME}.xml"
http --auth "${USER}:${PASSWORD}" POST "${JENKINS_URL}/createItem?name=${JOB_NAME}" "@${JOB_NAME}.xml"

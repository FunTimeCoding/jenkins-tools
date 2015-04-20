#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0} JOB_CONFIG"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth

if [ "${1}" = "" ]; then
    usage
    exit 1
fi

JOB_CONFIG=$(${REALPATH_CMD} "${1}")

if [ ! -f "${JOB_CONFIG}" ]; then
    echo "Config not found: ${JOB_CONFIG}"
    exit 1
fi

JOB_NAME="${JOB_CONFIG##*/}"
JOB_NAME="${JOB_NAME%.*}"
${JENKINS_CMD} create-job "${JOB_NAME}" < "${JOB_CONFIG}"

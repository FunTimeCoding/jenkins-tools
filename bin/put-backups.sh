#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0} [BACKUP_DIR]"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
BACKUP_DIR="${1}"

if [ "${BACKUP_DIR}" = "" ]; then
    BACKUP_DIR="job-backups"
fi

FILES=$(find ${BACKUP_DIR} -type f)

for FILE in ${FILES}; do
    JOB_CONFIG=$(${REALPATH_CMD} "${FILE}")
    JOB_NAME="${JOB_CONFIG##*/}"
    JOB_NAME="${JOB_NAME%.*}"
    echo "Create job: ${JOB_NAME}"
    ${JENKINS_CMD} create-job "${JOB_NAME}" < "${JOB_CONFIG}"
done

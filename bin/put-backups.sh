#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} [BACKUP_DIR]"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
BACKUP_DIR="${1}"

if [ "${BACKUP_DIR}" = "" ]; then
    BACKUP_DIR="job-backups"
fi

FILES=$(find ${BACKUP_DIR} -type f)

for FILE in ${FILES}; do
    JOB_CONFIG=$(${REALPATH_COMMAND} "${FILE}")
    JOB_NAME="${JOB_CONFIG##*/}"
    JOB_NAME="${JOB_NAME%.*}"
    echo "Create job: ${JOB_NAME}"
    ${JENKINS_COMMAND} create-job "${JOB_NAME}" < "${JOB_CONFIG}"
done

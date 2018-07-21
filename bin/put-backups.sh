#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} [BACKUP_DIRECTORY]"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
BACKUP_DIRECTORY="${1}"

if [ "${BACKUP_DIRECTORY}" = "" ]; then
    BACKUP_DIRECTORY=job-backups
fi

FILES=$(find ${BACKUP_DIRECTORY} -type f)

for FILE in ${FILES}; do
    JOB_NAME="${FILE##*/}"
    JOB_NAME="${JOB_NAME%.*}"
    echo "Create job: ${JOB_NAME}"
    ${JENKINS} create-job "${JOB_NAME}" < "${FILE}"
done

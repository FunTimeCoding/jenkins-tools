#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0} BACKUP_DIR"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
JOBS=$(${JENKINS_CMD} list-jobs)
BACKUP_DIR="${1}"

if [ "${BACKUP_DIR}" = "" ]; then
    BACKUP_DIR="job-backups"
fi

BACKUP_DIR=$(${REALPATH_CMD} ${BACKUP_DIR})
mkdir -p "${BACKUP_DIR}"
echo "Backup will be stored in: ${BACKUP_DIR}"

for JOB in ${JOBS}; do
    BACKUP_DEST="${BACKUP_DIR}/${JOB}.xml"
    if [ ! -f "${BACKUP_DEST}" ]; then
        echo "Downloading config: ${JOB}"
        ${JENKINS_CMD} get-job "${JOB}" > "${BACKUP_DEST}"
        if [ ! -s "${BACKUP_DEST}" ]; then
            echo "File ${BACKUP_DEST} is empty. Removing it to attempt to re-download it next time."
            rm "${BACKUP_DEST}"
            exit 1
        fi
    else
        echo "Skipping job: ${JOB} since backup file already exists."
    fi
done

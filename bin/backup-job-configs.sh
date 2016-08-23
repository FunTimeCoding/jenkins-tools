#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} BACKUP_DIRECTORY"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
JOBS=$(${JENKINS_COMMAND} list-jobs)
BACKUP_DIRECTORY="${1}"

if [ "${BACKUP_DIRECTORY}" = "" ]; then
    BACKUP_DIRECTORY=job-backups
fi

BACKUP_DIRECTORY=$(${REALPATH_COMMAND} ${BACKUP_DIRECTORY})
mkdir -p "${BACKUP_DIRECTORY}"
echo "Backup will be stored in: ${BACKUP_DIRECTORY}"

for JOB in ${JOBS}; do
    BACKUP_DESTINATION="${BACKUP_DIRECTORY}/${JOB}.xml"

    if [ ! -f "${BACKUP_DESTINATION}" ]; then
        echo "Downloading config: ${JOB}"
        ${JENKINS_COMMAND} get-job "${JOB}" > "${BACKUP_DESTINATION}"

        if [ ! -s "${BACKUP_DESTINATION}" ]; then
            echo "File ${BACKUP_DESTINATION} is empty. Removing it to attempt to re-download it next time."
            rm "${BACKUP_DESTINATION}"
            exit 1
        fi
    else
        echo "Skipping job: ${JOB} since backup file already exists."
    fi
done

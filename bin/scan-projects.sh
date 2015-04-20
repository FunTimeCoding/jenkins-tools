#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
JOBS=$(${JENKINS_CMD} list-jobs)
PROJECTS=$(ls "${PROJECT_DIR}")

for PROJECT in ${PROJECTS}; do
    JOB_FOUND=0

    for JOB in ${JOBS}; do
        if [ "${PROJECT}" = "${JOB}" ]; then
            JOB_FOUND=1
        fi
    done

    if [ "${JOB_FOUND}" = "0" ]; then
        echo "Without CI job: ${PROJECT}"
    else
        echo "With CI job: ${PROJECT}"
    fi
done

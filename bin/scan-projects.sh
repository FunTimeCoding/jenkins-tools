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
            break
        fi
    done

    DIR="${PROJECT_DIR}/${PROJECT}"
    cd "${DIR}"

    echo "${PROJECT}"

    if [ "${JOB_FOUND}" = "0" ]; then
        echo "- does not have a CI job"
    fi

    if [ -d ".git" ]; then
        REMOTES=$(git remote -v)

        if [ "${REMOTES}" = ""  ]; then
            echo "- has no git remote"
        else
            URL=$(echo ${REMOTES} | awk '{ print $2 }')
            REPO="${URL##*/}"
            REPO="${REPO%.git}"

            if [ ! "${REPO}" = "${PROJECT}" ]; then
                echo "- name differs locally and in CI"
            fi
        fi
    else
        echo "- is not a git repository"
    fi
done

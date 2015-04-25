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

    if [ "${JOB_FOUND}" = "1" ]; then
        echo "${PROJECT} has a CI job."
        continue
    fi

    DIR="${PROJECT_DIR}/${PROJECT}"
    cd "${DIR}"

    if [ ! -d ".git" ]; then
        echo "${PROJECT} is not a git repository."
        continue
    fi

    REMOTES=$(git remote -v)

    if [ "${REMOTES}" = ""  ]; then
        echo "${PROJECT} has no git remote."
        continue
    fi

    URL=$(echo ${REMOTES} | awk '{ print $2 }')
    REPO="${URL##*/}"
    REPO="${REPO%.git}"

    if [ ! "${REPO}" = "${PROJECT}" ]; then
        echo "${PROJECT} name differs locally and in CI."
        continue
    fi

    if [ ! -f "build.sh" ] && [ ! -f "build.xml" ]; then
        echo "${PROJECT} has no build script."
        continue
    fi

    echo "${PROJECT} does not have a CI job. Create one? (y)es/(n)o/(a)bort"
    read OPT
    case ${OPT} in
        y)
            echo "Creating job."
            "${SCRIPT_DIR}/../bin/create-job.sh ${PROJECT} ${URL}"
            ;;
        n)
            echo "Not creating a job."
            ;;
        a)
            echo "Aborted project scan."
            exit 0
            ;;
        *)
            echo "Invalid input, skipped."
            ;;
    esac
done

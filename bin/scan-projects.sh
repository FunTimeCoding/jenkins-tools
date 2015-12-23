#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
jenkins_auth
JOBS=$(${JENKINS_COMMAND} list-jobs)
PROJECTS=$(ls "${PROJECT_DIRECTORY}")

for PROJECT in ${PROJECTS}; do
    JOB_FOUND=0

    for JOB in ${JOBS}; do
        if [ "${PROJECT}" = "${JOB}" ]; then
            JOB_FOUND=1
            break
        fi
    done

    if [ "${JOB_FOUND}" = "1" ]; then
        echo "OK ${PROJECT}"
        continue
    fi

    SUB_DIRECTORY="${PROJECT_DIRECTORY}/${PROJECT}"
    cd "${SUB_DIRECTORY}" || exit 1

    if [ ! -d ".git" ]; then
        echo "!! ${PROJECT} is no git repository."
        continue
    fi

    REMOTES=$(git remote -v)

    if [ "${REMOTES}" = ""  ]; then
        echo "!! ${PROJECT} has no git remote."
        continue
    fi

    URL=$(echo "${REMOTES}" | awk '{ print $2 }')
    REPO="${URL##*/}"
    REPO="${REPO%.git}"

    if [ ! "${REPO}" = "${PROJECT}" ]; then
        echo "!! ${PROJECT} name differs locally and in CI."
        continue
    fi

    if [ ! -f "build.sh" ] && [ ! -f "build.xml" ]; then
        echo "!! ${PROJECT} has no build script."
        continue
    fi

    echo "!! ${PROJECT} has no CI job. Create one? y/n"
    read -r OPT

    case ${OPT} in
        y)
            echo "Creating job."
            "${SCRIPT_DIRECTORY}/create-job.sh ${PROJECT} ${URL}"
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

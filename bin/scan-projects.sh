#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
jenkins_auth
JOBS=$(${JENKINS_CMD} list-jobs)
PROJECTS=$(ls "${PROJECT_DIR}")

for PROJECT in ${PROJECTS}; do
    JOB_FOUND=0
    NAME_DIFFERS=0
    NO_GIT_REPO=0
    NO_GIT_REMOTE=0

    for JOB in ${JOBS}; do
        if [ "${PROJECT}" = "${JOB}" ]; then
            JOB_FOUND=1
            break
        fi
    done

    DIR="${PROJECT_DIR}/${PROJECT}"
    cd "${DIR}"

    if [ -d ".git" ]; then
        REMOTES=$(git remote -v)

        if [ "${REMOTES}" = ""  ]; then
            NO_GIT_REMOTE=1
            echo "${PROJECT} has no git remote."
        else
            URL=$(echo ${REMOTES} | awk '{ print $2 }')
            REPO="${URL##*/}"
            REPO="${REPO%.git}"

            if [ ! "${REPO}" = "${PROJECT}" ]; then
                NAME_DIFFERS=1
                echo "${PROJECT} name differs locally and in CI."
            fi
        fi
    else
        NO_GIT_REPO=1
        echo "${PROJECT} is not a git repository."
    fi

    if [ "${JOB_FOUND}" = "0" ] && [ "${NAME_DIFFERS}" = "0" ] && [ "${NO_GIT_REPO}" = "0" ] && [ "${NO_GIT_REMOTE}" = "0" ]; then
        echo "${PROJECT} does not have a CI job. Create one? (y)es/(n)o/(a)bort"
        read OPT
        case ${OPT} in
            y)
                echo "Creating job."

                if [ -f "build.xml" ]; then
                    echo "Project has an ant build script."
                elif [ -f "build.sh" ]; then
                    echo "Project has a shell build script."
                    "${SCRIPT_DIR}/../bin/create-job.sh ${PROJECT} ${URL}"
                else
                    echo "No supported build script found."
                fi
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
    fi
done

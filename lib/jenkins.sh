#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
CONFIG=""

function_exists()
{
    # shellcheck disable=SC2039
    declare -f -F "${1}" > /dev/null

    return $?
}

while true; do
    case ${1} in
        --config)
            CONFIG=${2-}
            shift 2
            ;;
        --help)
            echo "Global usage: [--help][--config CONFIG]"
            function_exists usage && usage

            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            # TODO: Consider getting valid options from executable scripts or remove this.
            #if [ ! "${1}" = "" ]; then
            #    echo "Unknown option: ${1}"
            #fi
            break
            ;;
    esac
done

OPTIND=1

if [ "${CONFIG}" = "" ]; then
    CONFIG="${HOME}/.jenkins-tools.conf"
fi

if [ ! "$(command -v realpath 2>&1)" = "" ]; then
    REALPATH_COMMAND=realpath
else
    if [ ! "$(command -v grealpath 2>&1)" = "" ]; then
        REALPATH_COMMAND=grealpath
    else
        echo "Required tool (g)realpath not found."

        exit 1
    fi
fi

CONFIG=$(${REALPATH_COMMAND} "${CONFIG}")

if [ ! -f "${CONFIG}" ]; then
    echo "Config missing: ${CONFIG}"

    exit 1
fi

# shellcheck source=/dev/null
. "${CONFIG}"

if [ "${USERNAME}" = "" ]; then
    echo "USERNAME not set."

    exit 1
fi

if [ "${PASSWORD}" = "" ]; then
    echo "PASSWORD not set."

    exit 1
fi

if [ "${NAME}" = "" ]; then
    echo "NAME not set."

    exit 1
fi

if [ "${MAIL}" = "" ]; then
    echo "MAIL not set."

    exit 1
fi

if [ "${JENKINS_CLIENT}" = "" ]; then
    PROJECT_ROOT="${SCRIPT_DIRECTORY}/.."
    PROJECT_ROOT=$(${REALPATH_COMMAND} "${PROJECT_ROOT}")
    JENKINS_CLIENT="${PROJECT_ROOT}/jenkins-cli.jar"
fi

if [ "${JENKINS_LOCATOR}" = "" ]; then
    JENKINS_LOCATOR="http://localhost:8080"
fi

if [ ! "${SSH_KEY}" = "" ]; then
    # TODO: Remove the noCertificateCheck argument.
    JENKINS_COMMAND="java -jar ${JENKINS_CLIENT} -s ${JENKINS_LOCATOR} -i ${SSH_KEY} -noCertificateCheck"
else
    JENKINS_COMMAND="java -jar ${JENKINS_CLIENT} -s ${JENKINS_LOCATOR} -noKeyAuth"
fi

validate_jenkins_client()
{
    if [ ! -f "${JENKINS_CLIENT}" ]; then
        "${SCRIPT_DIRECTORY}"/../bin/download-client.sh -c "${CONFIG}"

        if [ ! -f "${JENKINS_CLIENT}" ]; then
            echo "File ${JENKINS_CLIENT} does not exist."

            exit 1
        fi

        return 0
    fi
}

jenkins_auth()
{
    validate_jenkins_client

    if [ "${SSH_KEY}" = "" ]; then
        AUTH_USER_STRING=$(${JENKINS_COMMAND} who-am-i | grep as || true)
        AUTH_USER="${AUTH_USER_STRING#Authenticated as: }"

        if [ ! "${USERNAME}" = "${AUTH_USER}" ]; then
            ${JENKINS_COMMAND} login --username "${USERNAME}" --password "${PASSWORD}"
        fi
    fi
}

#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
CONFIG=""
VERBOSE=false

function_exists()
{
    declare -f -F "${1}" > /dev/null

    return $?
}

while true; do
    case ${1} in
        -c|--config)
            CONFIG=${2-}
            shift 2
            ;;
        -h|--help)
            echo "Global usage: [-v|--verbose][-d|--debug][-h|--help][-c|--config CONFIG]"
            function_exists usage && usage

            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            echo "Verbose mode enabled."
            shift
            ;;
        -d|--debug)
            set -x
            shift
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

find_config()
{
    if [ "${VERBOSE}" = true ]; then
        echo "find_config"
    fi

    if [ "${CONFIG}" = "" ]; then
        CONFIG="${HOME}/.jenkins-tools.conf"
    fi

    if [ ! "$(command -v realpath 2>&1)" = "" ]; then
        REALPATH_COMMAND="realpath"
    else
        if [ ! "$(command -v grealpath 2>&1)" = "" ]; then
            REALPATH_COMMAND="grealpath"
        else
            echo "Required tool (g)realpath not found."

            exit 1
        fi
    fi

    CONFIG=$(${REALPATH_COMMAND} "${CONFIG}")

    if [ ! -f "${CONFIG}" ]; then
        echo "Config missing: ${CONFIG}"

        exit 1;
    fi
}

find_config

# shellcheck source=/dev/null
. "${CONFIG}"

validate_config()
{
    if [ "${VERBOSE}" = true ]; then
        echo "validate_config"
    fi

    if [ "${USERNAME}" = "" ]; then
        echo "USERNAME not set."

        exit 1;
    fi

    if [ "${PASSWORD}" = "" ]; then
        echo "PASSWORD not set."

        exit 1;
    fi

    if [ "${NAME}" = "" ]; then
        echo "NAME not set."

        exit 1;
    fi

    if [ "${MAIL}" = "" ]; then
        echo "MAIL not set."

        exit 1;
    fi
}

validate_config

define_library_variables()
{
    if [ "${VERBOSE}" = true ]; then
        echo "define_library_variables"
    fi

    if [ "${JENKINS_CLIENT}" = "" ]; then
        PROJECT_ROOT="${SCRIPT_DIRECTORY}/.."
        PROJECT_ROOT=$(${REALPATH_COMMAND} "${PROJECT_ROOT}")
        JENKINS_CLIENT="${PROJECT_ROOT}/jenkins-cli.jar"
    fi

    if [ "${JENKINS_LOCATOR}" = "" ]; then
        JENKINS_LOCATOR="http://localhost:8080"
    fi

    JENKINS_COMMAND="java -jar ${JENKINS_CLIENT} -s ${JENKINS_LOCATOR} -noKeyAuth"
}

define_library_variables

validate_jenkins_client()
{
    if [ "${VERBOSE}" = true ]; then
        echo "validate_jenkins_client"
    fi

    if [ "${VERBOSE}" = true ]; then
        echo "validate_jenkins_client"
    fi

    if [ ! -f "${JENKINS_CLIENT}" ]; then
        "${SCRIPT_DIRECTORY}"/../bin/download-client.sh -c "${CONFIG}"

        if [ ! -f "${JENKINS_CLIENT}" ]; then
            echo "File ${JENKINS_CLIENT} does not exist."

            exit 1;
        fi

        return 0
    fi
}

jenkins_auth()
{
    if [ "${VERBOSE}" = true ]; then
        echo "jenkins_auth"
    fi

    validate_jenkins_client

    AUTH_USER_STRING=$(${JENKINS_COMMAND} who-am-i | grep as)
    AUTH_USER="${AUTH_USER_STRING#Authenticated as: }"

    if [ ! "${USERNAME}" = "${AUTH_USER}" ]; then
        ${JENKINS_COMMAND} login --username "${USERNAME}" --password "${PASSWORD}"
    fi
}

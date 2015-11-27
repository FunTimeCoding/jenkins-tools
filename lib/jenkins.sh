#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
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
    if [ "${CONFIG}" = "" ]; then
        CONFIG="${HOME}/.jenkins-tools.conf"
    fi

    if [ ! "$(command -v realpath 2>&1)" = "" ]; then
        REALPATH_CMD="realpath"
    else
        if [ ! "$(command -v grealpath 2>&1)" = "" ]; then
            REALPATH_CMD="grealpath"
        else
            echo "Required tool (g)realpath not found."

            exit 1
        fi
    fi
    CONFIG=$(${REALPATH_CMD} "${CONFIG}")

    if [ ! -f "${CONFIG}" ]; then
        echo "Config missing: ${CONFIG}"

        exit 1;
    fi
}

find_config

. "${CONFIG}"

validate_config()
{
    if [ "${VERBOSE}" = true ]; then
        echo "validate_config"
    fi

    if [ "${USER}" = "" ]; then
        echo "USER not set."

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
        PROJECT_ROOT="${SCRIPT_DIR}/.."
        PROJECT_ROOT=$(${REALPATH_CMD} "${PROJECT_ROOT}")
        JENKINS_CLIENT="${PROJECT_ROOT}/jenkins-cli.jar"
    fi

    if [ "${JENKINS_LOCATOR}" = "" ]; then
        JENKINS_LOCATOR="http://localhost:8080"
    fi

    JENKINS_CMD="java -jar ${JENKINS_CLIENT} -s ${JENKINS_LOCATOR} -noKeyAuth"
}

define_library_variables

validate_jenkins_client()
{
    if [ "${VERBOSE}" = true ]; then
        echo "validate_jenkins_client"
    fi

    if [ ! -f "${JENKINS_CLIENT}" ]; then
        "${SCRIPT_DIR}"/../bin/download-client.sh -c "${CONFIG}"

        if [ ! -f "${JENKINS_CLIENT}" ]; then
            echo "File ${JENKINS_CLIENT} does not exist."

            exit 1;
        fi

        return 0
    fi
}

jenkins_auth()
{
    validate_jenkins_client

    AUTH_USER_STRING=$(${JENKINS_CMD} who-am-i | grep as)
    AUTH_USER="${AUTH_USER_STRING#Authenticated as: }"

    if [ ! "${USER}" = "${AUTH_USER}" ]; then
        ${JENKINS_CMD} login --username "${USER}" --password "${PASSWORD}"
    fi
}

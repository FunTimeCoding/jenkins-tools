#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
getopt -o c:hv -l config:,help,verbose --name "${0}" -- "$@" > /dev/null
CONFIG=""

function_exists()
{
    declare -f -F ${1} > /dev/null
    return $?
}

while true; do
    case ${1} in
        -c|--config)
            CONFIG=${2-}
            shift 2
            ;;
        -h|--help)
            echo "Global usage: [-v][-h][-c|--config CONFIG]"
            function_exists usage && usage
            exit 0
            ;;
        -v|--verbose)
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
            echo "Required tool (g)realpath not found." && exit 1
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

define_lib_vars()
{
    if [ "${JENKINS_CLI}" = "" ]; then
        PROJECT_ROOT="${SCRIPT_DIR}/.."
        PROJECT_ROOT=$(${REALPATH_CMD} "${PROJECT_ROOT}")
        JENKINS_CLI="${PROJECT_ROOT}/jenkins-cli.jar"
    fi

    if [ "${JENKINS_URL}" = "" ]; then
        JENKINS_URL="http://localhost:8080"
    fi

    JENKINS_CMD="java -jar ${JENKINS_CLI} -s ${JENKINS_URL} -noKeyAuth"
}

define_lib_vars

validate_cli()
{
    if [ ! -f "${JENKINS_CLI}" ]; then
        "${SCRIPT_DIR}/../bin/get-cli.sh"

        if [ ! -f "${JENKINS_CLI}" ]; then
            echo "File ${JENKINS_CLI} does not exist."
            exit 1;
        fi

        return 0
    fi
}

jenkins_auth()
{
    validate_cli

    AUTH_USER_STRING=$(${JENKINS_CMD} who-am-i | grep as)
    AUTH_USER="${AUTH_USER_STRING#Authenticated as: }"

    if [ ! "${USER}" = "${AUTH_USER}" ]; then
        ${JENKINS_CMD} login --username "${USER}" --password "${PASSWORD}"
    fi
}

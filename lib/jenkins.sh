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
            break
            ;;
    esac
done

OPTIND=1

if [ "${CONFIG}" = "" ]; then
    CONFIG="${HOME}/.jenkins-tools.conf"
fi

if [ ! "$(command -v realpath 2>&1)" = "" ]; then
    REALPATH=realpath
else
    if [ ! "$(command -v grealpath 2>&1)" = "" ]; then
        REALPATH=grealpath
    else
        echo "Required tool (g)realpath not found."

        exit 1
    fi
fi

CONFIG=$(${REALPATH} "${CONFIG}")

if [ ! -f "${CONFIG}" ]; then
    echo "Config missing: ${CONFIG}"

    exit 1
fi

# shellcheck source=/dev/null
. "${CONFIG}"

if [ "${KEY}" = "" ]; then
    echo "KEY not set."

    exit 1
fi

if [ "${USERNAME}" = "" ]; then
    echo "USERNAME not set."

    exit 1
fi

if [ "${PASSWORD}" = "" ]; then
    echo "PASSWORD not set."

    exit 1
fi

if [ "${HOST_NAME}" = "" ]; then
    echo "HOST_NAME not set."

    exit 1
fi

if [ "${PORT}" = "" ]; then
    echo "PORT not set."

    exit 1
fi

if [ "${EMAIL}" = "" ]; then
    echo "EMAIL not set."

    exit 1
fi

JENKINS="ssh -i ${KEY} ${HOST_NAME} -p ${PORT}"

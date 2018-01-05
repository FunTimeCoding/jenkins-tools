#!/bin/sh -e

CONFIG=""

while true; do
    case ${1} in
        --help)
            echo "Global usage: ${0} [--help][--config CONFIG]"

            if command -v usage > /dev/null; then
                usage
            fi

            exit 0
            ;;
        --config)
            CONFIG=${2-}
            shift 2
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
    CONFIG="${HOME}/.jenkins-tools.sh"
fi

if [ ! -f "${CONFIG}" ]; then
    echo "Config missing: ${CONFIG}"

    exit 1
fi

# shellcheck source=/dev/null
. "${CONFIG}"

if [ "${KEY}" = "" ]; then
    echo "KEY not set."

    exit 1
else
    test -f "${KEY}" && FOUND=true || FOUND=false

    if [ "${FOUND}" = false ]; then
        echo "Key does not exist: ${KEY}"

        exit 1
    fi
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

JENKINS="ssh -i ${KEY} ${USERNAME}@${HOST_NAME} -p ${PORT}"
export JENKINS

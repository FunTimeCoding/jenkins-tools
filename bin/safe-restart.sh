#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)

usage() {
    echo "Local usage: ${0}"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
${JENKINS} safe-restart

for SECOND in $(seq 1 120); do
    echo "${SECOND}"
    sleep 1
    STATUS_CODE=$(curl --insecure --silent --output /dev/null --write-out '%{http_code}' "https://${HOST_NAME}/cli/" || true)

    if [ "${STATUS_CODE}" = 200 ]; then
        exit 0
    fi
done

echo "Timeout reached."
exit 1

#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0}"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
${JENKINS} safe-restart

for i in $(seq 1 120); do
    echo "${i}"
    sleep 1
    # Somewhere in the middle of the restart, curl would abort. That's why there is the "|| true".
    # Might not be the most clean way. Feel free to improve on it.
    HTTP_RESULT_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${JENKINS_LOCATOR}/cli/" || true)

    if [ "${HTTP_RESULT_CODE}" = "200" ]; then
        echo "Restart complete."
        exit 0
    fi
done

echo "Timeout reached, restart incomplete."
exit 1

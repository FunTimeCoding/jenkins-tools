#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
    echo "Local usage: ${0} JOB_NAME"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
JOB_NAME="${1}"

if [ "${JOB_NAME}" = '' ]; then
    usage

    exit 1
fi

echo "TODO: This does not work."
exit 0
sed "s/example/${JOB_NAME}/" < "${SCRIPT_DIRECTORY}/../src/delete-failed-builds.groovy" > "${SCRIPT_DIRECTORY}/../tmp/delete-failed-builds.groovy"
"${SCRIPT_DIRECTORY}/run-script.sh" "${SCRIPT_DIRECTORY}/../tmp/delete-failed-builds.groovy"

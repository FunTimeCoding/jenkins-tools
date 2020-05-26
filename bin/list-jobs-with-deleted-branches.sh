#!/bin/sh -e

echo "Script incomplete."
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
BRANCHES=$(list-branches.sh -c "${CONFIG}")
echo "${BRANCHES}"
JOBS=$("${SCRIPT_DIRECTORY}"/list-jobs.sh -c "${CONFIG}")
echo "${JOBS}"

#!/bin/sh -e

echo "Script incomplete."
exit 1
DIR=$(dirname "${0}")
SCRIPT_DIR=$(cd "${DIR}"; pwd)

usage()
{
    echo "Local usage: ${0}"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
BRANCHES=$(list-branches.sh)
echo "${BRANCHES}"
JOBS=$("${SCRIPT_DIR}/list-jobs.sh")
echo "${JOBS}"

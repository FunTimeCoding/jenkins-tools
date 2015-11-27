#!/bin/sh -e

echo "Script incomplete."
exit 1
SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)

usage()
{
    echo "Local usage: ${0}"
}

. "${SCRIPT_DIR}/../lib/jenkins.sh"
BRANCHES=$(list-branches.sh)
echo "${BRANCHES}"
JOBS=$("${SCRIPT_DIR}/list-jobs.sh")
echo "${JOBS}"

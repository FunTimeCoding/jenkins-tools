#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)

usage()
{
	echo "Local usage: ${0} SCRIPT_FILE"
}

# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
SCRIPT_FILE="${1}"

if [ "${SCRIPT_FILE}" = "" ]; then
	usage

	exit 1;
fi

CONTENTS=$(cat "${SCRIPT_FILE}")
curl --insecure --user "${USERNAME}:${PASSWORD}" --data-urlencode "script=${CONTENTS}" "https://${HOST_NAME}/scriptText"

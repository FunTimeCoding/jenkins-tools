#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
echo "def instance = jenkins.model.Jenkins.getInstance()
def ldaprealm = new hudson.security.LDAPSecurityRealm (
\"${SERVER}\",
\"${ROOT_DN}\",
\"${USER_SEARCH_BASE}\",
\"${USER_SEARCH}\",
\"${GROUP_SEARCH_BASE}\",
'',
null,
\"${MANAGER_DN}\",
\"${MANAGER_PASSWORD}\",
false,
false,
null,
null,
null,
null
)
instance.setSecurityRealm(ldaprealm)
instance.setAuthorizationStrategy(new hudson.security.FullControlOnceLoggedInAuthorizationStrategy())
instance.save()" | ${JENKINS} groovy =

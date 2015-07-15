#!/bin/sh -e

SCRIPT_DIR="$(cd $(dirname ${0}); pwd)"
source "${SCRIPT_DIR}/../lib/jenkins.sh"

validate_cli

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
        null )

instance.setSecurityRealm(ldaprealm)
instance.setAuthorizationStrategy(new hudson.security.FullControlOnceLoggedInAuthorizationStrategy())
instance.save()" | ${JENKINS_CMD} groovy =

jenkins_auth

echo "Restarting."
${JENKINS_CMD} safe-restart

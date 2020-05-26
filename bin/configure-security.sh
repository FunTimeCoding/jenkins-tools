#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins_tools.sh"
echo "def allowSignup = false
def realm = new hudson.security.HudsonPrivateSecurityRealm(allowSignup)
def user = realm.createAccount(\"${USERNAME}\", \"${PASSWORD}\")
user.setFullName(\"${NAME}\")
user.addProperty(new hudson.tasks.Mailer.UserProperty(\"${EMAIL}\"))
user.save()
def jenkins = jenkins.model.Jenkins.getInstance()
jenkins.setSecurityRealm(realm)
jenkins.setAuthorizationStrategy(new hudson.security.FullControlOnceLoggedInAuthorizationStrategy())
jenkins.save()" | ${JENKINS} groovy =
${JENKINS} safe-restart

#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/jenkins.sh"
validate_cli
echo "def allowSignup = false
def realm = new hudson.security.HudsonPrivateSecurityRealm(allowSignup)
def user = realm.createAccount(\"${USERNAME}\", \"${PASSWORD}\")
user.setFullName(\"${NAME}\")
user.addProperty(new hudson.tasks.Mailer.UserProperty(\"${MAIL}\"))
user.save()
def jenkins = jenkins.model.Jenkins.getInstance()
jenkins.setSecurityRealm(realm)
jenkins.setAuthorizationStrategy(new hudson.security.FullControlOnceLoggedInAuthorizationStrategy())
jenkins.save()" | ${JENKINS_COMMAND} groovy =
jenkins_auth
echo "Restarting."
${JENKINS_COMMAND} safe-restart

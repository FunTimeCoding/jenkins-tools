#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "${0}")"; pwd)
. "${SCRIPT_DIR}/../lib/jenkins.sh"
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
jenkins.save()" | ${JENKINS_CMD} groovy =
jenkins_auth
echo "Restarting."
${JENKINS_CMD} safe-restart

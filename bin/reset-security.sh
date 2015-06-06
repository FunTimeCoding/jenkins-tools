#!/bin/sh -e
# This script basically does this: https://wiki.jenkins-ci.org/display/JENKINS/Disable+security

OS=$(uname)

if [ "${OS}" = "Linux" ]; then
    JENKINS_CONFIG="/var/lib/jenkins/config.xml"
elif [ "${OS}" = "Darwin" ]; then
    JENKINS_CONFIG="${HOME}/.jenkins/config.xml"
fi

ENABLED=$(xml sel --template --value-of "/hudson/useSecurity" "${JENKINS_CONFIG}")

if [ "${ENABLED}" = "false" ]; then
    echo "Security is already disabled."
    exit 0
fi

if [ "${OS}" = "Linux" ]; then
    sudo service jenkins stop
elif [ "${OS}" = "Darwin" ]; then
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.jenkins-lts.plist
fi

xml edit --inplace --update "/hudson/useSecurity" --value "false" ~/.jenkins/config.xml
xml edit --inplace --update "/hudson/authorizationStrategy/@class" --value "hudson.security.AuthorizationStrategy\$Unsecured" ~/.jenkins/config.xml
xml edit --inplace --delete "/hudson/securityRealm/*" ~/.jenkins/config.xml
xml edit --inplace --update "/hudson/securityRealm/@class" --value "hudson.security.SecurityRealm\$None" ~/.jenkins/config.xml

if [ "${OS}" = "Linux" ]; then
    sudo service jenkins start
elif [ "${OS}" = "Darwin" ]; then
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.jenkins-lts.plist
fi

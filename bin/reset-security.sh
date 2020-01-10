#!/bin/sh -e
# Script for: https://wiki.jenkins-ci.org/display/JENKINS/Disable+security

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    JENKINS_CONFIGURATION="${HOME}/.jenkins/config.xml"
else
    JENKINS_CONFIGURATION=/var/lib/jenkins/config.xml
fi

ENABLED=$(xml sel --template --value-of /hudson/useSecurity "${JENKINS_CONFIGURATION}")

if [ "${ENABLED}" = false ]; then
    echo "Security is already disabled."
    exit 0
fi

if [ "${SYSTEM}" = Darwin ]; then
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.jenkins-lts.plist
else
    sudo service jenkins stop
fi

xml edit --inplace --update /hudson/useSecurity --value false ~/.jenkins/config.xml
xml edit --inplace --update /hudson/authorizationStrategy/@class --value "hudson.security.AuthorizationStrategy\$Unsecured" ~/.jenkins/config.xml
xml edit --inplace --delete "/hudson/securityRealm/*" ~/.jenkins/config.xml
xml edit --inplace --update /hudson/securityRealm/@class --value "hudson.security.SecurityRealm\$None" ~/.jenkins/config.xml

if [ "${SYSTEM}" = Darwin ]; then
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.jenkins-lts.plist
else
    sudo service jenkins start
fi

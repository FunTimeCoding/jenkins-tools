#!/bin/sh -e
# This script basically does this: https://wiki.jenkins-ci.org/display/JENKINS/Disable+security

ENABLED=$(xml sel --template --value-of "/hudson/useSecurity" ~/.jenkins/config.xml)

if [ "${ENABLED}" = "false" ]; then
    echo "Security is already disabled."
    exit 0
fi

launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.jenkins-lts.plist
xml edit --inplace --update "/hudson/useSecurity" --value "false" ~/.jenkins/config.xml
xml edit --inplace --update "/hudson/authorizationStrategy/@class" --value "hudson.security.AuthorizationStrategy\$Unsecured" ~/.jenkins/config.xml
xml edit --inplace --delete "/hudson/securityRealm/*" ~/.jenkins/config.xml
xml edit --inplace --update "/hudson/securityRealm/@class" --value "hudson.security.SecurityRealm\$None" ~/.jenkins/config.xml
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.jenkins-lts.plist

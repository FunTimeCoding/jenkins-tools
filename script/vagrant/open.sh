#!/bin/sh -e

# TODO: Test the host name variant for a while before deleting this.
#ADDRESS=$(vagrant ssh -c "ip addr list eth1 | grep 'inet ' | cut -d ' ' -f6 | cut -d / -f1" 2> /dev/null | tr -d '\r')
#HOST="${ADDRESS}"
DOMAIN=$(cat tmp/domain.txt)
HOST_NAME=$(cat tmp/hostname.txt)
HOST="${HOST_NAME}.${DOMAIN}"
echo "Username: admin"
echo "Password: admin"
echo "Initial admin password, if it still exists:"
vagrant ssh --command 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword' || true

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    open "http://${HOST}:8080"
else
    xdg-open "http://${HOST}:8080"
fi

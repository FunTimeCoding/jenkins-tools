#!/bin/sh -e

USER_NUMBER=$(id -u)

if [ "${USER_NUMBER}" = 0 ]; then
    salt-call state.highstate
else
    sudo salt-call state.highstate
fi

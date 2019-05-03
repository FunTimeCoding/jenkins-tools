#!/bin/sh -e

mkdir -p tmp/salt
cp configuration/minion.yaml tmp/salt/minion.conf

if [ ! -f tmp/bootstrap-salt.sh ]; then
    wget --output-document tmp/bootstrap-salt.sh https://bootstrap.saltstack.com
fi

vagrant up

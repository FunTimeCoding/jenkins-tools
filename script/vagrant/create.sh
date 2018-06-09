#!/bin/sh -e

mkdir -p tmp/salt
hostname -f > tmp/domain.txt
cp minion.yaml tmp/salt/minion

if [ ! -f tmp/bootstrap-salt.sh ]; then
    curl --silent --location https://bootstrap.saltstack.com > tmp/bootstrap-salt.sh
fi

vagrant up
# TODO: Find a better way to ensure that the network is properly configured.
sleep 5
script/vagrant/update-hosts.sh

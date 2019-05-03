#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive
CODENAME=$(lsb_release --codename --short)

if [ "${CODENAME}" = jessie ]; then
    echo Europe/Berlin > /etc/timezone
    dpkg-reconfigure --frontend noninteractive tzdata
    apt-get --quiet 2 install vim multitail htop tree git
elif [ "${CODENAME}" = stretch ]; then
    apt-get --quiet 2 install neovim multitail htop tree git shellcheck hunspell devscripts ruby-ronn
fi

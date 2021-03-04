#!/bin/sh


if [ ! -z ${GUIX_ENVIRONMENT} ]
then
    echo 'please see this script!'
    exit 1
fi

if [ -z ${ARCH} ]
then
	if [ `uname -m` = "aarch64" ]
	then
	    ARCH=armv8
	fi
	if [ `uname -m` = "x86_64" ]
	then
	    ARCH=amd64
	fi
fi

SYNCTHING_CONF="${HOME}/.config/syncthing"
DATADIR="${HOME}/syncthing/"

guix environment -C -N --no-cwd \
	--share=${DATADIR} \
	--share=${SYNCTHING_CONF} \
	--ad-hoc syncthing \
	-- syncthing

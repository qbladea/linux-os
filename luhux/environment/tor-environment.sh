#!/bin/sh


if [ ! -z ${GUIX_ENVIRONMENT} ]
then
    echo 'please see this script!'
    exit 1
fi

PROFILE_REG=${HOME}/.environment/tor

if [ -e ${PROFILE_REG} ]
then
    rm -v ${PROFILE_REG}
fi

TOR_CONF=${HOME}/.torrc

guix environment -C -N --no-cwd \
     -r ${PROFILE_REG} \
     --expose=${TOR_CONF} \
     --ad-hoc tor \
     -- tor -f ${TOR_CONF}

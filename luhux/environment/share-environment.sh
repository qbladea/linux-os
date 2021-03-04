#!/bin/sh


if [ ! -z ${GUIX_ENVIRONMENT} ]
then
    echo 'please see this script!'
    exit 1
fi

PROFILE_REG=${HOME}/.environment/share

if [ -e ${PROFILE_REG} ]
then
    rm -v ${PROFILE_REG}
fi

TMUX_CONF=${HOME}/.tmux.conf
EMACS_CONF=${HOME}/.emacs
EMACS_RIME_DATADIR=${HOME}/.emacs.d/rime
EMACS_CONF_DIR=${HOME}/.emacs-config
SHARE_DATA_DIR=${HOME}/share/


guix environment -C -N --no-cwd \
     -r ${PROFILE_REG} \
     --ad-hoc ncurses \
     -E^TERM$ \
     -E^LANG$ \
     -E^GUIX_LOCPATH$ \
     --ad-hoc glibc-utf8-locales \
     --expose=${GUIX_LOCPATH} \
     --ad-hoc tmux \
     --expose=${TMUX_CONF} \
     --ad-hoc curl nss-certs \
     --expose=/etc/ssl \
     --expose=${HOME}/.proxyrc \
     --ad-hoc emacs-no-x \
     --expose=${EMACS_CONF} \
     --expose=${EMACS_CONF_DIR}/basic-setup.el \
     --ad-hoc emacs-rime \
     --share=${EMACS_RIME_DATADIR} \
     --expose=${EMACS_CONF_DIR}/translate-setup.el \
     --ad-hoc asciinema \
     --ad-hoc translate-shell gawk\
     --ad-hoc emacs-no-x emacs-w3m busybox \
     --share=${SHARE_DATA_DIR}

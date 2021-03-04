#!/bin/sh


if [ ! -z ${GUIX_ENVIRONMENT} ]
then
    echo 'please see this script!'
    exit 1
fi

PROFILE_REG=${HOME}/.environment/game

if [ -e ${PROFILE_REG} ]
then
    rm -v ${PROFILE_REG}
fi

TMUX_CONF=${HOME}/.tmux.conf
NETHACK_DATADIR=${HOME}/.config/nethack
TINTIN_DATADIR=${HOME}/.tintin
CDDA_DATADIR=${HOME}/.cataclysm-dda
SHARE_DATA_DIR=${HOME}/share/
EMACS_CONF=${HOME}/.emacs
EMACS_RIME_DATADIR=${HOME}/.emacs.d/rime
EMACS_CONF_DIR=${HOME}/.emacs-config

guix environment -C -N --no-cwd \
        -r ${PROFILE_REG} \
	--ad-hoc ncurses \
	-E^TERM$ \
        -E^LANG$ \
	-E^GUIX_LOCPATH \
	-L /srv/git/my-guix \
	--ad-hoc glibc-utf8-locales \
	--ad-hoc tmux screen\
        --expose=${TMUX_CONF}=${HOME}/.tmux.conf \
	--ad-hoc curl nss-certs \
	--expose=/etc/ssl \
	--ad-hoc nethack \
	--ad-hoc tintin++ powwow python-qrcode \
	--ad-hoc cataclysm-dda \
	--share=${CDDA_DATADIR} \
	--share=${TINTIN_DATADIR} \
	--ad-hoc go-github-com-junegunn-fzf \
	--ad-hoc asciinema \
	--share=${SHARE_DATA_DIR} \
	--ad-hoc emacs-no-x \
	--expose=${EMACS_CONF} \
	--expose=${EMACS_CONF_DIR}/basic-setup.el \
	--ad-hoc emacs-rime \
	--share=${EMACS_RIME_DATADIR} \
	--expose=${EMACS_CONF_DIR}/translate-setup.el \
	--ad-hoc translate-shell gawk sdcv stardict-ecdict emacs-sdcv \
	--ad-hoc emacs-no-x emacs-w3m \
        --ad-hoc curseofwar busybox inetutils "$@"


#!/bin/sh


if [ ! -z ${GUIX_ENVIRONMENT} ]
then
    echo 'please see this script!'
    exit 1
fi

PROFILE_REG=${HOME}/.environment/emacs-wayland

if [ -e ${PROFILE_REG} ]
then
    rm -v ${PROFILE_REG}
fi


EMACS_CONF=${HOME}/.emacs
EMACS_CONF_DIR=${HOME}/.emacs-config
EMACS_RIME_DATADIR=${HOME}/.emacs.d/rime
WORKING_DIR=/srv/git/
TELEGA_DATADIR=${HOME}/.telega
STARTUP_SCRIPT=/srv/git/scripts/emacs-wayland/emacs.sh


guix environment -C -N --no-cwd \
     -r ${PROFILE_REG} \
     -E^LANG$ \
    -E^GUIX_LOCPATH$ \
    --ad-hoc glibc-utf8-locales \
    --ad-hoc wget curl nss-certs \
    --expose=/etc/ssl \
    --expose=${HOME}/.proxyrc \
    --expose=${STARTUP_SCRIPT}=${HOME}/emacs.sh \
    --ad-hoc emacs-next-pgtk \
    --ad-hoc fontconfig font-gnu-unifont \
    --ad-hoc adwaita-icon-theme mate-themes\
    -E^XDG_RUNTIME_DIR$ \
    -E^WAYLAND_DISPLAY$ \
    --share=${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY} \
    --expose=${EMACS_CONF} \
    --expose=${EMACS_CONF_DIR}/basic-setup.el \
    --expose=${EMACS_CONF_DIR}/mail-setup.el \
    --expose=${EMACS_CONF_DIR}/wombat-theme.el \
    --expose=${EMACS_CONF_DIR}/disable-toolbar.el \
    --ad-hoc emacs-rime \
    --share=${EMACS_RIME_DATADIR} \
    --ad-hoc emacs-which-key \
    --expose=${EMACS_CONF_DIR}/which-key-setup.el \
    --ad-hoc emacs-w3m gawk\
    --ad-hoc emacs-telega \
    --expose=${EMACS_CONF_DIR}/telega-setup.el \
    --share=${TELEGA_DATADIR} \
    --ad-hoc man-db texinfo man-pages\
    --ad-hoc bash coreutils util-linux findutils gawk sed grep diffutils patch inetutils procps psmisc gzip zstd xz bzip2 less tar\
    --share=${WORKING_DIR} \
    -- ${HOME}/emacs.sh "$@"

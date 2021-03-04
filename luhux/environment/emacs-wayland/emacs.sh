#!/bin/sh

ln -s ${GUIX_ENVIRONMENT} ${HOME}/.guix-profile
fc-cache -rvf
emacs -fn unifont-12 $@

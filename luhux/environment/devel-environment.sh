#!/bin/sh

set -u
set -e

POS=$(dirname $(realpath ${0}))

REG_DIR=${HOME}/.environment/
PROFILE_REG=${HOME}/.environment/devel

TMUX_PACKAGE="tmux"
TMUX_CONF=${HOME}/.tmux.conf

EMACS_PACKAGE="emacs-no-x"
EMACS_CONF=${HOME}/.emacs.container
EMACS_CONF_DIR=${HOME}/.emacs-config

EMACS_RIME_PACKAGE="emacs-rime"
EMACS_RIME_DATADIR=${HOME}/.emacs.d/rime


GIT_CONF=${HOME}/.gitconfig

WORKING_DIR=/srv/git

EMACS_GUILE_PLUGINS=" emacs-geiser emacs-paredit\
 emacs-yasnippet emacs-magit guile guix git"
EMACS_C_PLUGINS="emacs-ggtags global gcc-toolchain\
 make gdb"
EMACS_

. ${POS}/functions.sh

# 容器内默认编辑器
export EDITOR='emacsclient'
guix environment -C -N --no-cwd \
     -r ${PROFILE_REG} \
     --ad-hoc ncurses \
     -E^TERM$ \
     -E^LANG$ \
     -E^GUIX_LOCPATH$ \
     -E^EDITOR$ \
     --ad-hoc tmux \
     --expose=${TMUX_CONF} \
     --ad-hoc wget curl nss-certs \
     --expose=/etc/ssl \
     --expose=${HOME}/.proxyrc \
     --ad-hoc emacs-no-x \
     --expose=${EMACS_CONF} \
     --ad-hoc emacs-ggtags global \
     --expose=${EMACS_CONF_DIR}/basic-setup.el \
     --ad-hoc gcc-toolchain clang-toolchain tcc gdb \
     --expose=${EMACS_CONF_DIR}/c-setup.el \
     --expose=${EMACS_CONF_DIR}/guile-setup.el \

     --expose=${EMACS_CONF_DIR}/mail-setup.el \
     --ad-hoc emacs-doom-modeline \
     --expose=${EMACS_CONF_DIR}/doom-modeline.el \
     --ad-hoc emacs-rime \
     --share=${EMACS_RIME_DATADIR} \
     --ad-hoc emacs-which-key \
     --expose=${EMACS_CONF_DIR}/which-key-setup.el \
     --ad-hoc translate-shell gawk sdcv stardict-ecdict emacs-sdcv\
     --expose=${EMACS_CONF_DIR}/translate-setup.el \
     --ad-hoc emacs-org-static-blog \
     --expose=${EMACS_CONF_DIR}/static-blog.el \
     --ad-hoc git emacs-magit less\
     --expose=${GIT_CONF} \
     --ad-hoc emacs-w3m gawk\
     --ad-hoc man-db texinfo man-pages\
     --ad-hoc bash coreutils util-linux findutils gawk sed grep diffutils patch inetutils procps psmisc gzip zstd xz bzip2 less tar\
     --ad-hoc make \
     --ad-hoc go-github-com-junegunn-fzf \
     --ad-hoc sicp \
     --share=${WORKING_DIR} "$@"

# 在非Guix System 上使用Guix用到的环境变量


GUIX_PROFILE="${HOME}/.guix-profile" 
if [ -d ${GUIX_PROFILE} ]
then
    . ${GUIX_PROFILE}/etc/profile
    export MANPATH=${GUIX_PROFILE}/share/man:${MANPTH}
    export INFOPATH=${GUIX_PROFILE}/share/info:${INFOPATH}
    export GUIX_LOCPATH="${HOME}/.guix-profile/lib/locale"
    export SSL_CERT_DIR="${HOME}/.guix-profile/etc/ssl/certs"
    export SSL_CERT_FILE="${HOME}/.guix-profile/etc/ssl/certs/ca-certificates.crt"
    export GIT_SSL_CAINFO="${SSL_CERT_FILE}"
    export CURL_CA_BUNDLE="${HOME}/.guix-profile/etc/ssl/certs/ca-certificates.crt"
fi

# 保证PATH中的 ${HOME}/.conig/guix/current/bin 在 ${HOME}/.guix-profile/bin 的前面
GUIX_PROFILE="${HOME}/.config/guix/current" 
if [ -d ${GUIX_PROFILE} ]
then
    . ${GUIX_PROFILE}/etc/profile
    export MANPATH=${GUIX_PROFILE}/share/man:${MANPTH}
    export INFOPATH=${GUIX_PROFILE}/share/info:${INFOPATH}
fi

# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi



alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
export CODE_DIR=/srv/code
alias dev='emacs-container --share=${CODE_DIR}'
alias misc='emacs-container --share=${HOME}/Downloads'

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    if [ "$GUIX_ENVIRONMENT_CONTAINER" == "emacs" ]
    then
       # 使用容器内提供的bash，而不是默认提供的bash
       export SHELL=${GUIX_ENVIRONMENT}/bin/bash
       # EDITOR
       export EDITOR="emacsclient -nw"
    fi
    export PS1="\n\u@\h \w [date: \$(date)]\n[env]\$ "
else
    # Source the system-wide file.
    source /etc/bashrc

    # 提示符
    export PS1="\n\u@\h \w [date: \$(date)]\n\$ "

    # ssh-agent
    if [ -e ${HOME}/.ssh-agent ]
    then
	. ${HOME}/.ssh-agent
    fi

    # 隐私
    export TMPDIR=${HOME}/.tmp/

    # 输入法
    export XMODIFIERS=@im=ibus
    export GTK_IM_MODULE=xim
    export QT_IM_MODULE=xim

    # 设备特定配置
    if [ -e ${HOME}/.bashrc.user ]
    then
	. ${HOME}/.bashrc.user
    fi
    eval "$(direnv hook bash)"    
fi


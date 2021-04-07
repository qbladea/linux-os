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

export CODE_DIR=${HOME}/code

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    export PS1="\n\u@\h \w [date: \$(date)]\n[env]\$ "
else
    # Source the system-wide file.
    if [ "${HOME}" == "/data/data/com.termux/files/home" ]
    then
	echo "This is termux!"
    else
        source /etc/bashrc
    fi

    # EDITOR
    export EDITOR="emacsclient -nw"

    # 提示符
    export PS1="\n\u@\h \w [date: \$(date)]\n\$ "

    # ssh-agent
    if [ -e ${HOME}/.ssh-agent ]
    then
	. ${HOME}/.ssh-agent
    fi

    # 隐私
    export TMPDIR=${HOME}/.tmp/

    # 全员wayland
    export WLR_XWAYLAND="/fuckxorg"
    export GDK_BACKEND=wayland
    export QT_QPA_PLATFORM=wayland
    export MOZ_ENABLE_WAYLAND=1

    # 设备特定配置
    if [ -e ${HOME}/.bashrc.user ]
    then
	. ${HOME}/.bashrc.user
    fi
fi

eval "$(direnv hook bash)"

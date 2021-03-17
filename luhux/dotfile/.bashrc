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

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
export PS1="\n\u@\h \w [date: \$(date)]\n[env]\$ "
else
export PS1="\n\u@\h \w [date: \$(date)]\n\$ "
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

if [ -e ${HOME}/.ssh-agent ]
then
    . ${HOME}/.ssh-agent
fi

export PATH=${HOME}/.bin:${PATH}
export TMPDIR=${HOME}/.tmp/

if [ -e ${HOME}/.bashrc.user ]
then
    . ${HOME}/.bashrc.user
fi

eval "$(direnv hook bash)"

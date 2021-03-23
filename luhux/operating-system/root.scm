(define-module (luhux operating-system root)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages certs)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu services linux))

;; public config
(define-public os-timezone "Hongkong")
(define-public os-locale "en_US.utf8")
(define-public os-kernel linux-libre)
(define-public os-kernel-arguments
  (append
   (list
    "panic=120")
   %default-kernel-arguments))
(define-public os-firmware %base-firmware)
(define-public os-host-name "guix")
(define-public os-issue "Welcome!\n")

(define-public skel-bash-profile
  (plain-file "bash_profile"
"\
# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi\n"))

(define-public skel-bashrc
  (plain-file "bashrc" "\
# Bash initialization for interactive non-login shells and
# for remote shells (info \"(bash) Bash Startup Files\").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in \"ssh host command\"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n \"$SSH_CLIENT\" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n \"$GUIX_ENVIRONMENT\" ]
then
    PS1='\\u@\\h \\w [env]\\$ '
else
    PS1='\\u@\\h \\w\\$ '
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'\n"))

(define-public skel-tmux-conf
  (plain-file "tmux-conf" "\
set-option -sa terminal-overrides ',xterm-256color:RGB'
set -g default-terminal \"tmux-256color\"
set-option -g mode-keys vi\n"))

(define-public skel-screenrc
  (plain-file "screenrc" "\
altscreen on
defbce on
term screen-256color
hardstatus off
hardstatus alwayslastline
startup_message off\n"))

(define-public skel-vimrc
  (plain-file "vimrc" "\
set nu
set rnu
set hlsearch
set background=dark
syntax on\n"))

(define-public skel-emacs.container
  (plain-file "emacs.container" "\
(defun load-directory (dir)
  (let ((load-it (lambda (f)
                   (load-file (concat (file-name-as-directory dir) f)))))
    (mapc load-it (directory-files dir nil \"\\.el$\"))))
(load-directory \"~/.emacs-config/\")\n"))

(define-public os-skeletons
  `((".bash_profile" ,skel-bash-profile)
    (".bashrc" ,skel-bashrc)
    (".tmux.conf" ,skel-tmux-conf)
    (".screenrc" ,skel-screenrc)
    (".emacs.container" ,skel-emacs.container)))

(define-public %china-substitute-urls
  (list
   "https://mirrors.sjtug.sjtu.edu.cn/guix"))

(define-public os-services
  (append
   (list)
   (modify-services
       %base-services
     (guix-service-type
      config =>
      (guix-configuration
       (inherit config)
       (substitute-urls
        %china-substitute-urls))))))

(define-public os-packages
  (append
   (list
    nss-certs)
   %base-packages))

;; dummy bootloder config
(define os-bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "nodev")
   (terminal-outputs '(console))))

;; dummy file-systems config
(define-public os-file-systems
  (cons (file-system
         (mount-point "/")
         (device "nodev")
         (type "none"))
        %base-file-systems))

(define-public root:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments os-kernel-arguments)
    (kernel os-kernel)
    (host-name os-host-name)
    (issue os-issue)
    (skeletons os-skeletons)
    (file-systems os-file-systems)
    (bootloader os-bootloader)
    (services os-services)))

root:os

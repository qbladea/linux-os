(define-module (luhux operating-system root)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages version-control)
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
  (local-file "../dotfile/.bash_profile" "bash-profile"))

(define-public skel-bashrc
  (local-file "../dotfile/.bashrc" "bashrc"))

(define-public skel-tmux-conf
  (local-file "../dotfile/.tmux.conf" "tmux-conf"))

(define-public skel-screenrc
  (local-file "../dotfile/.screenrc" "screenrc"))

(define-public skel-vimrc
  (local-file "../dotfile/.vimrc" "vimrc"))

(define-public skel-emacs-container
  (local-file "../dotfile/.emacs.container" "emacs-container-conf"))

(define-public skel-uim
  (local-file "../dotfile/.uim" "uim-conf"))

(define-public skel-gitconfig
  (local-file "../dotfile/.gitconfig" "gitconfig"))

(define-public skel-bashrc-container
  (local-file "../dotfile/.bashrc.container" "bashrc-container"))

(define-public os-skeletons
  `((".bash_profile" ,skel-bash-profile)
    (".bashrc" ,skel-bashrc)
    (".bashrc.container" ,skel-bashrc-container)
    (".tmux.conf" ,skel-tmux-conf)
    (".screenrc" ,skel-screenrc)
    (".emacs.container" ,skel-emacs-container)
    (".uim" ,skel-uim)
    (".gitconfig" ,skel-gitconfig)))

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
    ;; 终端复用器
    tmux
    screen
    ;; 编辑器
    vim
    emacs
    emacs-paredit
    emacs-rime
    ;; 输入法
    uim
    ;; 环境
    direnv
    ;; 版本管理
    git
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

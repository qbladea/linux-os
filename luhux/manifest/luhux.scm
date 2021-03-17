(define-module (luhux manifest luhux)
  #:use-module (guix profiles)
  #:use-module (gnu packages)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages rsync)
  #:use-module (gnu packages aidc)
  #:use-module (gnu packages shellutils)
  #:use-module (luhux packages uim))

(define-public guix-profile
  (list
   tmux        ; bsd tmux
   screen      ; gnu screen
   vim         ; editor
   ncurses     ; clear command
   openssh     ; ssh
   password-store ; password manager
   qrencode    ; qrcode
   gnupg       ; encrypt
   pinentry    ; gnupg
   git         ; version control
   uim-console ; console zh input method
   rsync       ; file sync
   direnv))    ; direnv


(packages->manifest
 guix-profile)

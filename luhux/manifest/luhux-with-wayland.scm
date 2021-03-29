(define-module (luhux manifest luhux-with-wayland)
  #:use-module (guix profiles)
  #:use-module (gnu packages)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages mate)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages image)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ibus)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages suckless)
  #:use-module (luhux packages wm)
  #:use-module ((luhux manifest luhux) #:prefix luhux:))

(define-public guix-profile
  (append
   (list
    hikari       ; wayland wm
    luhux-dwl    ; wayland wm
    wl-clipboard ; wayland clipboard
    ibus ibus-rime dconf dbus ; input method
    st                 ; terminal emulator
    mate-themes        ; gtk theme
    adwaita-icon-theme ; icon theme
    fontconfig   ; fc-cache command
    font-gnu-unifont ; basic font
    font-dejavu      ; basic font
    font-awesome     ; bar font
    font-hack        ; bar font
    waybar           ; wayland bar
    grim             ; wayland screenshot
    emacs-paredit    ; lisp edit
    emacs-rime       ; emacs input method
    emacs-no-x       ; base editor
    pulseaudio       ; audio
    acpi)            ; battery status
   luhux:guix-profile))

(packages->manifest
 guix-profile)

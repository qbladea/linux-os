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
  #:use-module ((luhux manifest luhux) #:prefix luhux:))

(define-public guix-profile
  (append
   (list
    hikari       ; wayland wm
    wl-clipboard ; wayland clipboard
    foot         ; wayland terminal
    mate-themes  ; theme
    fontconfig   ; fc-cache command
    font-gnu-unifont ; basic font
    font-terminus    ; hidpi font
    font-awesome     ; bar font
    waybar           ; wayland bar
    grim             ; wayland screenshot
    emacs-rime       ; emacs input method
    emacs-minimal    ; for zh-input
    pulseaudio       ; audio
    acpi)            ; battery status
   luhux:guix-profile))

(packages->manifest
 guix-profile)

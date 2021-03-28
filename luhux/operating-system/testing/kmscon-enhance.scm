(define-module (luhux operating-system testing kmscon-enhance)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages busybox)
  #:use-module (gnu packages certs)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu services linux)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services dbus))

(define-public os-timezone "UTC")
(define-public os-locale "en_US.utf8")
(define-public os-kernel linux-libre)
(define-public os-kernel-arguments
  (append
   (list
    "panic=120")
   %default-kernel-arguments))
(define-public os-firmware (list)) ;; vm machine not need firmware
(define-public os-host-name "guix")

(define-public os-services
  (list
   (service login-service-type)
   (service virtual-terminal-service-type)
   (service agetty-service-type (agetty-configuration
                                 (extra-options '("-L")) ; no carrier detect
                                 (term "vt100")
                                 (tty #f)))  ; automatic
   (service mingetty-service-type (mingetty-configuration
                                   (tty "tty1")))
   (service mingetty-service-type (mingetty-configuration
                                   (tty "tty2")))
   (service mingetty-service-type (mingetty-configuration
                                   (tty "tty3")))
   (service mingetty-service-type (mingetty-configuration
                                   (tty "tty4")))
   (dbus-service)
   ;; 默认的kmscon
   (service kmscon-service-type
            (kmscon-configuration
             (virtual-terminal "tty5")))
   ;; 使用unifont的kmscon
   (service kmscon-service-type
            (kmscon-configuration
             (virtual-terminal "tty6")
             (font-engine "unifont")))
   ;; 使用pango并设定字体大小的kmscon
   (service kmscon-service-type
            (kmscon-configuration
             (virtual-terminal "tty7")
             (font-size 16)))

   (service static-networking-service-type
            (list (static-networking (interface "lo")
                                     (ip "127.0.0.1")
                                     (requirement '())
                                     (provision '(loopback)))))
   (syslog-service)
   (service urandom-seed-service-type)
   (service udev-service-type)
   (service sysctl-service-type)))

(define-public os-packages
  (list
   nss-certs
   busybox
   kmod))

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
    (file-systems os-file-systems)
    (bootloader os-bootloader)
    (services os-services)))

root:os

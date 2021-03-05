;; 这是一个虚拟机(guix system vm)的配置文件,以用于隔离运行docker
;; 为什么要写这么一个配置文件:
;; docker太脏了，我不想让docker污染我的机器

(define-module (luhux system only-docker)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages busybox)
  #:use-module (gnu packages tmux)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu services dbus)
  #:use-module (gnu services ssh)
  #:use-module (gnu services desktop)
  #:use-module (gnu services docker))

(define-public os-timezone "UTC")
(define-public os-locale "en_US.utf8")
(define-public os-kernel linux-libre)
(define-public os-kernel-arguments
  (append
   (list
    "panic=5")
   %default-kernel-arguments))
(define-public os-firmware %base-firmware)
(define-public os-host-name "only-docker")
(define-public os-issue "Welcome!\nThis machine run docker!\n\n")

(define-public os-services
  (list
   (service login-service-type)
   (service virtual-terminal-service-type)
   (service agetty-service-type
            (agetty-configuration
             (extra-options '("-L")) ; no carrier detect
             (term "vt100")
             (tty #f))) ; automatic
   (service mingetty-service-type (mingetty-configuration
                                   (tty "tty1")))
   (service mingetty-service-type (mingetty-configuration
                                   (tty "tty2")))
   (service mingetty-service-type (mingetty-configuration
                                   (tty "ttyS0")))
   (service static-networking-service-type
            (list (static-networking (interface "lo")
                                     (ip "127.0.0.1")
                                     (requirement '())
                                     (provision '(loopback)))))
   (syslog-service)
   (service urandom-seed-service-type)
   ;; The LVM2 rules are needed as soon as LVM2 or the device-mapper is
   ;; used, so enable them by default.  The FUSE and ALSA rules are
   ;; less critical, but handy.
   (service udev-service-type
            (udev-configuration
             (rules (list lvm2 fuse alsa-utils crda))))
   (service special-files-service-type
            `(("/bin/sh" ,(file-append bash "/bin/sh"))
              ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))
   (service dhcp-client-service-type)
   (dropbear-service
    (dropbear-configuration
     (port-number 22)
     (password-authentication? #t)))
   (elogind-service)
   (dbus-service)
   (service docker-service-type)))

(define-public os-users
  (append
   (list
    (user-account
     (name "dk")
     (comment "dk admin")
     (group "users")
     (supplementary-groups
      (list
       "wheel"))))
    %base-user-accounts))

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

(define-public os-packages
  (list
   nss-certs
   busybox
   tmux))

(define-public only-docker:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments os-kernel-arguments)
    (kernel os-kernel)
    (host-name os-host-name)
    (issue os-issue)
    (users os-users)
    (file-systems os-file-systems)
    (bootloader os-bootloader)
    (services os-services)))


only-docker:os

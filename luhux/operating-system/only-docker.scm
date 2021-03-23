;; 这是一个虚拟机(guix system vm)的配置文件,以用于隔离运行docker
;; 为什么要写这么一个配置文件:
;; docker太脏了，我不想让docker污染我的机器

;; 存在的问题:
;; 无法使用 --share=xxx=/var/lib 作为存储docker文件的共享，因为9p共享文件系统无法chown，解决方法:多加一块挂载在 /var/lib 的虚拟磁盘

(define-module (luhux operating-system only-docker)
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
   (service udev-service-type
            (udev-configuration
             (rules (list lvm2 fuse))))
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

(define-public os-file-systems
  (append
   (list
    (file-system
      (mount-point "/") ;; dummy root file system
      (device "nodev")
      (type "none")))
   %base-file-systems))

(define-public os-packages
  (list
   nss-certs
   busybox
   kmod ; 用于加载内核模块
   tmux
   e2fsprogs
   btrfs-progs))

(define-public only-docker:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments os-kernel-arguments)
    (kernel os-kernel)
    (host-name os-host-name)
    (issue os-issue)
    (users os-users)
    (packages os-packages)
    (file-systems os-file-systems)
    (bootloader os-bootloader)
    (services os-services)))


only-docker:os

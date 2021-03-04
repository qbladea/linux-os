(define-module (luhux system root-arm)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages busybox)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages package-management)
  #:use-module (gnu bootloader u-boot)
  #:use-module (luhux system root))

(define-public root-arm:os-bootloader
  (bootloader-configuration
   (bootloader u-boot-bootloader)
   (target "nodev")
   (terminal-outputs '(console))))

(define-public root-arm:os-kernel
  linux-libre-arm-generic)

(define-public root-arm:os-packages
  (list busybox nss-certs guix))

(define-public root-arm:os-initrd-modules
  (list
   "btrfs")) ;; filesystem

(define-public root-arm:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel root-arm:os-kernel)
    (initrd-modules root-arm:os-initrd-modules)
    (issue os-issue)
    (skeletons os-skeletons)
    (host-name os-host-name)
    (services os-services)
    (packages root-arm:os-packages)
    (file-systems os-file-systems)
    (bootloader root-arm:os-bootloader)))

root-arm:os


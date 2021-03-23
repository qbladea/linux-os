(define-module (luhux operating-system root-arm64)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (luhux operating-system root)
  #:use-module (luhux operating-system root-arm))

(define-public root-arm64:os-kernel
  linux-libre-arm64-generic)

(define-public root-arm64:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel root-arm64:os-kernel)
    (initrd-modules root-arm:os-initrd-modules)
    (issue os-issue)
    (skeletons os-skeletons)
    (host-name os-host-name)
    (services os-services)
    (packages root-arm:os-packages)
    (file-systems os-file-systems)
    (bootloader root-arm:os-bootloader)))

root-arm64:os


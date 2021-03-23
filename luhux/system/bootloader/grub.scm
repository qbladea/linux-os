(define-module (luhux system bootloader grub)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (luhux packages bootloaders)
  #:use-module (guix utils))

;; 为lenovo100schromebook服务
(define-public grub-efi-borken-bootloader
  (bootloader
   (inherit grub-efi-bootloader)
   (name 'grub-efi-borken)
   (package grub-efi-borken)))




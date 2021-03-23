(define-module (luhux packages bootloaders)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages bootloaders)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils))


;; 我的lenovo100schromebook的 EFI varfs损坏了，所以使用到了这个包
(define-public grub-efi-borken
  (package
    (inherit grub-efi)
    (name "grub-efi-borken")
    (synopsis "Grand Unified Boot loader(UEFI Borken,Force install version)")
    (arguments
     `(,@(substitute-keyword-arguments (package-arguments grub-efi)
           ((#:phases phases)
            `(modify-phases ,phases
               (add-after 'unpack 'force-efi-system
                 (lambda _
                   (substitute* "grub-core/osdep/linux/platform.c"
                     (("is_not_empty_directory (\"/sys/firmware/efi\")")
                      ("is_not_empty_directory (\"/boot/efi\")"))))))))))))

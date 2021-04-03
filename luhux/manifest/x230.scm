(define-module (luhux manifest x230)
  #:use-module (guix profiles)
  #:use-module (gnu packages)
  #:use-module ((luhux manifest luhux-with-wayland) #:prefix luhux-with-wayland:)
  #:use-module ((luhux manifest devel) #:prefix devel:))

(define-public guix-profile
  (append
   (list)
   devel:guix-profile
   luhux-with-wayland:guix-profile))

(packages->manifest
 guix-profile)

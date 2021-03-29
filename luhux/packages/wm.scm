(define-module (luhux packages wm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages wm))



(define-public luhux-dwl
  (let ((commit "c2369362b379d5634e79ff9f1078530b335cb076")
        (revision "0"))
    (package
      (inherit dwl)
      (name "luhux-dwl")
      (version (git-version "9999" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/qbladea/dwl")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "10i57ha7s359jvqxfpljzx7kq6kx2i55ibccf8mf31y6d3xmxgn9"))))
      (home-page "https://github.com/qbladea/dwl"))))

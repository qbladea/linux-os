(define-module (luhux packages lib)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils))

(define-public libucl
  (package
    (name "libucl")
    (version "0.8.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/vstakhov/libucl/")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1h52ldxankyhbbm1qbqz1f2q0j03c1b4mig7343bs3mc6fpm18gf"))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("pkg-config" ,pkg-config)
       ("libtool" ,libtool)))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f)) ;; no tests
    (home-page "https://github.com/vstakhov/libucl")
    (synopsis "Universal configuration language")
    (description "Universal configuration language.
fully compatible with JSON format and is able to parse json files")
    (license license:bsd-2)))

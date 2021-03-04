(define-module (luhux packages wm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages build-tools)
  #:use-module (luhux packages lib)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils))


(define-public bmake
  (package
    (name "bmake")
    (version "20210206")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "http://www.crufty.net/ftp/pub/sjg/bmake-" version ".tar.gz"))
       (sha256
        (base32 "07n9avzdg6gifrzyddnyzada5s5rzklvbqfpv5drljpxcgpqpvwg"))))
    (build-system gnu-build-system)
    (inputs
     `(("bash" ,bash-minimal)))
    (native-inputs
     `(("coreutils" ,coreutils)))
    (arguments
     `(#:tests? #f                      ; test during build
       #:phases
       (modify-phases %standard-phases
         (add-after 'configure 'fix-test ; fix from nixpkgs
           (lambda _
             (substitute* "unit-tests/unexport-env.mk"
               (("PATH=\t/bin:/usr/bin:/sbin:/usr/sbin")
                "PATH := ${PATH}"))))
         (add-after 'configure 'remove-fail-tests
           (lambda _
             (substitute* "unit-tests/Makefile"
               (("cmd-interrupt") "")
               (("varmod-localtime") ""))
             #t)))
       #:configure-flags
       (list
        (string-append
         "--with-defshell=" (assoc-ref %build-inputs "bash") "/bin/bash")
        (string-append
         "--with-default-sys-path=" (assoc-ref %outputs "out") "/share/mk"))
       #:make-flags
       (list "INSTALL=install"))) ;; use coreutils install
    (home-page "http://www.crufty.net/help/sjg/bmake.htm")
    (synopsis "BSD's make")
    (description
     "bmake is a program designed to simplify the maintenance of other
programs.  Its input is a list of specifications as to the files upon which
programs and other files depend.")
    (license license:bsd-3)))

(define-public hikari
  (package
    (name "hikari")
    (version "2.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://hikari.acmelabs.space/releases/hikari-"
             version ".tar.gz"))
       (sha256
        (base32
         "1qsd1qb4bn24jh5658gxmfg6hk9p7g235gsbvnjrbfdjqsv8r6yz"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("bmake" ,bmake)
       ("pkg-config" ,pkg-config)
       ("wayland-protocols" ,wayland-protocols)))
    (inputs
     `(("wayland" ,wayland)
       ("wlroots" ,wlroots)
       ("libinput" ,libinput)
       ("cairo" ,cairo)
       ("pango" ,pango)
       ("libxkbcommon" ,libxkbcommon)
       ("libucl" ,libucl)
       ("pam" ,linux-pam)))
    (arguments
     `(#:tests? #f ; no tests
       #:make-flags
       (list
        (string-append "PREFIX=" (assoc-ref %outputs "out"))
        (string-append "CC=" ,(cc-for-target))
        "WITH_XWAYLAND=YES"
        "WITH_SCREENCOPY=YES"
        "WITH_LAYERSHELL=YES"
        "WITH_VIRTUAL_INPUT=YES")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'build
           (lambda* (#:key inputs outputs make-flags #:allow-other-keys)
             (apply invoke "bmake" make-flags)))
         (replace 'install
           (lambda* (#:key inputs outputs make-flags #:allow-other-keys)
             (apply invoke "bmake" "install" make-flags))))))
    (home-page "https://hikari.acmelabs.space/")
    (synopsis "stacking Wayland compositor with additional tiling capabilities")
    (description "stacking Wayland compositor with additional tiling
capabilities, it is heavily inspired by the Calm Window manager")
    (license license:bsd-2)))

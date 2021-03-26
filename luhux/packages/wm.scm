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
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils))


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
    (synopsis "Stacking Wayland compositor with additional tiling capabilities")
    (description "Stacking Wayland compositor with additional tiling
capabilities, it is heavily inspired by the Calm Window manager(cwm)")
    (license license:bsd-2)))

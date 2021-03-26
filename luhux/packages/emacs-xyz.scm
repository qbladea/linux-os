(define-module (luhux packages emacs-xyz)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (guix packages)
  #:use-module (guix build-system emacs)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils))

(define-public emacs-showtip
  (package
    (name "emacs-showtip")
    (version "20090830.1040")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/emacsorphanage/showtip")
             (commit
              "930da302809a4257e8d69425455b29e1cc91949b")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "01zak0zhha6dp7a2hm28d065gjnc462iwpsfyxhbxgfzcdlicqc7"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/emacsorphanage/showtip")
    (synopsis "Show tip at cursor")
    (description
     "This library export one function for elisp programer to show
tooltip near the cursor not the mouse.")
    (license license:gpl2+)))

(define-public emacs-sdcv
  (package
    (name "emacs-sdcv")
    (version "20190610.732")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/stardiviner/sdcv.el")
             (commit
              "943ae3e90cc9a0a88a37cc710acd7424fd4defc4")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0i1ylvw7p46pkf3yyyzcdmdhsspzymnnnvx8s0i7vynngr5x0vzh"))))
    (build-system emacs-build-system)
    (propagated-inputs
     `(("emacs-popup" ,emacs-popup)
       ("emacs-showtip" ,emacs-showtip)
       ("emacs-pos-tip" ,emacs-pos-tip)))
    (home-page
     "https://www.emacswiki.org/emacs/download/sdcv.el")
    (synopsis
     "Emacs interface for sdcv")
    (description
     "Translate word by sdcv (console version of Stardict), and display
translation use popup tooltip or buffer.")
    (license license:gpl3+)))

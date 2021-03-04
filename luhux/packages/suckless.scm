(define-module (luhux packages suckless)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages ncurses)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils))

(define-public mtm
  (let ((commit "cabd8704b9299d8b354ec8b403a6041bbddd2191")
        (revision "0"))
    (package
      (name "mtm")
      (version (git-version "1.2.0" revision commit))
      (source
       (origin
         (uri (git-reference
               (url "https://github.com/deadpixi/mtm")
               (commit commit)))
         (method git-fetch)
         (sha256
          (base32 "08crai3wxa6npd27y6qd290mj55l0bk8ibm4agyb002kbga8vkc7"))
         (file-name (git-file-name name version))))
      (build-system gnu-build-system)
      (inputs
       `(("ncurses" ,ncurses)))
      (arguments
       `(#:tests? #f ; no tests
         #:make-flags
         (list (string-append "CC=" ,(cc-for-target))
               (string-append "DESTDIR=" (assoc-ref %outputs "out")))
         #:phases
         (modify-phases %standard-phases
           (add-before 'build 'fix-headers
               (lambda _
                 (substitute* "config.def.h"
                   (("ncursesw/curses.h")
                    "curses.h"))))
           (replace 'install
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out")))
                 ;; install binary
                 (mkdir-p (string-append out "bin/"))
                 (install-file "mtm" (string-append out "/bin"))
                 ;; install manpage
                 (mkdir-p (string-append out "share/man/man1"))
                 (install-file "mtm.1" (string-append out "/share/man/man1"))
                 ;; install terminfo
                 (mkdir-p (string-append out "share/terminfo"))
                 (invoke (string-append (assoc-ref inputs "ncurses") "/bin/tic")
                         "-x" "-s" "-o"
                         (string-append
                          out "/share/terminfo")
                         "mtm.ti"))
               #t))
           (delete 'configure))))
      ;; FIXME: This should only be located in 'ncurses'.  Nonetheless it is
      ;; provided for usability reasons.  See <https://bugs.gnu.org/22138>.
      (native-search-paths
       (list (search-path-specification
              (variable "TERMINFO_DIRS")
              (files '("share/terminfo")))))
      (synopsis "Micro Terminal Multiplexer")
      (description
       "Micro Terminal Multiplexer")
      (license license:gpl3+)
      (home-page "https://github.com/deadpixi/mtm"))))


(define-public cmtm
  (let ((commit "20321a1a66d7437a371d2757e698c606e54c24e8")
        (revision "0"))
    (package
      (name "cmtm")
      (version (git-version "1.2.0" revision commit))
      (source
       (origin
         (uri (git-reference
               (url "https://github.com/1luhux1/cmtm")
               (commit commit)))
         (method git-fetch)
         (sha256
          (base32 "1213f3zwp5ndwal0d7d2q3wpas1wmw6ahyhifbfqssr78h3kxqgg"))
         (file-name (git-file-name name version))))
      (build-system gnu-build-system)
      (inputs
       `(("ncurses" ,ncurses)))
      (arguments
       `(#:tests? #f ; no tests
         #:make-flags
         (list (string-append "CC=" ,(cc-for-target))
               (string-append "DESTDIR=" (assoc-ref %outputs "out")))
         #:phases
         (modify-phases %standard-phases
           (add-before 'build 'fix-headers
               (lambda _
                 (substitute* "config.def.h"
                   (("ncursesw/curses.h")
                    "curses.h"))))
           (replace 'install
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out")))
                 ;; install binary
                 (mkdir-p (string-append out "bin/"))
                 (install-file "cmtm" (string-append out "/bin"))
                 ;; install manpage
                 (mkdir-p (string-append out "share/man/man1"))
                 (install-file "cmtm.1" (string-append out "/share/man/man1"))
                 ;; install terminfo
                 (mkdir-p (string-append out "share/terminfo"))
                 (invoke (string-append (assoc-ref inputs "ncurses") "/bin/tic")
                         "-x" "-s" "-o"
                         (string-append
                          out "/share/terminfo")
                         "mtm.ti"))
               #t))
           (delete 'configure))))
      ;; FIXME: This should only be located in 'ncurses'.  Nonetheless it is
      ;; provided for usability reasons.  See <https://bugs.gnu.org/22138>.
      (native-search-paths
       (list (search-path-specification
              (variable "TERMINFO_DIRS")
              (files '("share/terminfo")))))
      (synopsis "Micro Terminal Multiplexer(luhux 's version)")
      (description
       "Micro Terminal Multiplexer(luhux 's version")
      (license license:gpl3+)
      (home-page "https://github.com/1luhux1/cmtm"))))

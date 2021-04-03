(define-module (luhux manifest devel)
  #:use-module (guix profiles)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages w3m)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages code)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gdb)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages man)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages dictionaries)
  #:use-module (luhux packages stardict)
  #:use-module (gnu packages base))

(define-public guix-profile
   (list
    emacs
    emacs-rime
    emacs-w3m w3m
    emacs-magit git
    emacs-ggtags global
    emacs-geiser emacs-paredit
    gcc-toolchain-10 gdb
    clang-toolchain lldb
    guile-3.0 guix 
    texinfo man-db man-pages sicp
    emacs-which-key
    emacs-sdcv sdcv stardict-ecdict
    gnu-make))

(packages->manifest
 guix-profile)

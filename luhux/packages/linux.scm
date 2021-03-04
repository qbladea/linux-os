(define-module (luhux packages linux)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1))

(define-public linux-libre/lenovo100schromebook
  (package
    (inherit linux-libre-5.10)
    (name "linux-libre-lenovo100schromebook")
    (native-inputs
     `(("kconfig"
        ,(local-file
          "aux-files/linux-libre/linux-5.10-x86_64-lenovo100schromebook.conf"))
       ,@(alist-delete "kconfig"
                       (package-native-inputs linux-libre))))))

(define-module (luhux packages miner)
  #:use-module (gnu packages)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages tls)  
  #:use-module (guix packages)
  #:use-module (guix build-system cmake)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:))


(define-public xmrig
  (package
    (name "xmrig")
    (version "6.4.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/xmrig/xmrig/")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "04zrpksppyvz9h40sig30nmnkbyxaj39sqwjk1ls0nc6ypjz4xd5"))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (install-file
              "xmrig"
              (string-append (assoc-ref outputs "out") "/bin"))
             #t)))
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("hwloc" ,hwloc-2 "lib")
       ("libuv" ,libuv)
       ("ssl" ,libressl)))
    (synopsis "High performance, open source, cross platform CPU/GPU miner")
    (description "\
A high performance, open source, cross platform
RandomX, KawPow, CryptoNight and AstroBWT unified CPU/GPU miner")
    (home-page "https://github.com/xmrig/xmrig/")
    (license license:gpl3+)))

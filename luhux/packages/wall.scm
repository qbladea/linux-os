(define-module (luhux packages wall)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages syncthing)
  #:use-module (guix build-system go)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:))

(define-public go-github-com-dreamacro-go-shadowsocks2
  (package
    (name "go-github-com-dreamacro-go-shadowsocks2")
    (version "0.1.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Dreamacro/go-shadowsocks2.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "16sj8hwflgc7ls9if1ryv39sf72q2gn0zfcz4ld4ihchrh2ngz1d"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path
       "github.com/Dreamacro/go-shadowsocks2"))
    (inputs
     `(("go-golang-org-x-crypto"
        ,go-golang-org-x-crypto)))
    (home-page
     "https://github.com/Dreamacro/go-shadowsocks2")
    (synopsis "go-shadowsocks2")
    (description #f)
    (license license:asl2.0)))

(define-public go-github-com-go-chi-chi
  (package
    (name "go-github-com-go-chi-chi")
    (version "1.5.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-chi/chi.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1jpa4r5h15gkpfmb6xq1hamv0q20i8bdpw3kh7dw4n1v7pshjsr8"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/go-chi/chi"))
    (home-page "https://github.com/go-chi/chi")
    (synopsis #f)
    (description #f)
    (license license:expat)))

(define-public go-github-com-go-chi-cors
  (package
    (name "go-github-com-go-chi-cors")
    (version "1.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-chi/cors.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1p25c28kw1gy2f7hrd7a18vyy1sfcy62xlji846py1xw9cnnhgri"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/go-chi/cors"))
    (home-page "https://github.com/go-chi/cors")
    (synopsis "CORS net/http middleware")
    (description #f)
    (license license:expat)))

(define-public go-github-com-go-chi-render
  (package
    (name "go-github-com-go-chi-render")
    (version "1.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-chi/render.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "01mrl82zr8ij3241pi4sxksv70s8ndhqpgik4kwchn7l3067apf4"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/go-chi/render"))
    (home-page "https://github.com/go-chi/render")
    (synopsis "render")
    (description #f)
    (license license:expat)))

(define-public go-github-com-gofrs-uuid
  (package
    (name "go-github-com-gofrs-uuid")
    (version "4.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gofrs/uuid.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "08ma37vvrni836fxlswjd3bl2sdqyw3nxv6zdi1nyncnl9l0421k"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/gofrs/uuid"))
    (home-page "https://github.com/gofrs/uuid")
    (synopsis "UUID package for Go language")
    (description #f)
    (license license:expat)))

(define-public go-github-com-gorilla-websocket
  (package
    (name "go-github-com-gorilla-websocket")
    (version "1.4.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gorilla/websocket.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0mkm9w6kjkrlzab5wh8p4qxkc0icqawjbvr01d2nk6ykylrln40s"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/gorilla/websocket"))
    (home-page
     "https://github.com/gorilla/websocket")
    (synopsis "Gorilla WebSocket")
    (description #f)
    (license license:bsd-2)))

(define-public go-github-com-miekg-dns
  (package
    (name "go-github-com-miekg-dns")
    (version "1.1.40")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/miekg/dns.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1j5d2kbp9nfp290xf80b8zfhyvrgb5dvc2ziwx1dfyjr134axn5c"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/miekg/dns"))
    (inputs
     `(("go-golang-org-x-tools" ,go-golang-org-x-tools)
       ("go-golang-org-x-sys" ,go-golang-org-x-sys)
       ("go-golang-org-x-sync" ,go-golang-org-x-sync)
       ("go-golang-org-x-net" ,go-golang-org-x-net)
       ("go-golang-org-x-crypto"
        ,go-golang-org-x-crypto)))
    (home-page "https://github.com/miekg/dns")
    (synopsis #f)
    (description #f)
    (license license:bsd-3)))

(define-public go-go-uber-org-atomic
  (package
    (name "go-go-uber-org-atomic")
    (version "1.7.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/uber-go/atomic")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0yxvb5sixh76cl9j8dpa97gznj0p8pmg2cdw0ypfwhd3ipx9wph1"))))
    (build-system go-build-system)
    (arguments '(#:import-path "go.uber.org/atomic"))
    (inputs
     `(("go-github-com-stretchr-testify"
        ,go-github-com-stretchr-testify)
       ("go-github-com-davecgh-go-spew"
        ,go-github-com-davecgh-go-spew)))
    (home-page "https://go.uber.org/atomic")
    (synopsis "atomic")
    (description #f)
    (license license:expat)))



;; 无法构建，原因不明
(define-public go-github-com-dreamacro-clash
  (package
    (name "go-github-com-dreamacro-clash")
    (version "1.4.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Dreamacro/clash.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0lzrzf9amdi7fyxfmandqvbz7facs5mw1jy56j2zqfzfliqfbf9r"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path
       "github.com/Dreamacro/clash"))
    (inputs
     `(("go-gopkg-in-yaml-v2" ,go-gopkg-in-yaml-v2)
       ("go-golang-org-x-sys" ,go-golang-org-x-sys)
       ("go-golang-org-x-text" ,go-golang-org-x-text)
       ("go-golang-org-x-sync" ,go-golang-org-x-sync)
       ("go-golang-org-x-net" ,go-golang-org-x-net)
       ("go-golang-org-x-crypto"
        ,go-golang-org-x-crypto)
       ("go-go-uber-org-atomic" ,go-go-uber-org-atomic)
       ("go-github-com-stretchr-testify"
        ,go-github-com-stretchr-testify)
       ("go-github-com-sirupsen-logrus"
        ,go-github-com-sirupsen-logrus)
       ("go-github-com-oschwald-geoip2-golang"
        ,go-github-com-oschwald-geoip2-golang)
       ("go-github-com-miekg-dns"
        ,go-github-com-miekg-dns)
       ("go-github-com-gorilla-websocket"
        ,go-github-com-gorilla-websocket)
       ("go-github-com-gofrs-uuid"
        ,go-github-com-gofrs-uuid)
       ("go-github-com-go-chi-render"
        ,go-github-com-go-chi-render)
       ("go-github-com-go-chi-cors"
        ,go-github-com-go-chi-cors)
       ("go-github-com-go-chi-chi"
        ,go-github-com-go-chi-chi)
       ("go-github-com-dreamacro-go-shadowsocks2"
        ,go-github-com-dreamacro-go-shadowsocks2)))
    (home-page "https://github.com/Dreamacro/clash")
    (synopsis #f)
    (description #f)
    (license license:gpl3)))

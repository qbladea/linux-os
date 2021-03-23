(define-module (luhux operating-system lenovo-g470)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages vpn)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages admin)
  #:use-module (luhux packages wm)
  #:use-module (gnu services ssh)
  #:use-module (gnu services networking)
  #:use-module (gnu services linux)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  #:use-module (gnu services xorg)
  #:use-module (gnu services avahi)
  #:use-module (gnu system nss)
  #:use-module (luhux operating-system root)
  #:use-module ((luhux manifest luhux-with-wayland) :prefix luhux-with-wayland:))

(define-public lenovo-g470:os-host-name "lenovog470")
(define-public lenovo-g470:os-services
  (append
   (list
    (service openntpd-service-type)
    (service earlyoom-service-type)
    (service openssh-service-type
             (openssh-configuration
              (port-number 222)
              (password-authentication? #f)))
    (service nftables-service-type
             (nftables-configuration
              (ruleset "/etc/nftables.rule")))
    (service zram-device-service-type
             (zram-device-configuration
              (size "2G")
              (compression-algorithm 'zstd)
              (memory-limit "3G")
              (priority 100)))
    (service qemu-binfmt-service-type
             (qemu-binfmt-configuration
              (platforms
               (lookup-qemu-platforms
                "arm" "aarch64"
                "mips" "mips64"
                "riscv"))))
    (dbus-service)
    (elogind-service)
    (service network-manager-service-type
             (network-manager-configuration
              (dns "none")))
    (service wpa-supplicant-service-type)
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")))
    (service virtlog-service-type)
    (screen-locker-service hikari "hikari-unlocker")
    (screen-locker-service kbd "vlock")
    (service guix-publish-service-type
             (guix-publish-configuration
              (host "0.0.0.0")
              (port 8090)
              (compression '())
              (workers 8)
              (advertise? #t)))
    (service avahi-service-type
             (avahi-configuration
              (wide-area? #t))))
   (modify-services
       os-services
     (guix-service-type
      config =>
      (guix-configuration
       (inherit config)
       (authorized-keys
        (append
         (list
          (local-file "/srv/git/guixkey/119.45.133.18.pub")
          (local-file "/srv/git/guixkey/lenovog470.pub")
          (local-file "/srv/git/guixkey/lenovo100schromebook.pub"))
         %default-authorized-guix-keys))
       (discover? #t))))))

(define-public lenovo-g470:os-packages
  (append
   (list
    ;; 终端复用器
    tmux
    screen
    ;; VPN
    wireguard-tools
    ;; 支持CJK显示的终端
    kmscon
    ;; libvirt ssh 需要的依賴
    netcat-openbsd)
   luhux-with-wayland:guix-profile
   os-packages))

(define-public lenovo-g470:os-bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/sda")
   (terminal-outputs '(console))))

(define-public lenovo-g470:os-mapped-devices
  (list
   (mapped-device
    (source
     (uuid "746d5c91-2e09-4cbc-a860-59d4f7aeb88c"))
    (target "cryptroot")
    (type luks-device-mapping))))

(define-public lenovo-g470:os-file-systems
  (append
   (list
    (file-system
      (mount-point "/")
      (device "/dev/mapper/cryptroot")
      (type "btrfs")
      (options "compress-force=zstd:15")
      (check? #t)))
   %base-file-systems))

(define-public lenovo-g470:users
  (append
   (list
    (user-account
     (name "luhux")
     (comment "master")
     (group "luhux")
     (supplementary-groups
      (list
       "wheel"
       "audio"
       "video"
       "kvm"
       "libvirt"
       "users"))))
    %base-user-accounts))

(define-public lenovo-g470:groups
  (append
   (list
    (user-group
     (name "luhux")))
   %base-groups))


(define-public lenovo-g470:os-swap-devices
  (list
   "/var/swapfiles/0"
   "/var/swapfiles/1"))

(define-public lenovo-g470:os-setuid-programs
  (append
   (list)
   %setuid-programs))

(define-public lenovo-g470:os-name-service-switch
  %mdns-host-lookup-nss)

(define-public lenovo-g470:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments os-kernel-arguments)
    (kernel os-kernel)
    (issue os-issue)
    (skeletons os-skeletons)
    (host-name lenovo-g470:os-host-name)
    (services lenovo-g470:os-services)
    (packages lenovo-g470:os-packages)
    (users lenovo-g470:users)
    (groups lenovo-g470:groups)
    (mapped-devices lenovo-g470:os-mapped-devices)
    (file-systems lenovo-g470:os-file-systems)
    (swap-devices lenovo-g470:os-swap-devices)
    (bootloader lenovo-g470:os-bootloader)
    (setuid-programs lenovo-g470:os-setuid-programs)
    (name-service-switch lenovo-g470:os-name-service-switch)))

lenovo-g470:os

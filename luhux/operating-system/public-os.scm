;;
;; 用于公用的操作系统
;;

(define-module (luhux operating-system public-os)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages vpn)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages nano)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages virtualization)
  #:use-module (gnu packages games)
  #:use-module (gnu packages disk)
  #:use-module (gnu packages cryptsetup)
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


(define-public public-os:os-issue "Welcome!\n\n
this is a public machine !!! \n")
(define-public public-os:os-host-name "public")
(define-public public-os:os-services
  (append
   (list
    (service openntpd-service-type)
    (service earlyoom-service-type)
    (service openssh-service-type
             (openssh-configuration
              (password-authentication? #t)))
    (service nftables-service-type
             (nftables-configuration
              (ruleset "/etc/nftables.rule")))
    (dbus-service)
    (elogind-service)
    (service network-manager-service-type
             (network-manager-configuration
              (dns "none")))
    (service wpa-supplicant-service-type)
    (screen-locker-service hikari "hikari-unlocker")
    (screen-locker-service kbd "vlock")
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")))
    (service virtlog-service-type)
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
          (local-file "../key/119-45-133-18.pub")
          (local-file "../key/lenovog470.pub")
          (local-file "../key/lenovo100schromebook.pub")
          (local-file "../key/thinkpad-x230.pub"))
         %default-authorized-guix-keys))
       (discover? #t))))))

(define-public public-os:os-packages
  (append
   (list
    ;; VPN
    wireguard-tools
    ;; 支持CJK显示的终端+字体
    kmscon
    ;; libvirt ssh 需要的依賴
    netcat-openbsd
    ;; 文件系统
    btrfs-progs dosfstools
    ;; 加密
    cryptsetup)
   luhux-with-wayland:guix-profile
   (list
    ;; 资源监视器
    htop bmon iftop nload
    ;; 网络工具
    nmap tcpdump
    ;; 虚拟机
    qemu virt-manager
    ;; 游戏
    curseofwar nethack cataclysm-dda)
   os-packages))

(define-public public-os:os-bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/sda")))

(define-public public-os:os-mapped-devices
  (list
   (mapped-device
    (source
     (uuid "3b478c8f-8d54-46b5-a0ec-5287189dd248"))
    (target "public-os-root")
    (type luks-device-mapping))))

(define-public public-os:os-file-systems
  (append
   (list
    (file-system
      (mount-point "/")
      (device "/dev/mapper/public-os-root")
      (type "btrfs")
      (options "compress-force=zstd:15")
      (check? #t)))
   %base-file-systems))

(define-public public-os:users
  (append
   (list
    (user-account
     (name "public")
     (comment "master")
     (group "public")
     (supplementary-groups
      (list
       "wheel"
       "audio"
       "video"
       "kvm"
       "libvirt"
       "users"))))
    %base-user-accounts))

(define-public public-os:groups
  (append
   (list
    (user-group
     (name "public")))
   %base-groups))


(define-public public-os:os-swap-devices
  (list
   "/var/swapfiles/0"))

(define-public public-os:os-initrd-modules
  (append
   (list
    "i915")
   %base-initrd-modules))

(define-public public-os:os-setuid-programs
  (append
   (list)
   %setuid-programs))

(define-public public-os:os-name-service-switch
  %mdns-host-lookup-nss)

(define-public public-os:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments os-kernel-arguments)
    (kernel os-kernel)
    (initrd-modules public-os:os-initrd-modules)
    (issue public-os:os-issue)
    (skeletons os-skeletons)
    (host-name public-os:os-host-name)
    (services public-os:os-services)
    (packages public-os:os-packages)
    (users public-os:users)
    (groups public-os:groups)
    (mapped-devices public-os:os-mapped-devices)
    (file-systems public-os:os-file-systems)
    (swap-devices public-os:os-swap-devices)
    (bootloader public-os:os-bootloader)
    (setuid-programs public-os:os-setuid-programs)
    (name-service-switch public-os:os-name-service-switch)))

public-os:os

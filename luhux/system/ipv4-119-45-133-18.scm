(define-module (guix-config ipv4-119-45-133-18)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages vpn)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages admin)
  #:use-module (gnu services ssh)
  #:use-module (gnu services networking)
  #:use-module (gnu services linux)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  #:use-module (gnu services xorg)
  #:use-module (gnu services avahi)
  #:use-module (gnu services auditd)
  #:use-module (gnu system nss)
  #:use-module (guix-config root)
  #:use-module ((luhux manifest luhux) :prefix luhux:))

(define-public ipv4-119-45-133-18:os-host-name "119-45-133-18")
(define-public ipv4-119-45-133-18:os-services
  (append
   (list
    (service openntpd-service-type)
    (service earlyoom-service-type)
    (service openssh-service-type
	     (openssh-configuration
	      (port-number 222)
	      (password-authentication? #f)
	      (permit-root-login #f)))
    (service nftables-service-type
	     (nftables-configuration
	      (ruleset "/etc/nftables.rule")))
    (service zram-device-service-type
	     (zram-device-configuration
	      (size "512M")
	      (compression-algorithm 'zstd)
	      (memory-limit "1G")
	      (priority 100)))
    (service qemu-binfmt-service-type
	     (qemu-binfmt-configuration
	      (platforms
	       (lookup-qemu-platforms
		"arm" "aarch64"
                "mips" "mips64"
                "riscv"))
	      (guix-support? #t)))
    (dbus-service)
    (elogind-service)
    (service network-manager-service-type)
    (service wpa-supplicant-service-type)
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")))
    (service virtlog-service-type)
    (screen-locker-service kbd "vlock")
    (service guix-publish-service-type
             (guix-publish-configuration
              (host "0.0.0.0")
              (port 8090)
              (compression '(("lzip" 9)))
              (workers 4)
              (advertise? #t)))
    (service avahi-service-type
             (avahi-configuration
              (wide-area? #t)))
    (service auditd-service-type))
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
          (local-file "../key/lenovo100schromebook.pub"))
         %default-authorized-guix-keys))
       (discover? #t))))))

(define-public ipv4-119-45-133-18:os-packages
  (append
   (list
    ;; 终端复用器
    tmux
    screen
    ;; VPN
    wireguard-tools
    ;; audit
    audit
    )
   luhux:guix-profile
   os-packages))

(define-public ipv4-119-45-133-18:os-bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/vda")
   (terminal-outputs '(console))))

(define-public ipv4-119-45-133-18:os-file-systems
  (append
   (list
    (file-system
      (device "/dev/vda1")
      (mount-point "/boot")
      (type "ext4"))
    (file-system
      (device "/dev/vda2")
      (mount-point "/")
      (type "btrfs")
      (options "compress-force=zstd:15")))
   %base-file-systems))

(define-public ipv4-119-45-133-18:users
  (append
   (list
    (user-account
     (name "luhux")
     (comment "master")
     (group "luhux")
     (supplementary-groups
      (list
       "wheel"
       "libvirt"
       "users"))))
    %base-user-accounts))

(define-public ipv4-119-45-133-18:groups
  (append
   (list
    (user-group
     (name "luhux")))
   %base-groups))


(define-public ipv4-119-45-133-18:os-swap-devices
  (list
   "/var/swapfiles/0"
   "/var/swapfiles/1"))

(define-public ipv4-119-45-133-18:os-kernel-arguments
  (append
   (list "modprobe.blacklist=cirrus,cirrusfb")
   os-kernel-arguments))

(define-public ipv4-119-45-133-18:os-name-service-switch
  %mdns-host-lookup-nss)

(define-public ipv4-119-45-133-18:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments ipv4-119-45-133-18:os-kernel-arguments)
    (kernel os-kernel)
    (issue os-issue)
    (skeletons os-skeletons)
    (host-name ipv4-119-45-133-18:os-host-name)
    (services ipv4-119-45-133-18:os-services)
    (packages ipv4-119-45-133-18:os-packages)
    (users ipv4-119-45-133-18:users)
    (groups ipv4-119-45-133-18:groups)
    (file-systems ipv4-119-45-133-18:os-file-systems)
    (swap-devices ipv4-119-45-133-18:os-swap-devices)
    (bootloader ipv4-119-45-133-18:os-bootloader)
    (name-service-switch ipv4-119-45-133-18:os-name-service-switch)))

ipv4-119-45-133-18:os

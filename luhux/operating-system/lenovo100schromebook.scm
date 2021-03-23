(define-module (luhux operating-system lenovo100schromebook)
  #:use-module (gnu)
  #:use-module (guix modules)
  #:use-module (gnu packages)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages vpn)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages wm)
  #:use-module (luhux packages wm)
  #:use-module (luhux packages linux)
  #:use-module (gnu packages admin)
  #:use-module (gnu services ssh)
  #:use-module (gnu services networking)
  #:use-module (gnu services linux)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  #:use-module (gnu services xorg)
  #:use-module (gnu services avahi)
  #:use-module (gnu services mcron)
  #:use-module (gnu services sound)
  #:use-module (gnu services pm)
  #:use-module (gnu services dns)
  #:use-module (gnu services base)
  #:use-module (gnu system nss)
  #:use-module (luhux system bootloader grub)
  #:use-module (luhux operating-system root)
  #:use-module ((luhux manifest luhux-with-wayland) :prefix luhux-with-wayland:))

(define %battery-low-job
  #~(job
     '(next-minute (range 0 60 1))
     #$(program-file
        "battery-low.scm"
        (with-imported-modules (source-module-closure
                                '((guix build utils)))
          #~(begin
              (use-modules (guix build utils)
                           (ice-9 popen)
                           (ice-9 regex)
                           (ice-9 textual-ports)
                           (srfi srfi-2))

              ;; Shutdown when the battery percentage falls below %MIN-LEVEL.

              (define %min-level 10)

              (setenv "LC_ALL" "C")     ;ensure English output
              (and-let* ((input-pipe (open-pipe*
                                      OPEN_READ
                                      #$(file-append acpi "/bin/acpi")))
                         (output (get-string-all input-pipe))
                         (m (string-match "Discharging, ([0-9]+)%" output))
                         (level (string->number (match:substring m 1)))
                         ((< level %min-level)))
                (format #t "warning: Battery level is low (~a%)~%" level)
                (invoke #$(file-append shepherd "/sbin/shutdown")))

              ;; sleep when the battery percentage falls below %SLEEP-LEVEL.
              (define %sleep-level 20)

              (setenv "LC_ALL" "C")     ;ensure English output
              (and-let* ((input-pipe (open-pipe*
                                      OPEN_READ
                                      #$(file-append acpi "/bin/acpi")))
                         (output (get-string-all input-pipe))
                         (m (string-match "Discharging, ([0-9]+)%" output))
                         (level (string->number (match:substring m 1)))
                         ((< level %sleep-level)))
                (format #t "warning: Battery level is low (~a%)~%" level)
                (call-with-output-file "/sys/power/state"
                  (lambda (port)
                    (format port "mem")))))))))

(define-public lenovo100schromebook:os-host-name "lenovo100schromebook")
(define-public lenovo100schromebook:os-services
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
              (size "512M")
              (compression-algorithm 'zstd)
              (memory-limit "1G")
              (priority 100)))
    (dbus-service)
    (elogind-service)
    (service network-manager-service-type
             (network-manager-configuration
              (dns "none")))
    (service wpa-supplicant-service-type)
    (screen-locker-service hikari "hikari-unlocker")
    (screen-locker-service kbd "vlock")
    (service qemu-binfmt-service-type
             (qemu-binfmt-configuration
              (platforms
               (lookup-qemu-platforms
                "arm" "aarch64"
                "mips" "mips64"
                "riscv"))))
    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")))
    (service virtlog-service-type)
    (service guix-publish-service-type
             (guix-publish-configuration
              (host "0.0.0.0")
              (port 8090)
              (compression '())
              (workers 4)
              (advertise? #t)))
    (service avahi-service-type
             (avahi-configuration
              (wide-area? #t)))
    (simple-service 'battery-cron-jobs
                    mcron-service-type
                    (list %battery-low-job))
    (service alsa-service-type
             (alsa-configuration
              (pulseaudio? #t)))
    (service pulseaudio-service-type)
    (service tlp-service-type
             (tlp-configuration
              (tlp-default-mode "BAT")
              (cpu-scaling-governor-on-ac (list "ondemand"))))
    (service dnsmasq-service-type
             (dnsmasq-configuration
              (listen-addresses (list "127.0.0.1"))
              (servers (list
                        "114.114.114.114"
                        "8.8.8.8"
                        "1.1.1.1"))
              (cache-size 1024)))
    (rngd-service))
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

(define-public lenovo100schromebook:os-packages
  (append
   (list
    ;; 终端复用器
    tmux
    screen
    ;; VPN
    wireguard-tools
    ;; 支持CJK显示的终端+字体
    kmscon
    fontconfig
    font-gnu-unifont
    ;; efi vars tools
    efibootmgr
    ;; libvirt ssh 需要的依賴
    netcat-openbsd
    ;; cpu 频率调整
    cpupower)
   os-packages))


;; 
(define-public lenovo100schromebook:os-bootloader
  (bootloader-configuration
   (bootloader grub-efi-borken-bootloader)
   (target "/boot/efi")))

(define-public lenovo100schromebook:os-mapped-devices
  (list
   (mapped-device
    (source
     (uuid "2b06de2c-b917-48d3-8b25-3548319a0ba9"))
    (target "cryptroot")
    (type luks-device-mapping))))

(define-public lenovo100schromebook:os-file-systems
  (append
   (list
    (file-system
      (mount-point "/")
      (device "/dev/mapper/cryptroot")
      (type "btrfs")
      (options "compress-force=zstd:15")
      (check? #t)))
   %base-file-systems))

(define-public lenovo100schromebook:users
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

(define-public lenovo100schromebook:groups
  (append
   (list
    (user-group
     (name "luhux")))
   %base-groups))


(define-public lenovo100schromebook:os-swap-devices
  (list
   "/var/swapfiles/0"))

(define-public lenovo100schromebook:os-initrd-modules
  (append
   (list  ; graphic card
    "i915")
   (list ; keyboard
    "hid-generic"
    "hid"
    ;; usb
    "evdev"
    "ehci-pci"
    "ohci-pci"
    "xhci-pci"
    "usbhid")
   (list
    ;; emmc
    "sdhci-acpi"
    "mmc_block"
    ;; filesystem
    "btrfs"
    ;; crypto
    "dm-crypt"
    "xts"
    "serpent_generic"
    "wp512")))

(define-public lenovo100schromebook:os-setuid-programs
  (append
   (list)
   %setuid-programs))

(define-public lenovo100schromebook:os-name-service-switch
  %mdns-host-lookup-nss)

(define-public lenovo100schromebook:os-kernel-arguments
  (append
   (list "modprobe.blacklist=snd_soc_sst_cht_bsw_max98090_ti,uvcvideo")
   ;; disable not working sound card
   ;; disable camera autoload
   os-kernel-arguments))

(define-public lenovo100schromebook:os-kernel linux-libre/lenovo100schromebook)

(define-public lenovo100schromebook:os
  (operating-system
    (timezone os-timezone)
    (locale os-locale)
    (kernel-arguments lenovo100schromebook:os-kernel-arguments)
    (kernel lenovo100schromebook:os-kernel)
    (initrd-modules lenovo100schromebook:os-initrd-modules)
    (issue os-issue)
    (skeletons os-skeletons)
    (host-name lenovo100schromebook:os-host-name)
    (services lenovo100schromebook:os-services)
    (packages lenovo100schromebook:os-packages)
    (users lenovo100schromebook:users)
    (groups lenovo100schromebook:groups)
    (mapped-devices lenovo100schromebook:os-mapped-devices)
    (file-systems lenovo100schromebook:os-file-systems)
    (swap-devices lenovo100schromebook:os-swap-devices)
    (bootloader lenovo100schromebook:os-bootloader)
    (setuid-programs lenovo100schromebook:os-setuid-programs)
    (name-service-switch lenovo100schromebook:os-name-service-switch)))

lenovo100schromebook:os

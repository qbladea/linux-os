;; Guix 源码位置
(setq guix-source-dir "/srv/git/guix/")

;; Guix開發
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path guix-source-dir)
  (setq geiser-guile-binary (concat (getenv "GUIX_ENVIRONMENT") "/bin/guile")))

;; paredit
(add-hook 'scheme-mode-hook 'paredit-mode)

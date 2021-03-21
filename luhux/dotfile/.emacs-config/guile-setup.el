(setq guix-source-dir "/srv/git/guix/")
(setq guix-snippet-dir (concat guix-source-dir "etc/snippets/"))

;; Guix開發
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path guix-source-dir))
(with-eval-after-load 'yasnippet
  (add-to-list 'yas-snippet-dirs guix-snippet-dir))
;; 使用guile作为scheme实现
(setq scheme-program-name "guile")
;; paredit
(add-hook 'scheme-mode-hook 'paredit-mode)
;; 模板補全
(yas-global-mode 1)

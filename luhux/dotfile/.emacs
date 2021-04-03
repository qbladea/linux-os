;; 主题
(load-theme 'wombat)
;; 字体
(add-to-list 'default-frame-alist
             '(font . "unifont-13"))
;; 邮箱
(setq user-full-name "qblade")
(setq user-mail-address "qblade@protonmail.com")
;; 关闭欢迎页面
(setq inhibit-splash-screen t)
;; 括号高亮
(show-paren-mode 1)
;; 默认使用Linux内核代码风格
(setq c-default-style "linux")
;; paredit
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
;; Guix 源码位置
(if (getenv "GUIX_SOURCE_REPO")
    (setq guix-source-dir (getenv "GUIIX_SOURCE_REPO"))
  (setq guix-source-dir "/srv/code/git/guix/"))
;; Guix開發
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path guix-source-dir)
  (setq geiser-guile-binary (concat (getenv "GUIX_ENVIRONMENT") "/bin/guile")))
;; paredit
(add-hook 'scheme-mode-hook 'paredit-mode)
;; Blog 源码位置
(if (getenv "BLOG_REPO")
    (setq blog-repo-dir (getenv "BLOG_REPO"))
  (setq blog-repo-dir "/srv/code/git/blog"))
;; org-static-blog
(setq org-static-blog-publish-title "qblade's blog")
(setq org-static-blog-publish-url "https://qbladea.github.io/")
(setq org-static-blog-publish-directory blog-repo-dir)
(setq org-static-blog-posts-directory (concat blog-repo-dir "/posts/"))
(setq org-static-blog-drafts-directory (concat blog-repo-dir "/drafts/"))
(setq org-static-blog-enable-tags t)
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)
(setq org-static-blog-page-header
      "<meta name=\"author\" content=\"qbladea\">")
(setq org-static-blog-page-preamble
      "<div class=\"header\">
  <a href=\"https://qbladea.github.io\">qblade's blog</a>
  <a href=\"https://qbladea.github.io/me.html\">介绍</a>
</div>")
;; sdcv
(global-set-key (kbd "C-c t") 'sdcv-search-pointer)
;; which-key
(which-key-mode 1)

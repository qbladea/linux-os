(defun static-blog-setup ()
  (interactive)
  (setq org-static-blog-publish-title "qblade's blog")
  (setq org-static-blog-publish-url "https://qbladea.github.io/")
  (setq org-static-blog-publish-directory "/srv/git/blog/")
  (setq org-static-blog-posts-directory "/srv/git/blog/posts/")
  (setq org-static-blog-drafts-directory "/srv/git/blog/drafts/")
  (setq org-static-blog-enable-tags t)
  (setq org-export-with-toc nil)
  (setq org-export-with-section-numbers nil)
  (setq org-static-blog-page-header
"<meta name=\"author\" content=\"qbladea\">")
  (setq org-static-blog-page-preamble
"<div class=\"header\">
  <a href=\"https://qbladea.github.io\">qblade's blog</a>
  <a href=\"https://qbladea.github.io/me.html\">介绍</a>
</div>"))

(static-blog-setup)

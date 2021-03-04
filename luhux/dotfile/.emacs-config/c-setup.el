(defun setup-c-devel ()
  "初始化c開發環境"
  (interactive)
(add-hook 'c-mode-common-hook
	(lambda ()
	(when (derived-mode-p 'c-mode)
	(ggtags-mode 1)))))

(setup-c-devel)

(defun setup-telega ()
  (setq telega-proxies
	(list
	 '(:server "10.0.1.1"
		   :port 9050
		   :enable t
		   :type (:@type "proxyTypeSocks5")))))


(setup-telega)

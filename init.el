(require 'package)
(setq package-archives
      '(("melpa"
	 . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(require 'company)
(require 'cc-mode)
;;(require 'csharp-mode)
(defun my-csharp-mode ()
  (add-to-list 'company-backends 'company-omnisharp)
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)
  (turn-on-eldoc-mode))

(setq omnisharp-company-strip-trailing-brackets nil)
(add-hook 'csharp-mode-hook 'my-csharp-mode)

(tool-bar-mode -1)
(load-theme 'monokai t)

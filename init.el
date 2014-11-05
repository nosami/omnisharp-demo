(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
(require 'package)
(setq package-archives
      '(("melpa"
	 . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;Recursively add site-lisp to the load path
;Make sure custom stuff goes to the front of the list
(let ((default-directory "~/.emacs.d/site-lisp"))
  (let ((old-path (copy-sequence load-path))
                (new-load-path nil))
        (normal-top-level-add-to-load-path '("."))
        (normal-top-level-add-subdirs-to-load-path)
        (dolist (var load-path)
          (unless (memql var old-path)
                (add-to-list 'new-load-path var)
                (setq load-path (append new-load-path old-path))))))

(require 'company)
(require 'cl)
(require 'csharp-mode)
(defun my-csharp-mode ()
  (add-to-list 'company-backends 'company-omnisharp)
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)
  (turn-on-eldoc-mode))
(setq eldoc-idle-delay 0.1
      flycheck-display-errors-delay 0.2)

(setq omnisharp-company-strip-trailing-brackets nil)
(add-hook 'csharp-mode-hook 'my-csharp-mode)
(set-scroll-bar-mode nil)
(tool-bar-mode -1)
(load-theme 'monokai t)
(setq company-begin-commands '(self-insert-command))
(setq omnisharp-company-do-template-completion t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-frontends
   (quote
    (company-pseudo-tooltip-frontend company-echo-metadata-frontend)))
 '(company-idle-delay 0.03)
 '(company-minimum-prefix-length 1)
 '(company-show-numbers t)
 '(cua-mode t nil (cua-base))
 '(helm-ag-insert-at-point (quote word))
 '(omnisharp-auto-complete-want-documentation nil)
 '(omnisharp-company-sort-results t)
 '(omnisharp-server-executable-path
   (quote /Users/jason/\.vim/bundle/Omnisharp/server/OmniSharp/bin/Debug/OmniSharp\.exe))
 '(safe-local-variable-values
   (quote
    ((eval when
	   (fboundp
	    (quote rainbow-mode))
	   (rainbow-mode 1)))))
 '(savehist-mode t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(when mswindows-p
  (set-face-attribute 'default nil
		      :family "Consolas" :height 100))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 
 '(company-tooltip-annotation ((t (:inherit company-tooltip :foreground "yellow")))))
(global-hl-line-mode 1)
(setq c-basic-offset 4) ; indents 4 chars
(setq tab-width 4)          ; and 4 char wide for TAB
(setq indent-tabs-mode nil) ; And force use of spaces 
;; To customize the background color
(set-face-background 'hl-line "#333")
(setq ring-bell-function 'ignore)

(show-paren-mode t)
(global-set-key (kbd "M-x") 'smex)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)



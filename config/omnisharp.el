(define-key company-active-map (kbd ".") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '".")))
(define-key company-active-map (kbd "]") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '"]")))
(define-key company-active-map (kbd "[") (lambda() (interactive) (company-complete-selection-insert-key '"[")))
(define-key company-active-map (kbd ")") (lambda() (interactive) (company-complete-selection-insert-key '")")))
(define-key company-active-map (kbd "<SPC>") nil)
(define-key company-active-map (kbd ";") (lambda() (interactive) (company-complete-selection-insert-key '";")))
(define-key company-active-map (kbd ">") (lambda() (interactive) (company-complete-selection-insert-key '">")))
(define-key omnisharp-mode-map (kbd "}") 'csharp-indent-function-on-closing-brace) 
(define-key omnisharp-mode-map (kbd "<RET>") 'csharp-newline-and-indent) 

(define-key omnisharp-mode-map (kbd "<f12>") 'omnisharp-go-to-definition )
(define-key omnisharp-mode-map (kbd "s-d") 'omnisharp-go-to-definition)
(define-key omnisharp-mode-map (kbd "S-<f12>") 'omnisharp-helm-find-usages)

(define-key omnisharp-mode-map (kbd "s-u") 'omnisharp-helm-find-usages)
(define-key omnisharp-mode-map (kbd "s-i") 'omnisharp-helm-find-implementations)
(define-key omnisharp-mode-map (kbd "S-s-<f12>") 'omnisharp-helm-find-usages)
(define-key omnisharp-mode-map (kbd "<M-RET>") 'omnisharp-run-code-action-refactoring)
(define-key omnisharp-mode-map (kbd "C-.") 'omnisharp-run-code-action-refactoring)

(define-key omnisharp-mode-map (kbd "C-k C-d") 'omnisharp-code-format)
(define-key omnisharp-mode-map (kbd "C-d") 'duplicate-current-line-or-region)

(define-key omnisharp-mode-map (kbd "<f2>") 'omnisharp-rename-interactively)
(define-key omnisharp-mode-map (kbd "<f5>") 'omnisharp-build-in-emacs)

;; disable emacs ctrl-r key.... we need it for VS shortcuts
(global-unset-key "\C-r")
(define-key omnisharp-mode-map (kbd "C-r C-t") (lambda() (interactive) (omnisharp-unit-test "single")))
(define-key omnisharp-mode-map (kbd "C-r C-a") (lambda() (interactive) (omnisharp-unit-test "all")))
(define-key omnisharp-mode-map (kbd "C-r C-l") 'recompile)
(define-key omnisharp-mode-map (kbd "C-r C-r") 'omnisharp-rename)

(define-key omnisharp-mode-map (kbd "<M-RET>") 'omnisharp-run-code-action-refactoring)
(define-key omnisharp-mode-map (kbd "<C-.>") 'omnisharp-run-code-action-refactoring)

;; disable emacs ctrl-k key.... we need it for VS shortcuts
(global-unset-key "\C-k")
(global-set-key (kbd "C-k C-c") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-k C-u") 'comment-or-uncomment-region-or-line)

(require 'csharp-mode)

(defun my-csharp-mode ()
  (add-to-list 'company-backends 'company-omnisharp)
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)
  (linum-mode)
  (whole-line-or-region-mode)
  (autopair-mode)
  (setq c-basic-offset 4) ; indents 4 chars
  (setq tab-width 4)          ; and 4 char wide for TAB
  (setq indent-tabs-mode nil) ; And force use of spaces
  (turn-on-eldoc-mode))
  (setq eldoc-idle-delay 0.1
      flycheck-display-errors-delay 0.2)

(setq omnisharp-company-strip-trailing-brackets nil)
(add-hook 'csharp-mode-hook 'my-csharp-mode)
(defun omnisharp-unit-test (mode)
  "Run tests after building the solution. Mode should be one of 'single', 'fixture' or 'all'" 
  (interactive)
  (let ((test-response
         (omnisharp-post-message-curl-as-json
          (concat (omnisharp-get-host) "gettestcontext") 
          (cons `("Type" . ,mode) (omnisharp--get-common-params)))))
    (let ((test-command
           (cdr (assoc 'TestCommand test-response)))

          (test-directory
           (cdr (assoc 'Directory test-response))))
      (cd test-directory)
      (compile test-command))))

(setq-default cursor-type 'bar)
(setq omnisharp-company-match-type 'company-match-flx)
(setq gc-cons-threshold 20000000)

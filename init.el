(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
(cua-mode 1);; cut / copy / paste for noobs
(defun find-project-root ()
  (interactive)
  (if (ignore-errors (eproject-root))
      (eproject-root)
    (or (find-git-repo (buffer-file-name)) (file-name-directory (buffer-file-name)))))

(defun find-git-repo (dir)
  (if (string= "/" dir) full	
      nil
    (if (file-exists-p (expand-file-name "../.git/" dir))
        dir
      (find-git-repo (expand-file-name "../" dir)))))


(defun file-path-to-namespace ()
  (interactive)
  (let (
        (root (find-project-root))
        (base (file-name-nondirectory buffer-file-name))
        )
    (substring (replace-regexp-in-string "/" "\." (substring buffer-file-name (length root) (* -1 (length base))) t t) 0 -1)
    )
  )

(defun csharp-should-method-space-replace ()
  "When pressing space while naming a defined method, insert an underscore"
  (interactive)
  (if (and (looking-back "void Should.*")
           (not (and
                 (looking-at ".*)$")
                 (looking-back "(.*"))))
      (insert "_")
    (insert " ")))

(eval-after-load 'csharp-mode
  '(progn
     (define-key csharp-mode-map (kbd "SPC") 'csharp-should-method-space-replace)))

(require 'package)
(setq package-archives
      '(("melpa"
         . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments current current line or whole lines in region."
  (interactive)
  (save-excursion
    (let (min max)
      (if (region-active-p)
          (setq min (region-beginning) max (region-end))
        (setq min (point) max (point)))
      (comment-or-uncomment-region
       (progn (goto-char min) (line-beginning-position))
       (progn (goto-char max) (line-end-position))))))

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
(require 'csharp-mode)

(defun my-csharp-mode ()
  (add-to-list 'company-backends 'company-omnisharp)
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)
  (setq c-basic-offset 4) ; indents 4 chars
  (setq tab-width 4)          ; and 4 char wide for TAB
  (setq indent-tabs-mode nil) ; And force use of spaces
  (turn-on-eldoc-mode))
  (setq eldoc-idle-delay 0.1
      flycheck-display-errors-delay 0.2)

(setq omnisharp-company-strip-trailing-brackets nil)
(add-hook 'csharp-mode-hook 'my-csharp-mode)
(set-scroll-bar-mode nil)
(tool-bar-mode -1)
(load-theme 'monokai t)
(setq company-begin-commands '(self-insert-command))
(setq omnisharp-company-do-template-completion nil)
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
 '(company-require-match nil)
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

(fset 'yes-or-no-p 'y-or-n-p) ;;stop asking me to type ‘yes’ as a confirmation
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(define-key company-active-map (kbd "<tab>") 'tab-indent-or-complete)

(defun dos2unix (buffer)
  "Automate M-% C-q C-m RET C-q C-j RET"
  (interactive "*b")
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (string ?\C-m) nil t)
      (replace-match "" nil t)))
  nil
  )

(require 'helm-config)
(require 'helm-command)
(require 'helm-elisp)
(require 'helm-misc)
(require 'omnisharp)
(setq compilation-ask-about-save nil)
;; disable emacs ctrl-k key.... we need it for VS shortcuts
(global-unset-key "\C-k")
(global-set-key (kbd "C-x f") 'helm-for-files)
(global-set-key (kbd "C-k C-c") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-k C-u") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-x f") 'helm-for-files)

;; find current buffer in directory
(global-set-key (kbd "C-M-l") 'dired-jump)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(define-key helm-map (kbd "C-j") 'helm-next-line)
(define-key helm-map (kbd "C-k") 'helm-previous-line)
;;VS keys
(define-key omnisharp-mode-map (kbd "<f12>") 'omnisharp-go-to-definition )
(define-key omnisharp-mode-map (kbd "s-d") 'omnisharp-go-to-definition)

(define-key omnisharp-mode-map (kbd "S-<f12>") 'omnisharp-helm-find-usages)
(define-key omnisharp-mode-map (kbd "s-u") 'omnisharp-helm-find-usages)
(define-key omnisharp-mode-map (kbd "S-s-<f12>") 'omnisharp-helm-find-usages)
(define-key omnisharp-mode-map (kbd "<M-RET>") 'omnisharp-run-code-action-refactoring)
(define-key omnisharp-mode-map (kbd "<C-.>") 'omnisharp-run-code-action-refactoring)

(define-key omnisharp-mode-map (kbd "C-k C-d") 'omnisharp-code-format)

(define-key omnisharp-mode-map (kbd "<f2>") 'omnisharp-rename-interactively)
(define-key omnisharp-mode-map (kbd "<f5>") 'omnisharp-build-in-emacs)
(define-key global-map (kbd "s-<left>") 'beginning-of-line)
(define-key global-map (kbd "s-<right>") 'end-of-line)
(define-key global-map (kbd "s-<up>") 'scroll-down)
(define-key global-map (kbd "s-<down>") 'scroll-up)
(define-key global-map (kbd "s-f") 'toggle-frame-fullscreen)
(define-key global-map (kbd "C-g") 'goto-line)

;; disable emacs ctrl-r key.... we need it for VS shortcuts
(global-unset-key "\C-r")
;; enable ctrl-s to wrap around seeing as we disabled ctrl-r
(defadvice isearch-repeat (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)))

(define-key omnisharp-mode-map (kbd "C-r C-t") (lambda() (interactive) (omnisharp-unit-test "single")))
(define-key omnisharp-mode-map (kbd "C-r C-a") (lambda() (interactive) (omnisharp-unit-test "all")))
(define-key omnisharp-mode-map (kbd "C-r C-l") 'recompile)
(define-key omnisharp-mode-map (kbd "C-r C-r") 'omnisharp-rename)

(define-key omnisharp-mode-map (kbd "<M-RET>") 'omnisharp-run-code-action-refactoring)
(define-key omnisharp-mode-map (kbd "<C-.>") 'omnisharp-run-code-action-refactoring)
(require 'key-chord)
(key-chord-mode 1)

(setq key-chord-one-key-delay 0.2)
(setq key-chord-two-keys-delay 0.15)
(define-key global-map (kbd "C-,") 'helm-projectile)
(define-key company-active-map (kbd "C-j") 'company-select-next-or-abort)
(define-key company-active-map (kbd "C-k") 'company-select-previous-or-abort)
;; show tabs and trailing whitespace
(global-whitespace-mode)
(setq whitespace-style '(trailing tabs tab-mark))

(define-key global-map (kbd "s-j") 'ace-jump-mode)

(defun company-complete-selection-insert-key(company-key)
  (company-complete-selection)
  (insert company-key))

(defun company-complete-selection-insert-key-and-complete(company-key)
  (company-complete-selection-insert-key company-key)
  (company-complete))

;; better than vim-vinegar
(require 'dired)

(define-key company-active-map (kbd ".") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '".")))
(define-key company-active-map (kbd "(") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '"(")))
(define-key company-active-map (kbd "]") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '"]")))
(define-key company-active-map (kbd "[") (lambda() (interactive) (company-complete-selection-insert-key '"[")))
(define-key company-active-map (kbd ")") (lambda() (interactive) (company-complete-selection-insert-key '")")))
(define-key company-active-map (kbd "<SPC>") nil)
(define-key company-active-map (kbd ";") (lambda() (interactive) (company-complete-selection-insert-key '";")))
(define-key company-active-map (kbd ">") (lambda() (interactive) (company-complete-selection-insert-key '">")))
(global-set-key (kbd "C-x f") 'helm-for-files)
(global-set-key [M-left] 'elscreen-previous)
(global-set-key [M-right] 'elscreen-next)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(setq inhibit-splash-screen t) ;;disable splash screen
(fset 'yes-or-no-p 'y-or-n-p) ;;stop asking me to type ‘yes’ as a confirmation
(show-paren-mode t)
;;Ido mode for file completion:
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
;;ido for better buffer management:
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-f") 'helm-for-files)
;;window movement
;;(global-set-key (kbd "C-h") 'windmove-left)
;;(global-set-key (kbd "C-l") 'windmove-right)
;;(global-set-key (kbd "C-j") 'windmove-down)
;;(global-set-key (kbd "C-k") 'windmove-up)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)
(setq ring-bell-function 'ignore)

(projectile-global-mode)
(setq projectile-indexing-method 'alien)

(setq c-basic-offset 4) ; indents 4 chars
(setq tab-width 4)          ; and 4 char wide for TAB
(setq indent-tabs-mode nil) ; And force use of spaces


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


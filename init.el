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

;; (setq evil-want-C-u-scroll t)
;; (require 'evil-jumper)
;; (require 'evil-visualstar)
;; (global-evil-leader-mode)
;; (global-evil-tabs-mode t)
;; ;(evil-mode 1)
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
(require 'cl)
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

;; disable emacs ctrl-k key.... we need it for VS shortcuts
(global-unset-key "\C-k")
(global-set-key (kbd "C-x f") 'helm-for-files)
(global-set-key (kbd "C-k C-c") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-k C-u") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-x f") 'helm-for-files)

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

(require 'key-chord)
(key-chord-mode 1)

(setq key-chord-one-key-delay 0.2)
(setq key-chord-two-keys-delay 0.15)
;; (define-key evil-normal-state-map (kbd "<SPC> a") 'helm-ag)
;; (key-chord-define evil-insert-state-map "jk"  'evil-normal-state) 
;; (key-chord-define evil-replace-state-map "jk"  'evil-normal-state) 
;; (key-chord-define evil-insert-state-map "kj"  'evil-normal-state) 
;; (key-chord-define evil-replace-state-map "kj"  'evil-normal-state) 
;; (key-chord-define global-map "fj" 'smex)
;; (key-chord-define evil-insert-state-map "
;; (define-key evil-insert-state-map (kbd "j k") 'evil-normal-state)

;; (define-key evil-insert-state-map (kbd "k j") 'evil-normal-state)
(define-key global-map (kbd "C-p") 'helm-projectile)
(define-key global-map (kbd "C-,") 'helm-projectile)
;; (define-key evil-normal-state-map (kbd "<SPC> e") 'find-file)
;; (define-key evil-normal-state-map (kbd "<SPC> w") 'evil-write)

;; (define-key evil-normal-state-map (kbd "M-J") 'flycheck-next-error)
;; (define-key evil-normal-state-map (kbd "M-K") 'flycheck-previous-error)

;; (define-key evil-normal-state-map (kbd "<SPC> cc") 'comment-or-uncomment-region-or-line)
;; (define-key evil-visual-state-map (kbd "<SPC> cc") 'comment-or-uncomment-region-or-line)
;; (define-key evil-normal-state-map (kbd "<SPC> c <SPC>") 'comment-or-uncomment-region-or-line)
;; (define-key evil-visual-state-map (kbd "<SPC> c <SPC>") 'comment-or-uncomment-region-or-line)
;; (define-key evil-normal-state-map (kbd "<SPC> cn") 'next-error)
;; (define-key evil-normal-state-map (kbd "<SPC> cp") 'previous-error)
;; (define-key evil-insert-state-map (kbd "<RET>") 'newline-and-indent)

(define-key company-active-map (kbd "C-j") 'company-select-next-or-abort)
(define-key company-active-map (kbd "C-k") 'company-select-previous-or-abort)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "g d") 'omnisharp-go-to-definition)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> b") 'omnisharp-build-in-emacs)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> cf") 'omnisharp-code-format)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> nm") 'omnisharp-rename-interactively)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> fu") 'omnisharp-helm-find-usages)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<M-RET>") 'omnisharp-run-code-action-refactoring)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> ss") 'omnisharp-start-omnisharp-server)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> sp") 'omnisharp-stop-omnisharp-server)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> fi") 'omnisharp-find-implementations)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> x") 'omnisharp-fix-code-issue-at-point)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> fx") 'omnisharp-fix-usings)
;; (evil-define-key 'normal omnisharp-mode-map (kbd "<SPC> o") 'omnisharp-auto-complete-overrides)

;; (define-key evil-normal-state-map (kbd "<SPC> rt") (lambda() (interactive) (omnisharp-unit-test "single")))
;; (define-key evil-normal-state-map (kbd "<SPC> rf") (lambda() (interactive) (omnisharp-unit-test "fixture")))
;; (define-key evil-normal-state-map (kbd "<SPC> ra") (lambda() (interactive) (omnisharp-unit-test "all")))
;; (define-key evil-normal-state-map (kbd "<SPC> rl") 'recompile)


(global-whitespace-mode)
(setq whitespace-style '(trailing tabs tab-mark))


(define-key global-map (kbd "C-<RET>") 'ace-jump-mode)
;; (define-key evil-normal-state-map (kbd "<SPC> <SPC>") 'ace-jump-mode)
;; (mapc (lambda (mode) (evil-set-initial-state mode 'emacs))
;;       '(eshell-mode
;;         git-rebase-mode
;;         term-mode
;;         magit-branch-manager-mode
;;         eww-mode
;;         ))i

;; (eval-after-load "eww"
;;   '(progn (define-key eww-mode-map "f" 'eww-lnum-follow)
;;           (define-key eww-mode-map (kbd "o") 'eww)
          
;;           (define-key eww-mode-map (read-kbd-macro "/") 'evil-search-forward)
;;           (define-key eww-mode-map (read-kbd-macro "?") 'evil-search-backward)
;;           (define-key eww-mode-map (read-kbd-macro "n") 'evil-search-next)
;;           (define-key eww-mode-map (read-kbd-macro "N") 'evil-search-previous)
;;           (define-key eww-mode-map (read-kbd-macro "r") 'eww-reload)

          
;;           (define-key eww-mode-map (read-kbd-macro "j") 'evil-next-line)
;;           (define-key eww-mode-map (read-kbd-macro "k") 'evil-previous-line)
;;           (define-key eww-mode-map (read-kbd-macro "C-j") (lambda () (interactive) (next-line 2) (scroll-up 2)))
;;           (define-key eww-mode-map (read-kbd-macro "C-k") (lambda () (interactive) (scroll-down 2) (previous-line 2)))
;;           (define-key eww-mode-map (read-kbd-macro "d") 'evil-scroll-down)
;;           (define-key eww-mode-map (read-kbd-macro "u") 'evil-scroll-up)

;;           (define-key eww-mode-map (read-kbd-macro "C-d") 'evil-scroll-down)
;;           (define-key eww-mode-map (read-kbd-macro "C-u") 'evil-scroll-up)
          
;;           (define-key eww-mode-map (read-kbd-macro "b") 'eww-back-url)
;;           (define-key eww-mode-map (read-kbd-macro "<backspace>") 'eww-back-url)
;;           (define-key eww-mode-map (read-kbd-macro "S-<backspace>") 'eww-forward-url)
;;           (define-key eww-mode-map "F" 'eww-lnum-universal)))


;; (require 'w3m-load)
;; (define-key w3m-mode-map (kbd "f") 'w3m-lnum-follow)
;; (define-key w3m-mode-map (kbd "o") 'w3m-goto-url)
;; (define-key w3m-mode-map (kbd "<SPC>") 'ace-jump-mode)
;; (define-key w3m-mode-map (kbd "C-u") 'w3m-scroll-down-or-previous-url)
;; (define-key w3m-mode-map (kbd "C-d") 'w3m-scroll-up-or-next-url)
;; (define-key w3m-mode-map (kbd "C-u") 'w3m-view-previous-page)
(require 'twittering-mode)
(define-key twittering-mode-map (kbd "C-d") 'twittering-scroll-up)
(define-key twittering-mode-map (kbd "C-u") 'twittering-scroll-down)
;; (define-key twittering-mode-map (read-kbd-macro "/") 'evil-search-forward)
;; (define-key twittering-mode-map (read-kbd-macro "?") 'evil-search-backward)
;; (define-key twittering-mode-map (read-kbd-macro "n") 'evil-search-next)
;; (define-key twittering-mode-map (read-kbd-macro "N") 'evil-search-previous)
;; (define-key twittering-mode-map (kbd "<tab>") 'twittering-goto-next-uri)
;;(setq twittering-use-master-password t)

(defun company-complete-selection-insert-key(company-key)
  (company-complete-selection)
  (insert company-key))

(defun company-complete-selection-insert-key-and-complete(company-key)
  (company-complete-selection-insert-key company-key)
  (company-complete))

;; better than vim-vinegar
(require 'dired)
;; (define-key evil-normal-state-map (kbd "-") 'dired-jump)
;; (define-key dired-mode-map (kbd "-") 'dired-up-directory)

(define-key company-active-map (kbd ".") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '".")))
(define-key company-active-map (kbd "(") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '"(")))
(define-key company-active-map (kbd "]") (lambda() (interactive) (company-complete-selection-insert-key-and-complete '"]")))
(define-key company-active-map (kbd "[") (lambda() (interactive) (company-complete-selection-insert-key '"[")))
(define-key company-active-map (kbd ")") (lambda() (interactive) (company-complete-selection-insert-key '")")))
(define-key company-active-map (kbd "<SPC>") nil)
(define-key company-active-map (kbd ";") (lambda() (interactive) (company-complete-selection-insert-key '";")))
(define-key company-active-map (kbd ">") (lambda() (interactive) (company-complete-selection-insert-key '">")))
;; (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word)
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
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-l") 'windmove-right)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(autoload 'ibuffer "ibuffer" "List buffers." t)
;;Make emacs backups happen elsewhere:
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/")))) ;; Save all backup file in this directory.
(setq auto-save-file-name-transforms `((".*", "~/.emacs_backups/" t)))
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

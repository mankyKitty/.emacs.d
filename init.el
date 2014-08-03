;;; My init file, which is a blatant copy.
(require 'cask)
(cask-initialize)

(require 'req-package)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(req-package ido
  :config
  (ido-mode t))

(req-package evil
  :require (helm-config undo-tree surround ace-jump-mode)
  :ensure evil
  :init
  (progn
    (setq evil-default-cursor t)
    (evil-mode 1)
    (setq evil-motion-state-modes
	  (append evil-emacs-state-modes evil-motion-state-modes))
    (setq evil-emacs-state-modes '(magit-mode dired-mode)))
  :config
  (progn
    (evil-ex-define-cmd "e[dit]" 'helm-find-files)
    (evil-ex-define-cmd "b[uffer]" 'helm-buffers-list)
    (bind-key "[escape]" 'keyboard-escape-quit evil-normal-state-map)
    (bind-key "[escape]" 'keyboard-escape-quit evil-visual-state-map)
    (bind-key "<escape>" 'keyboard-escape-quit)
    (bind-key "\"" 'ace-jump-mode evil-normal-state-map)
    (evil-define-key 'normal
		     tern-mode-keymap "gd" 'tern-find-definition)))

(req-package evil-leader
	     :require evil
	     :ensure evil-leader
	     :init
	     (progn
	       (evil-leader/set-leader "<SPC>")
	       (global-evil-leader-mode 1)
	       (evil-leader/set-key
		 "l" 'org-insert-link
		 "o" 'other-window
		 "d" 'delete-window
		 "D" 'delete-other-windows
		 "h" 'split-window-below
		 "v" 'split-window-right
		 "k" 'kill-buffer
		 "K" 'kill-buffer-and-window
		 "f" 'dired
		 "gs" 'magit-status)))

(req-package evil-numbers
	     :require evil
	     :config
	     (progn
	       (bind-key "C-a" 'evil-numbers/inc-at-pt evil-normal-state-map)
	       (bind-key "C-x" 'evil-numbers/dec-at-pt evil-normal-state-map)))

(req-package undo-tree
	     :diminish ""
	     :init
	     (progn
	       (setq undo-tree-auto-save-history t)
	       (global-undo-tree-mode)))

(req-package dired+)

(req-package smex
             :require ido
             :bind (("M-t" . smex)
                    ("M-X" . smex-major-mode-commands)
                    ;; This is old M-t.
                    ("C-c C-c M-t" . execute-extended-command)))

(req-package ace-jump-mode)

(req-package org
  :config
  (progn
    (add-hook 'org-mode-hook
	      '(lambda ()
		 (setq mode-name " ꙮ ")))
    (bind-key* "C-c c" 'org-capture)
    (bind-key* "C-c l" 'org-store-link)
    (bind-key* "C-c a" 'org-agenda)
    (bind-key* "C-c b" 'org-iswitch)))

(defadvice load-theme
  (before theme-dont-propagate activate)
  (mapc #'disable-theme custom-enabled-themes))

(req-package smart-mode-line
	     :require nyan-mode
	     :init (sml/setup))

(req-package nyan-mode
         :init
         (progn
           (nyan-mode)
           (setq nyan-wavy-trail t))
         :config (nyan-start-animation))

(req-package faces
             :config
             (progn
               (set-face-attribute 'default nil :family "Source Code Pro")
               (set-face-attribute 'default nil :height 120)))

(req-package scroll-bar
             :config
             (scroll-bar-mode -1))

(req-package tool-bar
             :config
             (tool-bar-mode -1))

(req-package menu-bar
             :config
             (menu-bar-mode -1))

(req-package diminish)

(req-package server
             :diminish (server-buffer-clients . ""))

(req-package flycheck
  :diminish (global-flycheck-mode . " ✓ ")
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode))

(req-package magit
  :diminish magit-auto-revert-mode)

(req-package linum
  :config
  (add-hook 'prog-mode-hook
            '(lambda () (linum-mode 1))))

(req-package smartparens-config
  :ensure smartparens
  :diminish (smartparens-mode . "()")
  :init (smartparens-global-mode t))

(req-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(req-package haskell-mode
  :require (flycheck flycheck-haskell)
  :commands haskell-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.l?hs$" . haskell-mode))
  :config
  (progn
    (req-package inf-haskell)
    (req-package hs-lint)
    (bind-key "C-x C-d" nil haskell-mode-map)
    (bind-key "C-c C-z" 'haskell-interactive-switch haskell-mode-map)
    (bind-key "C-c C-l" 'haskell-process-load-file haskell-mode-map)
    (bind-key "C-c C-b" 'haskell-interactive-switch haskell-mode-map)
    (bind-key "C-c C-t" 'haskell-process-do-type haskell-mode-map)
    (bind-key "C-c C-i" 'haskell-process-do-info haskell-mode-map)
    (bind-key "C-c M-." nil haskell-mode-map)
    (bind-key "C-c C-d" nil haskell-mode-map)
    (defun my-haskell-hook ()
      (setq mode-name " λ ")
      (turn-on-haskell-doc)
      (diminish 'haskell-doc-mode "")
      (capitalized-words-mode)
      (diminish 'capitalized-words-mode "")
      (turn-on-eldoc-mode)
      (diminish 'eldoc-mode "")
      (turn-on-haskell-decl-scan)
      (setq evil-auto-indent nil)
      (turn-on-haskell-indentation))
    (setq haskell-font-lock-symbols 'unicode)
    (setq haskell-literate-default 'tex)
    (setq haskell-stylish-on-save t)
    (setq haskell-tags-on-save t)
    (add-hook 'haskell-mode-hook 'my-haskell-hook)))

(req-package flycheck-haskell
  :config (add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))

(req-package ghc
  :init (add-hook 'haskell-mode-hook (lambda () (ghc-init))))

(req-package coffee-mode)

(req-package lisp-mode
  :init
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq mode-name " ξ "))))

(req-package idris-mode)

(req-package tern
  :require tern-auto-complete
  :init
  (progn
    (add-hook 'js-mode-hook
              (lambda ()
                (tern-mode t))))
  :config
  (progn
    (tern-ac-setup)))

(req-package tern-auto-complete)

(req-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(req-package files
  :init
  (progn
    (setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))))

(defalias 'yes-or-no-p 'y-or-n-p)

(req-package cus-edit+
  :init (customize-toggle-outside-change-updates))

(req-package web-mode
             :bind ("C-c C-v" . browse-url-of-buffer)
             :init
             (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
             :config
             (progn
               ;; Set tab to 4 to play nice with plebeian editors
               (setq web-mode-markup-indent-offset 2)
               (setq web-mode-css-indent-offset 4)
               (setq web-mode-code-indent-offset 4)
               (bind-key "<return>" 'newline-and-indent web-mode-map)
               (bind-key "C-c w t" 'web-mode-element-wrap)))

(req-package css-mode
             :init
             (progn
               (add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))
               (add-to-list 'auto-mode-alist '("\\.sass$" . css-mode)))
             :config
             (progn
               (add-hook 'css-mode-hook 'turn-on-css-eldoc)
               (autoload 'turn-on-css-eldoc "css-eldoc")
               ;; This only works for 24.3
               ;; in 24.4 electric indent is enabled by default
               ;; and you dissable like this: (electric-indent-local-mode -1)
               (set (make-local-variable 'electric-indent-mode) 1)
               (bind-key "C-{" 'brace-ret-brace css-mode-map)))

;; Insert curly-braces
(defun brace-ret-brace ()
  (interactive)
  (insert "{") (newline-and-indent)
  (newline-and-indent)
  (insert "}") (indent-for-tab-command)
  (newline-and-indent) (newline-and-indent)
  (previous-line) (previous-line) (previous-line)
  (indent-for-tab-command))

(req-package-finish)
(provide 'init)
;;; init.el ends here

(defun dbl:smart-tab ()
  "If mark is active, indents region. Else if point is at the end of a symbol,
           expands it. Else indents the current line. Acts as normal in minibuffer."
  (interactive)
  (if (boundp 'ido-cur-item)
      (ido-complete)
    (if (minibufferp)
        (minibuffer-complete)
      (if mark-active
          (indent-region (region-beginning) (region-end))
        (if (and (looking-at "\\_>") (not (looking-at "end")))
            (hippie-expand nil)
          (indent-for-tab-command))))))

(bind-key "<tab>" 'dbl:smart-tab)

(add-hook 'term-mode-hook '(lambda ()
                             (local-set-key [(tab)] 'term-send-raw)))

;; Enable Evil mode globally.
(evil-mode 1)

;; Enable the Command key as Meta
;;osx keys
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'alt)

;; Load the theme
(load-theme 'wombat)

;; No splash screen please
(setq inhibit-startup-message t)

;; Set tabs to off and width to 2
(setq-default indent-tabs-mode nil)
(setq c-basic-indent 2)
(setq tab-width 2)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

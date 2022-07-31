(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-refresh-contents)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(use-package general
:ensure t

  :config
  (general-evil-setup t))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(use-package origami :ensure t)
(origami-mode)

(use-package evil
:ensure t

  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode) )

(use-package evil-collection
:ensure t
:after evil
:config
(setq evil-collection-mode-list '(dashboard dired ibuffer))

(evil-collection-init))
(use-package evil-tutor :ensure t)
(use-package undo-tree :ensure t)
(setq evil-want-fine-undo t) 
(setq evil-undo-system 'undo-tree)
(global-undo-tree-mode)

(use-package all-the-icons-dired  :ensure t)

(use-package dired-open :ensure t)
(use-package peep-dired :ensure t)
(with-eval-after-load 'dired
  ;;(define-key dired-mode-map (kbd "M-p") 'peep-dired)
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file))

(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(use-package all-the-icons :ensure t)
(use-package doom-themes :ensure t)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-one t)
(use-package all-the-icons :ensure t)
;;(use-package doom-modeline :ensure t)
;;(doom-modeline-mode 1)

(set-face-attribute 'default nil
  :font "Caskaydia Cove Nerd Font"
  :height 95
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

;; Needed if using emacsclient. Otherwise, your fonts will be smaller than expected.
(add-to-list 'default-frame-alist '(font . "Source Code Pro-11"))
;; changes certain keywords to symbols, such as lamda!
(setq global-prettify-symbols-mode t)

(use-package eshell-syntax-highlighting
  :after esh-mode
  :ensure t
  :config
  (eshell-syntax-highlighting-global-mode +1))

(setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
      eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))
(winner-mode 1)
(nvmap :prefix "SPC"
       "e h"   '(counsel-esh-history :which-key "Eshell history")
       "e s"   '(eshell :which-key "Eshell"))

(use-package which-key
  :ensure t
  :init
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " → " ))
(which-key-mode)

(use-package gcmh
  :ensure t
 
   :config
   (gcmh-mode 1))
   
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
      
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))
(if (boundp 'comp-deferred-compilation)
    (setq comp-deferred-compilation nil)
    (setq native-comp-deferred-compilation nil))
(setq load-prefer-newer noninteractive)

(nvmap :prefix "SPC"
       ;; Window splits
       "w c"   '(evil-window-delete :which-key "Close window")
       "w n"   '(evil-window-new :which-key "New window")
       "w s"   '(evil-window-split :which-key "Horizontal split window")
       "w v"   '(evil-window-vsplit :which-key "Vertical split window")

       ;; Window motions
       "w <left>"   '(evil-window-left :which-key "Window left")
       "w <dowm>"   '(evil-window-down :which-key "Window down")
       "w <up>"   '(evil-window-up :which-key "Window up")
       "w <right>"   '(evil-window-right :which-key "Window right")
       "w w"   '(evil-window-next :which-key "Goto next window")
       ;; winner mode
       ;; "w <left>"  '(winner-undo :which-key "Winner undo")
       ;; "w <right>" '(winner-redo :which-key "Winner redo")
       )
(define-key evil-normal-state-map(kbd "C-<left>") 'evil-window-left)
(define-key evil-normal-state-map(kbd "C-<down>") 'evil-window-down)
(define-key evil-normal-state-map(kbd "C-<up>") 'evil-window-up)
(define-key evil-normal-state-map(kbd "C-<right>") 'evil-window-right)
;define-key evil-normal-state-map (kbd "w") 'some-function)

(use-package swiper )
(global-set-key (kbd "C-f") 'swiper)
 
(nvmap :prefix "SPC"
       "b b"   '(ibuffer :which-key "Ibuffer")
       "b c"   '(clone-indirect-buffer-other-window :which-key "Clone indirect buffer other window")
       "b k"   '(kill-current-buffer :which-key "Kill current buffer")
       "b n"   '(next-buffer :which-key "Next buffer")
       "b p"   '(previous-buffer :which-key "Previous buffer")
       "b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
       "b K"   '(kill-buffer :which-key "Kill buffer"))

(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
               "d d" '(dired :which-key "Open dired")
               "d j" '(dired-jump :which-key "Dired jump to current")
               "d p" '(peep-dired :which-key "Peep-dired"))
	       
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
       "f f"   '(find-file :which-key "Find file")
       "f r"   '(counsel-recentf :which-key "Recent files")
       "f s"   '(save-buffer :which-key "Save file")
       "f u"   '(sudo-edit-find-file :which-key "Sudo find file")
       "f y"   '(dt/show-and-copy-buffer-path :which-key "Yank file path")
       "f C"   '(copy-file :which-key "Copy file")
       "f D"   '(delete-file :which-key "Delete file")
       "f R"   '(rename-file :which-key "Rename file")
       "f S"   '(write-file :which-key "Save file as...")
       "f U"   '(sudo-edit :which-key "Sudo edit file"))

(use-package multiple-cursors)
(global-set-key (kbd "M-D") 'mc/mark-next-like-this)
(global-set-key (kbd "M-C-d") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-d") 'mc/mark-all-like-this)
(global-set-key (kbd "C-d") 'mc/edit-lines)

(nvmap :keymaps 'override :prefix "SPC"
       "r e" '((lambda () (interactive) (load-file "~/.emacs.d/init.el")) :which-key "Reload emacs config")
       "t t"   '(toggle-truncate-lines :which-key "Toggle truncate lines"))

(nvmap :keymaps 'override :prefix "SPC"
       "m f"   '(org-footnote-new :which-key "Org footnote new")
       "m t"   '(org-todo :which-key "Org todo")
       "m x"   '(org-toggle-checkbox :which-key "Org toggle checkbox")
       "m B"   '(org-babel-tangle :which-key "Org babel tangle")
       "m I"   '(org-toggle-inline-images :which-key "Org toggle inline imager")
       "m T"   '(org-todo-list :which-key "Org todo list")
       "o a"   '(org-agenda :which-key "Org agenda")
       )

(define-key evil-normal-state-map (kbd "C-f") 'swiper)
(define-key evil-normal-state-map (kbd "C-M-f") 'swiper-all)
(define-key evil-normal-state-map (kbd "C-s") 'save-buffer)


;; zoom in/out like we do everywhere else.
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
(use-package evil-commentary )

(evil-commentary-mode)
(define-key evil-normal-state-map(kbd "C-c") 'evil-commentary-line)
(define-key evil-normal-state-map (kbd "C-z") 'undo-tree-undo)
(define-key evil-normal-state-map (kbd "C-Z") 'undo-tree-redo)

(use-package dashboard
  :ensure t

  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  (setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  ;;(setq dashboard-startup-banner "~/.emacs.d/emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
			      (bookmarks . "book"))))

(use-package yasnippet :ensure t)

;; (use-package company-lsp :ensure t)
   (use-package company :ensure t)
   (add-hook 'after-init-hook 'global-company-mode)


(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 (XXX-mode . lsp)
	 ;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)

;; (use-package xref)
 ;; (use-package eldoc)
 (use-package flycheck)


(use-package tree-sitter
:ensure t
:config
;; activate tree-sitter on any buffer containing code for which it has a parser available
(global-tree-sitter-mode)
;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
;; by switching on and off
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))


;; (add-hook 'python-mode-hook #'lsp)
;; (add-hook 'js2-mode-hook #'lsp)
;; (add-hook 'go-mode-hook     #'lsp)
;; (setq lsp-eldoc-render-all t)
(use-package format-all :ensure t)
(format-all-mode)

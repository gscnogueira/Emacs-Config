;; =================================
;; Author: Gabriel da S. C. Nogueira
;; GitHub: gscnogueira
;; Emacs Version: 29.3
;; =================================

(eval-when-compile (require 'use-package))

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(use-package emacs
  :init
  (add-to-list 'default-frame-alist '(font . "JetBrains Mono-15"))
  :hook
  (prog-mode . display-line-numbers-mode)

  :custom
  (inhibit-splash-screen t)
  (tool-bar-mode nil)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (fringe-mode 0)
  (global-visual-line-mode t)
  (column-number-mode t)
  (global-hl-line-mode t)
  (custom-file (expand-file-name "custom.el" user-emacs-directory))
  (apropos-sort-by-scores t)

  :config
  ;; Buffer-local variable (needs setq-default)
  (setq-default left-margin-width 1) 
  ;; Set left-margin-width to 0 on prog-mode
  (add-hook 'prog-mode-hook (function(lambda () (setq left-margin-width 0))))
  (load custom-file)

  :bind
  ("<mouse-8>" . switch-to-prev-buffer)
  ("<mouse-9>" . switch-to-next-buffer)
  )

(use-package modus-themes
  :ensure t
  :init
  (require-theme 'modus-themes)
  :config
  (load-theme 'modus-vivendi-tinted)
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted))
  )

(use-package winner
  :config (winner-mode t))

(use-package org
  :init
  (setq org-capture-templates '(
				("f" "FioCruz")
				("ff" "Tarefa" entry
				 (file+headline "fiocruz.org" "Tasks")
				 (file "~/.emacs.d/templates/capture-todo.org"))

				("p" "Pessoal")
				("pp" "Tarefa" entry
				 (file+headline "~/org/pessoal.org" "Tasks" )
				 (file "~/.emacs.d/templates/capture-todo.org"))
				("pe" "Evento" entry
				 (file+headline "pessoal.org" "Eventos" )
				 (file "~/.emacs.d/templates/evento.org"))
				
				("d" "Doutorado")
				("dd" "Tarefa" entry
				 (file+headline "doutorado.org" "Tasks")
				 (file "~/.emacs.d/templates/capture-todo.org"))
				("dr" "Reunião" entry
				 (file+headline "doutorado.org" "Reuniões")
				 (file "~/.emacs.d/templates/evento.org"))

				("r" "Reading List" entry
				 (file "reading_list.org")
				 (file "~/.emacs.d/templates/reading_list.org"))
				))
  :hook
  ((org-mode . org-indent-mode)
   (org-babel-after-execute . org-redisplay-inline-images))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :custom
  (org-hide-emphasis-markers  t)
  (org-startup-with-inline-images t)
  (org-confirm-babel-evaluate nil)
  (org-log-into-drawer t)
  :config
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((gnuplot . t) (shell . t)))

  
  )


(use-package gnuplot
  :ensure t
  :defer t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode t))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :custom
  (evil-want-keybinding nil)
  :config
  (evil-mode t)
  (evil-set-initial-state 'Info-mode 'emacs)
  (evil-set-initial-state 'dired-mode 'emacs)
  )

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package vertico
  :ensure t
  :init (vertico-mode t)
  :bind
  (:map vertico-map
	;; Restores TAB default behaviour
	("TAB" . vertico-directory-enter)
	("C-<backspace>" . vertico-directory-delete-word)
	)
  )

(use-package consult
  :ensure t
  :bind
  ("C-x b" . consult-buffer)
  ("C-c C-x C-o" . consult-outline)
  ("C-c m" . consult-line-multi)
  ("C-c o" . consult-org-agenda))

(use-package corfu
  :ensure t
  :custom
  (global-corfu-mode t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package magit
  :defer t
  :ensure t)

(use-package haskell-mode
  :ensure t
  :defer t) 

(use-package ledger-mode
  :defer t
  :ensure t)

(use-package pdf-tools
  :ensure t
  :defer t)

(use-package lsp-mode
  :ensure t
  :commands lsp)

(use-package pyvenv
  :defer t
  :ensure t)

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook
  (python-mode . lsp)
  )

(use-package direnv
  :ensure t)

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode)
  )

(use-package embark
  :ensure t
  :bind
  (("C-c ." . embark-act)))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package org-roam
  :ensure t
  :bind
  (("C-c i" . org-roam-node-insert)
   ("C-c f" . org-roam-node-find)
   ("C-c d" . org-roam-dailies-goto-date)
   :map org-mode-map
   ("C-c n" . org-roam-dailies-goto-next-note)
   ("C-c p" . org-roam-dailies-goto-previous-note)
   ("C-c r b" . org-roam-buffer-toggle))
  :config
  (org-roam-db-autosync-mode)
  :custom
  (org-roam-directory "~/SlipBox")
  (org-roam-node-display-template
   (concat "${title:*} " (propertize "${tags:*}" 'face 'org-tag))))

(use-package vterm
  :ensure t)




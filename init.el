(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(eval-when-compile (require 'use-package))

(use-package emacs
  :init
  (add-to-list 'default-frame-alist '(font . "JetBrains Mono-15"))
  :hook
  (prog-mode . display-line-numbers-mode)
  (prog-mode . hl-line-mode)


  :custom
  (inhibit-splash-screen t)
  (tool-bar-mode nil)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (global-visual-line-mode t)
  (column-number-mode t)
  (apropos-sort-by-scores t)

  :config
  (setq-default left-margin-width 1) 
  ;; Set left-margin-width to 0 on prog-mode
  (add-hook 'prog-mode-hook
	    (function(lambda () (setq left-margin-width 0)))
	    )
  (when (file-exists-p custom-file) (load custom-file nil 'nomessage))
  (setq make-backup-files nil)
  (setq frame-resize-pixelwise t)
  (setq window-resize-pixelwise t)
  (setq initial-major-mode 'org-mode) ;; org mode for initial buffer
  (setq native-comp-async-report-warnings-errors 'silent)
  (winner-mode 1)
)

(use-package modus-themes
  :ensure t
  :init
  (require-theme 'modus-themes)
  :config
  (load-theme 'modus-vivendi)
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-to-toggle
   '(modus-operandi-tinted modus-vivendi)
   )
  )

(use-package dired
  :custom
  (dired-create-destination-dirs t)
  :hook
  (dired-mode . dired-hide-details-mode)
  (dired-mode . dired-omit-mode)
  :config
  (require 'dired-x)
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
  )

(use-package org
  :hook (
         (org-mode . org-indent-mode)
         (org-agenda-mode . hl-line-mode)
	 (org-babel-after-execute . org-redisplay-inline-images)
         )
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :custom
  (org-hide-emphasis-markers  t)

  (org-startup-with-inline-images t)

  (org-confirm-babel-evaluate nil)

  (org-todo-keywords
   '((sequence "TODO(t)" "BLOCKED(b@)" "|" "DONE(d)" "CANCELLED(c@)"))
   )

  (org-agenda-span 'day)
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  (org-hide-drawer-startup t)

  :config
  (defun my/org-prettify-checkboxes ()
    (push '("[ ]" . "☐") prettify-symbols-alist)
    (push '("[X]" . "☑") prettify-symbols-alist)
    (push '("[-]" . "⊟") prettify-symbols-alist)
    (prettify-symbols-mode 1))

  (set-face-attribute 'variable-pitch nil :family "Literata" :height 160)
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-date nil :inherit 'fixed-pitch)
  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'org-mode-hook #'my/org-prettify-checkboxes)
  (setq org-agenda-files '("~/org/agenda/"))
  )


(setq org-agenda-tag-filter-preset '("-noagenda"))

(setq org-capture-templates
      '(
        ("i" "Ideia" entry
         (file+headline "~/org/agenda/doutorado.org" "Ideias")
         "* %^{Título}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?"
         )
        ("l" "Tópicos para abordar na próxima reunião com o prof. Luís"
         checkitem
         (file+regexp "~/org/agenda/doutorado.org" "Reunião Luís")
         "[ ] %?")
        ("d" "Doutorado" entry
         (file+headline "~/org/agenda/doutorado.org" "Tarefas")
         "* TODO %^{Tarefa:}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")
        ("f" "Tarefa fiocruz" entry
         (file+headline "~/org/agenda/fiocruz.org" "Tarefas")
         "* TODO %^{Tarefa:}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")
	("D" "Disciplinas" entry
	 (file+headline "~/org/agenda/disciplinas.org" "Tarefas")
	 "* TODO %^{Tarefa:}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")
        ("F" "Tóipico de reunião (fiocruz)" entry
         (file+headline "~/org/agenda/fiocruz.org" "Reuniões")
         "* TODO %^{Tópico a ser discutido:}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")
	)
      )
      

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
  :init 
  (vertico-mode t)
  :bind
  (:map vertico-map
	;; Restores TAB default behaviour
	("TAB" . vertico-directory-enter)
	("C-<backspace>" . vertico-directory-delete-word)
	)
  )

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)))

(use-package consult
  :ensure t
  :bind
  (
   ("C-x b" . consult-buffer)
   ("C-c C-x C-o" . consult-outline)
   ("C-c m" . consult-line-multi)
   ("C-c o" . consult-org-agenda)
   ("C-x j" . consult-imenu)
   )
  )

(use-package corfu
  :ensure t
  :custom
  (global-corfu-mode t))

(use-package magit
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode t)
  )

(use-package ledger-mode
  :defer t
  :ensure t)

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init 
  (marginalia-mode 1)
  )

(use-package embark
  :ensure t
  :bind
  (("C-c ." . embark-act)))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


(use-package vterm
  :ensure t
  :config
  (add-hook 'vterm-mode-hook  'turn-off-evil-mode)
  )

(use-package lsp-mode
  :init
  :ensure t
  :commands lsp
  :config
  (setq gc-cons-threshold 1000000000) ;; 1GB
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq lsp-signature-render-documentation nil)

  ;; Configurações específicas para o lsp-ruff
  (setq lsp-ruff-lint-select ["E","F", "I", "B"])

  ;; Configurações flymake
  (setq flymake-show-diagnostics-at-end-of-line nil)
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  )

(use-package copilot
  :ensure t
  :if (executable-find "copilot-language-server")
  :hook (prog-mode . copilot-mode)
  :custom
  (copilot-server-executable "/home/gabriel-nogueira/.npm-global/bin/copilot-language-server")
  (copilot-idle-delay nil)
  :bind (("C-c <tab>" . copilot-complete)
         :map copilot-completion-map
         ("C-c <return>" . copilot-accept-completion)
         ("C-<tab>" . copilot-accept-completion-by-word))
  )

(use-package gptel
  :ensure t
  :config
  (setq gptel-model 'gpt-5.3-codex
        gptel-backend (gptel-make-gh-copilot "Copilot"))
  :bind
  ("C-c g r" . gptel-rewrite)
  ("C-c g a" . gptel-add)
  )

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode))

(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode t)
  )

(use-package reformatter
  :ensure t
  :config
  (reformatter-define ruff-format
                      :program "ruff"
                      :args '("format" "--line-length" "88" "-"))
  (add-hook 'python-mode-hook #'ruff-format-on-save-mode))

(use-package haskell-mode
  :ensure t
  :defer t)

(use-package pyvenv
  :defer t
  :ensure t)

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook
  (python-mode . lsp)
  )

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (
   ("C-c n n" . denote-open-or-create )
   )
  :config
  (setq denote-directory (expand-file-name "~/notes"))
  )

(use-package dockerfile-mode
  :ensure t)

(use-package docker-compose-mode
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode)
  )

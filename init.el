;; use-package setup

(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(setq use-package-enable-imenu-support t) ; expõe cada pacote no imenu (C-x j)

(use-package emacs
  :init
  (add-to-list 'default-frame-alist '(font . "JetBrains Mono-15"))
  (dolist (dir '("~/.npm-global/bin" "~/.opencode/bin/" "~/.local/bin/"))
    (add-to-list 'exec-path (expand-file-name dir)))
  :hook
  (prog-mode . display-line-numbers-mode)
  (prog-mode . hl-line-mode)
  :custom
  (inhibit-splash-screen t)
  (tool-bar-mode nil)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (recentf-mode t)
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
  (setq-default major-mode 'org-mode) ;; org mode for new buffers without extension
  (setq native-comp-async-report-warnings-errors 'silent)
  (winner-mode 1)
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

(use-package modus-themes
  :ensure t
  :init
  (require-theme 'modus-themes)
  :config
  (load-theme 'modus-vivendi t)
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi)))

(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode t))

(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'org-mode '("->"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                   ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                   "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                   "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                   "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                   "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                   "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                   "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                   ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                   "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                   "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                   "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                   "\\\\\\" "://"))
  (global-ligature-mode t))

(use-package vertico
  :ensure t
  :init
  (vertico-mode t)
  :bind
  (:map vertico-map
	("C-<backspace>" . vertico-directory-delete-word)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)))

(use-package consult
  :ensure t
  :bind
  (("C-x b"       . consult-buffer)
   ("C-c j"       . consult-outline)
   ("C-c m"       . consult-line-multi)
   ("C-c o"       . consult-org-agenda)
   ("C-x j"       . consult-imenu)))

(use-package corfu
  :ensure t
  :custom
  (global-corfu-mode t))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode 1))

(use-package embark
  :ensure t
  :bind
  (("C-c ." . embark-act)
   ("C-."   . embark-act)
   ("M-."   . embark-dwim)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode t))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode t)
  (evil-set-initial-state 'Info-mode 'emacs)
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-set-initial-state 'agent-shell-mode 'emacs))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init)
  (with-eval-after-load 'vterm
    (evil-set-initial-state 'vterm-mode 'emacs)))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm)
  )

(use-package org
  :hook ((org-mode          . org-indent-mode)
         (org-agenda-mode   . hl-line-mode)
         (org-babel-after-execute . org-redisplay-inline-images))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c n q" . my/consult-notes))
  :custom
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-confirm-babel-evaluate nil)
  (org-todo-keywords
   '((sequence "TODO(t)" "PROG(p)" "BLOCKED(b@)" "|" "DONE(d)" "CANCELLED(c@)")))
   (org-agenda-custom-commands
    '(("t" "TODOs"
       ((agenda "") (todo ""))
       ((org-agenda-tag-filter-preset '("-noagenda"))))
      ("f" "Fiocruz"
       ((agenda "") (todo ""))
       ((org-agenda-files '("~/org/fiocruz/"))))
      ))
  (org-agenda-span 'day)
  (org-enforce-todo-dependencies t)
   (org-enforce-todo-checkbox-dependencies t)
   (org-hide-drawer-startup t)
   (org-capture-templates
    '(("t" "Todo" entry
       (function my/org-fiocruz-target)
       "* TODO %?\n  %i\n")))
  (org-agenda-clockreport-parameter-plist '(:scope agenda-with-archives :maxlevel 3))
  :config
  (defun my/org-prettify-checkboxes ()
    (push '("[ ]" . "☐") prettify-symbols-alist)
    (push '("[X]" . "☑") prettify-symbols-alist)
    (push '("[-]" . "⊟") prettify-symbols-alist)
    (push '("->" . ?⟶) prettify-symbols-alist)
    (push '("<-" . ?←) prettify-symbols-alist)
    (push '("<->" . ?↔) prettify-symbols-alist)
    (push '("=>" . ?⇒) prettify-symbols-alist)
    (push '("<=>" . ?⟺) prettify-symbols-alist)
    (prettify-symbols-mode 1))
  (set-face-attribute 'variable-pitch nil :family "Literata" :height 160)
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-date nil :inherit 'fixed-pitch)
  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'org-mode-hook #'my/org-prettify-checkboxes)
  (setq org-agenda-files '("~/.notes"))

  (defun my/org-narrow-next-subtree (arg)
    "Widen, vai para a próxima heading e estreita na subtree dela."
    (interactive "p")
    (widen)
    (org-next-visible-heading (or arg 1))
    (org-narrow-to-subtree))

  (defun my/consult-notes ()
    "Search headings in ~/.notes."
    (interactive)
    (consult-org-agenda "+notes"))
  )

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode))

(use-package org-present
  :ensure t)

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote-open-or-create)
   ("C-c n d" . denote-date)
   ("C-c n l" . denote-link-or-create))
  :config
  (setq denote-directory (expand-file-name "~/notes"))
  (setq denote-date-prompt-use-org-read-date t)
  (denote-rename-buffer-mode 1)
  (setq-default abbrev-mode t))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (expand-file-name "~/research"))
  :bind (("C-c f" . org-roam-node-find)
         ("C-c i" . org-roam-node-insert)
         ("C-c r b" . org-roam-buffer-toggle))
  :config
  (org-roam-db-autosync-mode))

(use-package citar
  :ensure t
  :custom
  (citar-bibliography '("~/research/references.bib"))
  (org-cite-global-bibliography '("~/research/references.bib"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :bind
  (:map org-mode-map
   ("C-c [" . citar-insert-citation)))

(use-package copilot
  :ensure t
  :hook (prog-mode . copilot-mode)
  :custom
  (copilot-server-executable (expand-file-name "~/.npm-global/bin/copilot-language-server"))
  (copilot-idle-delay nil)
  :bind (("C-c <tab>" . copilot-complete)
         :map copilot-completion-map
         ("C-c <return>" . copilot-accept-completion)
         ("C-<tab>"      . copilot-accept-completion-by-word)))

(use-package gptel
  :ensure t
  :config
  (gptel-make-gh-copilot "Copilot")
  (setq gptel-backend (gptel-get-backend "Copilot")
	gptel-model 'gpt-4o)
  :bind
  ("C-c g r" . gptel-rewrite)
  ("C-c g a" . gptel-add))

(use-package agent-shell
  :ensure t
  :ensure-system-package
  ((claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp"))
  :bind
  (
   ("C-c b" . agent-shell-switch-buffer)
   ("C-c SPC" . agent-shell)
   ("C-c s o" . agent-shell-opencode-start-agent)
   ("C-c s c" . agent-shell-anthropic-start-claude-code)
   ("C-c s p" . agent-shell-github-start-copilot)
   ("C-c s t" . agent-shell-toggle)
   :map agent-shell-mode-map
   ("C-c n" . agent-shell-new-shell)
   ("C-c g" . agent-shell-prompt-compose)
   :map agent-shell-diff-mode-map
   ("a" . agent-shell-diff-accept-all))
  :custom
  (agent-shell-header-style 'text)
  (agent-shell-show-welcome-message nil)
  (agent-shell-context-sources '(files region error))
  (agent-shell-opencode-default-model-id "opencode-go/deepseek-v4-pro")
  )


;;; Git

(use-package magit
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode t))

;;; Dev

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (setq gc-cons-threshold 1000000000)
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-signature-render-documentation nil)
  (setq lsp-ruff-lint-select ["E" "F" "I" "B"])
  (setq flymake-show-diagnostics-at-end-of-line nil)
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly))

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook
  (python-mode . lsp))

(use-package reformatter
  :ensure t
  :config
  (reformatter-define ruff-format
                      :program "ruff"
                      :args '("format" "--line-length" "88" "-"))
  (add-hook 'python-mode-hook #'ruff-format-on-save-mode))

(use-package pyvenv
  :defer t
  :ensure t)

(use-package haskell-mode
  :ensure t
  :defer t)

(use-package docker-compose-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

;;; LaTeX / PDF

(use-package auctex
  :ensure t
  :hook ((LaTeX-mode . display-line-numbers-mode)
         (LaTeX-mode . reftex-mode)
         (LaTeX-mode . TeX-source-correlate-mode)
         (LaTeX-mode . flyspell-mode)))

(use-package pdf-tools
  :ensure t
  :custom
  (pdf-view-continuous nil)
  :config
  (pdf-tools-install))

;;; Finance

(use-package ledger-mode
  :defer t
  :ensure t)

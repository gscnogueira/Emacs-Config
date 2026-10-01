;; use-package setup  -*- lexical-binding: t; -*-

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
  (add-to-list 'default-frame-alist '(alpha-background . 100))
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
  (recentf-mode nil)
  (global-visual-line-mode t)
  (column-number-mode t)
  (apropos-sort-by-scores t)
  (treesit-enabled-modes '(python-ts-mode))

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

(use-package tab-bar
  :custom
  (tab-bar-new-tab-choice "*scratch*")
  :bind
  ("C-<tab>" . tab-bar-switch-to-recent-tab))


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
  (("C-c j"       . consult-outline)
   ("C-c m"       . consult-line-multi)
   ("C-x j"       . consult-imenu)
   ("C-x p b"     . consult-project-buffer)
   ("C-x b"       . consult-buffer)
   ))


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

(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode 1)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

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
  (evil-set-initial-state 'agent-shell-mode 'emacs)
  (evil-set-initial-state 'agent-shell-diff-mode 'emacs)
  (evil-set-initial-state 'agent-shell-viewport-view-mode 'emacs)
  )

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (setq evil-collection-mode-list
        (remove 'org-agenda evil-collection-mode-list))
  (evil-collection-init)
  (evil-set-initial-state 'org-agenda-mode 'emacs)
  (with-eval-after-load 'ghostel
    (evil-set-initial-state 'ghostel-mode 'emacs)))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package ghostel
  :ensure t)

(use-package consult-ghostel
    :ensure t
    :after (ghostel consult)
    :demand t
    :config (consult-ghostel-mode)
    :bind (("C-x m" . consult-ghostel)
           :map project-prefix-map
           ("m" . consult-ghostel-project)
           :map ghostel-semi-char-mode-map
           ("C-c h" . consult-ghostel-history)))

(use-package org
  :hook ((org-mode          . org-indent-mode)
         (org-agenda-mode   . hl-line-mode)
         (org-babel-after-execute . org-redisplay-inline-images))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   )
  :custom
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-confirm-babel-evaluate nil)
  (org-directory "~/org")
  (org-agenda-files '("~/org/todo.org" "~/org/agenda.org"))
  (org-capture-templates
   '(("t" "Tarefa" entry (file+olp "~/org/todo.org" "Inbox")
      "* TODO %?"
      :empty-lines 1)
     ("a" "Agenda" entry (file "~/org/agenda.org")
      "* %?\n%^T")))
  (org-refile-targets '((("~/org/todo.org") :maxlevel . 1)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-agenda-todo-ignore-scheduled 'future)
  (org-agenda-custom-commands
   '(("a" "Hoje"
      ((agenda ""))
      ((org-agenda-span 'day)
       (org-agenda-clockreport-mode t)))
     ("t" "Backlog"
      ((todo "TODO"))
      nil)))
  (org-agenda-span 'day)
  (org-agenda-use-time-grid nil)
  (org-agenda-prefix-format
   '((agenda  . " %i %-12:c%?-12t % s %-6e")
     (todo    . " %i %-12:c% s")
     (tags    . " %i %-12:c")
     (search  . " %i %-12:c %-6e")))
  (org-todo-keywords
   '((sequence "TODO(t)" "PROG(p)" "|" "DONE(d)")))
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  (org-default-priority ?C)
  (org-hide-drawer-startup t)
  (org-agenda-clockreport-parameter-plist '(:scope agenda-with-archives :maxlevel 1 :fileskip0 t))
  (org-clock-mode-line-total 'today)
  :config
  (require 'org-tempo)
  (add-to-list 'org-tempo-keywords-alist '("t" . "title"))
  (tempo-define-template "org-date"
                          '("#+date: " (format-time-string "[%Y-%m-%d %a]") p '>)
                          "<d"
                          "Insere #+date: com a data atual"
                          'org-tempo-tags)

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
  (set-face-attribute 'fixed-pitch nil :family "JetBrains Mono")
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-date nil :inherit 'fixed-pitch)
  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'org-mode-hook #'my/org-prettify-checkboxes)

  (defun my/org-narrow-next-subtree (arg)
    "Widen, vai para a próxima heading e estreita na subtree dela."
    (interactive "p")
    (widen)
    (org-next-visible-heading arg)
    (org-narrow-to-subtree))

  (defun my/org-narrow-previous-subtree (arg)
    "Widen, vai para a heading anterior e estreita na subtree dela."
    (interactive "p")
    (my/org-narrow-next-subtree (- arg)))

  (evil-define-key 'normal org-mode-map
    "gj" #'evil-next-visual-line
    "gk" #'evil-previous-visual-line
    "gn" #'my/org-narrow-next-subtree
    "gp" #'my/org-narrow-previous-subtree))

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
  )

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (expand-file-name "~/research"))
  (org-roam-node-display-template "${title:*} ${tags:20}")
  :bind (
	 ("C-c f" . org-roam-node-find)
	 ("C-c i" . org-roam-node-insert)
	 ("C-c r" . my/org-roam-menu)
	 )
  :config
  (org-roam-db-autosync-mode)
  (define-key org-mode-map (kbd "M-p") #'org-roam-dailies-goto-previous-note)
  (define-key org-mode-map (kbd "M-n") #'org-roam-dailies-goto-next-note)
  (transient-define-prefix my/org-roam-menu ()
    "Org Roam"
    [("b" "Buffer"           org-roam-buffer-toggle)
     ("t" "Dailies today"    org-roam-dailies-goto-today)
     ("d" "Dailies date"     org-roam-dailies-goto-date)]))

(use-package citar
  :ensure t
  :custom
  (citar-bibliography '("~/zotero/library.bib"))
  (org-cite-global-bibliography '("~/zotero/library.bib"))
  (citar-library-paths '("~/zotero/storage"))
  (citar-notes-paths '("~/research"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :bind
  (:map org-mode-map
   ("C-c [" . citar-insert-citation)
   ("C-c ]" . citar-open-notes)))

(use-package citar-org-roam
  :ensure t
  :after (citar org-roam)
  :custom
  (citar-org-roam-capture-template-key "r")
  (citar-org-roam-note-title-template "${title}")
  :config
  (add-to-list 'org-roam-capture-templates
               '("r" "referência" plain "%?"
                 :target (file+head
                          "%(concat (when citar-org-roam-subdir (concat citar-org-roam-subdir \"/\")) \"${citar-citekey}.org\")"
                          "#+title: ${note-title}\n#+author: ${citar-author}\n#+filetags: :artigo:\n")
                 :immediate-finish t
                 :unnarrowed t))
  (citar-org-roam-mode))

(use-package copilot
  :ensure t
  :hook (prog-mode . copilot-mode)
  :custom
  (copilot-server-executable (expand-file-name "~/.npm-global/bin/copilot-language-server"))
  (copilot-idle-delay nil)
  (copilot-indent-offset-warning-disable t)
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
  ("C-c C-a" . gptel-add)
  ("C-c C-<return>" . gptel-menu))

(use-package agent-shell
  :ensure t
  :ensure-system-package
  ((claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp"))
  :bind
  (
   ("C-c  b" . agent-shell-switch-buffer)
   ("C-c SPC" . agent-shell)
   ("C-c s o" . agent-shell-opencode-start-agent)
   ("C-c s c" . agent-shell-anthropic-start-claude-code)
   :map agent-shell-mode-map
   ("C-c n" . agent-shell-new-shell)
   ("C-c g" . agent-shell-prompt-compose)
   ("C-c SPC" . agent-shell-toggle)
   ("C-<tab>" . nil)
   :map agent-shell-diff-mode-map
   ("a" . agent-shell-diff-accept-all))
  :custom
  (agent-shell-header-style 'text)
  (agent-shell-show-welcome-message nil)
  (agent-shell-preferred-agent-config 'claude-code)
  (agent-shell-anthropic-default-model-id "sonnet")
  (agent-shell-anthropic-default-session-mode-id "default")
  (agent-shell-session-strategy 'prompt)
  (agent-shell-activity-group-expand-by-default 'latest)
  (agent-shell-prefer-viewport-interaction nil)
  (agent-shell-persistent-prompt-enabled nil)
  :config
  (setopt agent-shell-show-cost-indicator t)
  ;; agent-shell-anthropic não expõe defcustom p/ config options; injeta effort low
  (advice-add 'agent-shell-anthropic-make-claude-code-config :filter-return
              (lambda (config)
                (setf (alist-get :default-config-options config)
                      (lambda () '(("effort" . "low"))))
                config))
  )


;;; Git

(use-package magit
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (evil-define-key 'normal 'global
    "]d" #'diff-hl-next-hunk
    "[d" #'diff-hl-previous-hunk)
  (global-diff-hl-mode t)
  )


(use-package reformatter
  :ensure t
  :config
  (reformatter-define ruff-format
                      :program "ruff"
                      :args '("format" "--line-length" "88" "-"))
  (add-hook 'python-base-mode-hook #'ruff-format-on-save-mode))

(use-package pyvenv
  :defer t
  :ensure t)

(use-package eglot
  :hook ((python-base-mode . eglot-ensure)
         (eglot-managed-mode . (lambda () (eglot-inlay-hints-mode -1))))
  :init (require 'markdown-ts-mode)
  :custom
  (eglot-documentation-renderer 'markdown-ts-view-mode)
  :config
  (setq-default eglot-workspace-configuration
		'(:basedpyright (:analysis (:autoImportCompletions :json-false))))
  )

(use-package eldoc
  :custom
  (eldoc-echo-area-use-multiline-p nil))

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
         (LaTeX-mode . flyspell-mode))
  :custom
  (TeX-command-default "LaTeXMk")
  )

(use-package pdf-tools
  :ensure t
  :custom
  (pdf-view-continuous t)
  (pdf-view-midnight-colors '("#ffffff" . "#000000"))

  :config
  (pdf-tools-install))

(use-package ledger-mode
  :defer t
  :ensure t)

(use-package avy
  :ensure t
  :bind ("C-;" . avy-goto-char-timer))

;; Customizações pessoais

(defun my/org-checkbox-todo-strike-through ()
  "Apply strike-through face to completed Org-mode checkboxes."
  (font-lock-add-keywords
   'org-mode
   '(("^\\s-*\\(?:[-+*]\\|\\s-*[0-9]+[.)]\\)\\s-+\\[X\\]\\s-+\\(.*\\)$"
      1 '(:strike-through t :foreground "gray") append))))

(add-hook 'org-mode-hook #'my/org-checkbox-todo-strike-through)

(use-package gnus
  :custom
  (gnus-select-method '(nnnil ""))
  (gnus-secondary-select-methods '((nnrss "")))
  (gnus-summary-line-format "%U%R%z%I%(%[%4L: %-23,23f%]%) %-10,10&user-date; %s\n")
  (gnus-user-date-format-alist '((t . "%Y-%m-%d")))
  (gnus-use-full-window nil)
  )

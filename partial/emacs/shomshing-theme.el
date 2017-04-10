;;; shomshing-theme.el --- Custom face theme for Emacs

(deftheme shomshing
  "this theme is shomshing else")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'shomshing
   `(default ((,class (:background "#101010" :foreground "#777777"))))
   `(cursor ((,class (:background "#656565"))))
   ;; Highlighting faces
   `(fringe ((,class (:background "#1b1b1b"))))
   `(highlight ((,class (:background "#1b1b1b" :foreground "#ffffff"
			 :underline t))))
   `(region ((,class (:background "#1b1b1b" :foreground "#ee9966"))))
   `(secondary-selection ((,class (:background "#333366" :foreground "#f6f3e8"))))
   `(isearch ((,class (:background "#343434" :foreground "#857b6f"))))
   `(lazy-highlight ((,class (:background "#384048" :foreground "#a0a8b0"))))
   ;; Mode line faces
   `(mode-line ((,class (:background "#1b1b1b" :foreground "#ee9966"))))
   `(mode-line-inactive ((,class (:background "#1b1b1b" :foreground "#555555"))))
   ;; Escape and prompt faces
   `(minibuffer-prompt ((,class (:foreground "#e5786d"))))
   `(escape-glyph ((,class (:foreground "#ddaa6f" :weight bold))))
   ;; Font lock faces
    ;; "#101010"
    ;; "#777777"

    ;; "#1b1b1b"
    ;; "#cc4444"
    ;; "#55aa55"
    ;; "#ee9966"
    ;; "#4477ff"
    ;; "#bb33bb"
    ;; "#22aaaa"
    ;; "#808080"

    ;; "#555555"
    ;; "#cc335f"
    ;; "#77aa22"
    ;; "#ffdd88"
    ;; "#3388bb"
    ;; "#9966ff"
    ;; "#33aa77"
    ;; "#ffffff"
   `(font-lock-builtin-face ((,class (:foreground "#cc335f"))))
   `(font-lock-comment-face ((,class (:foreground "#555555"))))
   `(font-lock-doc-face ((,class (:foreground "#4466ff"))))
   `(font-lock-constant-face ((,class (:foreground "#55aa55"))))
   `(font-lock-function-name-face ((,class (:foreground "#22aaaa"))))
   `(font-lock-keyword-face ((,class (:foreground "#ee9966"))))
   `(font-lock-string-face ((,class (:foreground "#ffdd88"))))
   `(font-lock-type-face ((,class (:foreground "#33aa77"))))
   `(font-lock-variable-name-face ((,class (:foreground "#9966ff"))))
   `(font-lock-warning-face ((,class (:foreground "#cc44cc"))))
   ;; linum
   `(linum ((,class (:foreground "#555555"))))
   ;; company
   `(company-echo-common ((,class (:foreground "#cc4444"))))
   `(company-preview ((,class (:background "#1b1b1b"))))
   `(company-preview-common ((,class (:background "#1b1b1b" :foreground "#ee9966"))))
   `(company-preview-search ((,class (:background "#1b1b1b"))))
   `(company-scrollbar-bg ((,class (:background "#1b1b1b"))))
   `(company-scrollbar-fg ((,class (:background "#555555"))))
   `(company-template-field ((,class (:background "#1b1b1b" :foreground "#bb33bb"))))
   `(company-tooltip ((,class (:background "#1b1b1b" :foreground "#555555"))))
   `(company-tooltip-selection ((,class (:background "#1b1b1b" :foreground "#bb33bb"))))
   `(company-tooltip-common ((,class (:background "#1b1b1b" :foreground "#ee9966"))))
   `(company-tooltip-annotation ((,class (:background "#1b1b1b" :foreground "#4477ff"))))
   ;`(lazy-highlight ((,class (:background "#384048" :foreground "#a0a8b0"))))
   ;; Button and link faces
   `(link ((,class (:foreground "#8ac6f2" :underline t))))
   `(link-visited ((,class (:foreground "#e5786d" :underline t))))
   `(button ((,class (:background "#333333" :foreground "#f6f3e8"))))
   `(header-line ((,class (:background "#303030" :foreground "#e7f6da"))))
   ;; Gnus faces
   `(gnus-group-news-1 ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-group-news-1-low ((,class (:foreground "#95e454"))))
   `(gnus-group-news-2 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-news-2-low ((,class (:foreground "#cae682"))))
   `(gnus-group-news-3 ((,class (:weight bold :foreground "#ccaa8f"))))
   `(gnus-group-news-3-low ((,class (:foreground "#ccaa8f"))))
   `(gnus-group-news-4 ((,class (:weight bold :foreground "#99968b"))))
   `(gnus-group-news-4-low ((,class (:foreground "#99968b"))))
   `(gnus-group-news-5 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-news-5-low ((,class (:foreground "#cae682"))))
   `(gnus-group-news-low ((,class (:foreground "#99968b"))))
   `(gnus-group-mail-1 ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-group-mail-1-low ((,class (:foreground "#95e454"))))
   `(gnus-group-mail-2 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-mail-2-low ((,class (:foreground "#cae682"))))
   `(gnus-group-mail-3 ((,class (:weight bold :foreground "#ccaa8f"))))
   `(gnus-group-mail-3-low ((,class (:foreground "#ccaa8f"))))
   `(gnus-group-mail-low ((,class (:foreground "#99968b"))))
   `(gnus-header-content ((,class (:foreground "#8ac6f2"))))
   `(gnus-header-from ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-header-subject ((,class (:foreground "#cae682"))))
   `(gnus-header-name ((,class (:foreground "#8ac6f2"))))
   `(gnus-header-newsgroups ((,class (:foreground "#cae682"))))
   ;; Message faces
   `(message-header-name ((,class (:foreground "#8ac6f2" :weight bold))))
   `(message-header-cc ((,class (:foreground "#95e454"))))
   `(message-header-other ((,class (:foreground "#95e454"))))
   `(message-header-subject ((,class (:foreground "#cae682"))))
   `(message-header-to ((,class (:foreground "#cae682"))))
   `(message-cited-text ((,class (:foreground "#99968b"))))
   `(message-separator ((,class (:foreground "#e5786d" :weight bold))))))

(custom-theme-set-variables
 'shomshing
 '(ansi-color-names-vector ["#1b1b1b" "#cc4444" "#55aa55" "#ee9966"
			    "#4477ff" "#bb33bb" "#22aaaa" "#808080"]))

(provide-theme 'shomshing)

;; Local Variables:
;; no-byte-compile: t
;; End:

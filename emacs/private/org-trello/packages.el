;;; packages.el --- org-trello layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Ramz Sivagurunathan <ramz.sivagurunathan@IIT-LAPTOP-169>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `org-trello-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `org-trello/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `org-trello/pre-init-PACKAGE' and/or
;;   `org-trello/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst org-trello-packages
  '(org-trello)
  "The list of Lisp packages required by the org-trello layer.")

(defun org-trello/post-init-org-trello()
  (print "org-mode-trello-done")
  (progn
    (evil-leader/set-key
      "ots" 'org-trello/sync-buffer
      "otc" 'org-trello/sync-card
      )))
;;; packages.el ends here

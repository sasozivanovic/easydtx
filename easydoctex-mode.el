;; easydoctex-mode.el 0.2.0
;;
;; This file is a part of TeX package EasyDTX, available at
;; https://ctan.org/pkg/easydtx and https://github.com/sasozivanovic/easydtx.
;;
;; Copyright (c) 2023- Saso Zivanovic <saso.zivanovic@guest.arnes.si>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;; The files belonging to this work and covered by GPL are listed in
;; <texmf>/doc/support/easydtx/FILES.

;; Add this to .emacs to (auto)load EasyDocTeX mode and associate it with .edtx files:
;; (autoload 'easydoctex-mode "easydoctex-mode" "Add DocTeX fontification (and only fontification) to LaTeX mode." t)
;; (add-to-list 'auto-mode-alist '("\\.edtx\\'" . easydoctex-mode))

(define-derived-mode easydoctex-mode TeX-latex-mode "EasyDocTeX"
  "Add DocTeX fontification (and only fontification) to LaTeX mode."
  (setq major-mode 'easydoctex-mode)
  (set (make-local-variable 'LaTeX-insert-into-comments) t)
  (set (make-local-variable 'LaTeX-syntactic-comments) t)
  (setq paragraph-start (concat paragraph-start "\\| *%<")
        paragraph-separate (concat paragraph-separate "\\|%<")
	font-latex-doctex-keywords (append (butlast font-latex-doctex-keywords) '(("^ *%<[^>]*>" (0 font-latex-doctex-preprocessor-face t))))
        )
  (let ((major-mode 'doctex-mode))
    (funcall TeX-install-font-lock)))

(defun easydoctex-wrapper (ORIG-FUNC &rest args)
  (if (eq major-mode 'easydoctex-mode)
      (let ((major-mode 'doctex-mode))
	(apply ORIG-FUNC args))
    (apply ORIG-FUNC args)))

(advice-add 'font-latex-find-matching-close :around #'easydoctex-wrapper)
(advice-add 'font-latex-commented-outp :around #'easydoctex-wrapper)
(advice-add 'font-latex-forward-comment :around #'easydoctex-wrapper)
(advice-add 'font-latex-match-simple-command :around #'easydoctex-wrapper)

(defun easydoctex-no-comment-padding (ORIG-FUNC &rest args)
  (if (and
       (eq major-mode 'easydoctex-mode)
       (save-excursion
         (beginning-of-line)
         (looking-at " *%<")
	 ))
      ""
    (apply ORIG-FUNC args)))
(advice-add 'TeX-comment-padding-string :around #'easydoctex-no-comment-padding)

(defun easydoctex-guard-is-code (ORIG-FUNC &rest args)
  (if (and
       (eq major-mode 'easydoctex-mode)
       (save-excursion
	 (beginning-of-line)
	 (looking-at " *%<")))
      nil
    (apply ORIG-FUNC args)))
(advice-add 'TeX-in-commented-line :around #'easydoctex-guard-is-code)

(defun font-latex-easydoctex-syntactic-face-function (ORIG-FUNC state &rest args)
  "In EasyDTC (.edtx), % can start after any blanks, but it should not be followed by another % or a guard."
  (if (eq major-mode 'easydoctex-mode)
      (if (or
	   (nth 3 state)
	   (nth 7 state)
	   (save-excursion
	     (goto-char (nth 8 state))
	     (skip-chars-backward " \t")
	     (not (bolp)))
	   (char-equal (char-after (1+ (nth 8 state))) ?%))
	  (apply ORIG-FUNC state args)
	font-latex-doctex-documentation-face)
    (apply ORIG-FUNC state args)))
(advice-add
 'font-latex-doctex-syntactic-face-function :around
 #'font-latex-easydoctex-syntactic-face-function)

(defun LaTeX-current-environment-no-macrocode (env)
  "The only (and obligatory) macrocode environment does not count as an environment."
  (if (member env '("macrocode" "macrocode*")) "document" env))
(advice-add 'LaTeX-current-environment :filter-return #'LaTeX-current-environment-no-macrocode)
;; (advice-remove 'LaTeX-current-environment#'LaTeX-current-environment-no-macrocode)

(defun server-visit-files-forward-to-edtx (args)
  "When inverse search points to a .dtx generated from .edtx, visit
the original .edtx file instead."
  (dolist (file-pos (nth 0 args))
    (let* ((file (car file-pos))
	   (pos (cdr file-pos))
	   (edtx (concat (file-name-sans-extension file) ".edtx"))
	   )
      (when (and pos
		 (string-match "dtx" (file-name-extension file))
		 (file-readable-p edtx))
	(setcar file-pos edtx)
 	  (let* ((line (car pos))
 		 (col (cdr pos))
		 (dtx-buffer (find-file-noselect file nil t))
 		 (line-offset
 		  (with-current-buffer dtx-buffer
		    (widen)
		    (goto-char 1)
		    (forward-line (1- line))
		    (move-to-column col)
 		    (count-matches "^%    \\\\\\(begin\\|end\\){macrocode}" 0 (point)))))
 	    (when (> line-offset 1)
	      (set 'line-offset (1- line-offset)))
	    (setcdr file-pos (cons (- line line-offset) col))
	    ))))
  args)
(advice-add 'server-visit-files :filter-args #'server-visit-files-forward-to-edtx)
;; (advice-remove 'server-visit-files #'server-visit-files-forward-to-edtx)



;; Forward search for .edtx
(defun TeX-current-file-name-master-relative--edtx (r)
  (if (equal (file-name-extension r) "edtx")
      (concat (file-name-sans-extension r) ".dtx")
    r))
(advice-add 'TeX-current-file-name-master-relative :filter-return
	    #'TeX-current-file-name-master-relative--edtx)
(defun TeX-current-line--edtx (line)
  (when (equal (file-name-extension (buffer-file-name)) "edtx")
    (let ((remaining (string-to-number line))
	  (dtx-buffer (find-file-noselect (concat (file-name-sans-extension (buffer-file-name)) ".dtx") nil t)))
      (with-current-buffer dtx-buffer
	(widen)
	(goto-char 1)
	(setq line 0)
	(while (> (setq remaining (1- remaining)) 0)
	  (while (progn (forward-line 1)
			(setq line (1+ line))
			(looking-at "%    \\\\\\(begin\\|end\\){macrocode}")))))
      (setq line (format "%d" line))))
  line)
(advice-add 'TeX-current-line :filter-return #'TeX-current-line--edtx)

;;; ctrlxo.el --- Switch to the most recently used window -*- lexical-binding: t -*-

;; Copyright (C) 2020 Andrii Kolomoiets

;; Author: Andrii Kolomoiets <andreyk.mad@gmail.com>
;; Keywords: frames
;; URL: https://github.com/muffinmad/emacs-ctrlxo
;; Package-Version: 1.2
;; Package-Requires: ((emacs "25.1"))

;; This file is NOT part of GNU Emacs.

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

;;; Commentary:

;; Switch to the most recently used window.
;;
;; Use the `ctrlxo' function to start switching between windows on visible
;; frames in the recent usage ordering.
;; `ctrlxo' also activates transient keymap:
;; - o to switch to the next window
;; - O to switch to the previous window
;; - C-g to cancel switching and select window that was active on `ctrlxo'
;;   invocation
;;
;; Use the `ctrlxo-current-frame' function to start switching between windows
;; on the current frame.
;;
;; Following example configuration will allow to switch between windows on
;; all visible frames with 'C-TAB' and between windows on the current frame
;; with 'C-x o':
;;
;;     (require 'ctrlxo)
;;     (global-set-key (kbd "C-<tab>") #'ctrlxo)
;;     (global-set-key (kbd "C-x o") #'ctrlxo-current-frame)
;;     (define-key ctrlxo-map (kbd "<tab>") #'ctrlxo-forward)
;;     (define-key ctrlxo-map (kbd "<S-tab>") #'ctrlxo-backward)


;;; Code:

(require 'seq)

(defgroup ctrlxo nil
  "Select most recently used window."
  :group 'windows)

(defcustom ctrlxo-inhibit-usage-message nil
  "Inhibit usage message on transient keymap activation."
  :type 'boolean)

(defcustom ctrlxo-frames 'visible
  "What frames to consider."
  :type '(choice (const :tag "Current frame" nil)
                 (const :tag "All visible frames" visible)
                 (const :tag "All visible and iconified frames" 0)))

(defvar ctrlxo--window-list nil)
(defvar ctrlxo--selected-window nil)

(defun ctrlxo--make-window-list ()
  "Build window list sorted by recent usage."
  (setq ctrlxo--window-list (sort (window-list-1 nil nil ctrlxo-frames)
                                 (lambda (w1 w2)
                                   (> (window-use-time w1)
                                      (window-use-time w2))))))

(defvar ctrlxo-map
  (let ((map (make-sparse-keymap)))
    (define-key map "o" #'ctrlxo-forward)
    (define-key map "O" #'ctrlxo-backward)
    (define-key map "\C-g" #'ctrlxo-cancel)
    map)
  "Transient keymap for switching to the next recent window.")

(defun ctrlxo--switch (num)
  "Select next NUM most recent window."
  (unless ctrlxo--window-list
    (ctrlxo--make-window-list))
  (let* ((idx (seq-position ctrlxo--window-list (selected-window)))
         (idx (if idx
                  (mod (+ idx num) (length ctrlxo--window-list))
                0)))
    (select-window (elt ctrlxo--window-list idx) 'mark-for-redisplay)
    (select-frame-set-input-focus (selected-frame) t)))

(defun ctrlxo--map-exit ()
  "Record selected window."
  (select-window (selected-window)))

(defun ctrlxo-forward ()
  "Select next recent window."
  (interactive)
  (ctrlxo--switch 1))

(defun ctrlxo-backward ()
  "Select previous recent window."
  (interactive)
  (ctrlxo--switch -1))

(defun ctrlxo-cancel ()
  "Cancel window switching.
Select window that was active before invocation of `ctrlxo'."
  (interactive)
  (when ctrlxo--selected-window
    (select-window ctrlxo--selected-window)
    (select-frame-set-input-focus (selected-frame))))

;;;###autoload
(defun ctrlxo ()
  "Build window list and switch to the most recently used window.
Activate transient keymap to switch to the next recently used window."
  (interactive)
  (setq ctrlxo--selected-window (selected-window))
  (ctrlxo--make-window-list)
  (ctrlxo-forward)
  (unless ctrlxo-inhibit-usage-message
    (message
     (substitute-command-keys
      "Next window: \\<ctrlxo-map>\\[ctrlxo-forward], previous window: \\<ctrlxo-map>\\[ctrlxo-backward], cancel switch: \\<ctrlxo-map>\\[ctrlxo-cancel].")))
  (set-transient-map ctrlxo-map t #'ctrlxo--map-exit))

;;;###autoload
(defun ctrlxo-current-frame ()
  "Switch between windows on the current frame."
  (interactive)
  (let (ctrlxo-frames)
    (ctrlxo)))


(provide 'ctrlxo)

;;; ctrlxo.el ends here

;; --*- mode: emacs-lisp;  mode: outline-minor -*--

(server-start)


;;; Scroll by a whole screen!
(setq mouse-wheel-scroll-amount nil)

(setq visible-bell 1)

(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(global-set-key "\C-ce" (quote char-till-end))
(global-set-key "\C-cd" 'comment-region)
(global-set-key "\C-cg" 'goto-line)
(global-set-key [f6] 'line-to-top-of-window)
(global-set-key "\C-cl" 'line-to-top-of-window)
(global-set-key "\C-x\C-b" 'list-buffers)
(global-set-key "\C-cp" 'push-point)
(global-set-key "\C-cr" 'replace-string)
(global-set-key "\C-cR" 'replace-regexp)


(defun char-till-end ()
  (interactive)
  (let* ((num-chars (- 78 (current-column)))
         (the-char nil))

    (if (> num-chars 0)
        (setq the-char (read-char "char: " t)))
    (while (> num-chars 0)
      (insert the-char)
      (setq num-chars (- num-chars 1)))))

(defun line-to-top-of-window ()
  "Move the line point to top of window."
  (interactive) 
  (recenter 0))

(defun pretty-xml (pointmin pointmax)
  (interactive "r")
  (replace-string "&amp;" "&" nil pointmin pointmax)
  (replace-string "&lt;" "<" nil pointmin pointmax)
  (replace-string "&gt;" ">" nil pointmin pointmax)
  (replace-string "><" ">
<" nil pointmin pointmax)
  (indent-region pointmin pointmax)
)

(defun push-point ()
  (interactive)
  (line-to-top-of-window)
  (split-window-vertically 5)
  (other-window 1))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

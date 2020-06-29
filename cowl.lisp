;;;; cowl.lisp

(in-package #:cowl)

(defun main ()
  (with-main-window (window 'main-window)
    (q+ set-window-title window "cowl")))
      

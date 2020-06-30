;;;; cowl.lisp

(in-package #:cowl)

(defun main ()
  (with-main-window (window 'main-window)
    (q+ set-maximum-size window 200 200)
    (q+ set-window-title window "cowl")))
      

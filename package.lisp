;;;; package.lisp

(defpackage #:cowl
  (:use #:cl+qt))

(in-package :cowl)

(declaim (inline agetf))

(defun agetf (place indicator &optional default)
  (or (cdr (assoc indicator place :test #'equal))
      default))



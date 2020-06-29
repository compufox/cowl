;;;; cowl.asd

(asdf:defsystem #:cowl
  :description "Describe cowl here"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-cffi-gtk #:dexador #:uiop
	       #:bordeaux-threads #:cl-json
	       #:str)
  :components ((:file "package")
               (:file "cowl"))
  :build-operation "program-op"
  :build-pathname "bin/cowl"
  :entry-point "cowl::main")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))


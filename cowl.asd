;;;; cowl.asd

(asdf:defsystem #:cowl
  :description "Describe cowl here"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.0.1"
  :serial t
  :depends-on (#:qtools #:dexador #:uiop
	       #:bordeaux-threads #:cl-json
	       #:str #:qtgui #:qtcore)
  :components ((:file "package")
	       (:file "net")
	       (:file "gui")
               (:file "cowl"))
  :build-operation "qt-program-op"
  :build-pathname "cowl"
  :entry-point "cowl::main")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))


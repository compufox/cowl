;;;; cowl.asd

(asdf:defsystem #:cowl
  :description "qt app to download emojis from mastodon/pleroma"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.1.1"
  :serial t
  :depends-on (#:qtools #:dexador #:uiop #:cl-json
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


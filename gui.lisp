(in-package :cowl)
(in-readtable :qtools)

(defmacro with-widget-disabled (widget &body body)
  `(progn
     (setf (q+ enabled ,widget) nil)
     ,@body
     (setf (q+ enabled ,widget) t)))

(define-widget main-window (QWidget) ())

(define-subwidget (main-window txt-instance) (q+ make-qlineedit main-window)
  (setf (q+ placeholder-text txt-instance) "mastodon.social"))
(define-subwidget (main-window btn-download) (q+ make-qpushbutton "Download" main-window))
(define-subwidget (main-window btn-quit) (q+ make-qpushbutton "Quit" main-window))
(define-subwidget (main-window btn-picker) (q+ make-qpushbutton "~" main-window)
  (setf (q+ text btn-picker) (uiop:getenv "HOME")
	*current-out* (uiop:getenv "HOME")))

(define-subwidget (main-window progress-bar) (q+ make-qprogressdialog 
						 "Downloading emojis..." ; widget label
						 "Cancel"                ; cancel button label
						 0 1                     ; min max
						 main-window)            ; parent
  (q+ hide progress-bar))

(define-subwidget (main-window win-layout) (q+ make-qgridlayout main-window)
  (let ((inst-label (q+ make-qlabel "Instance url:"))
	(dir-label (q+ make-qlabel "Save to:")))
    (q+ add-widget win-layout inst-label 0 0 1 1)
    (q+ add-widget win-layout txt-instance 0 1 1 1)
    (q+ add-widget win-layout dir-label 1 0 1 1)
    (q+ add-widget win-layout btn-picker 1 1 1 1)
    (q+ add-widget win-layout btn-download 2 0 1 1)
    (q+ add-widget win-layout btn-quit 2 1 1 1)))

(define-slot (main-window btn-download) ()
  (declare (connected btn-download (pressed)))
  (declare (connected txt-instance (return-pressed)))
  (with-widget-disabled btn-download
    (download-emojis (q+ text txt-instance)
		     *current-out*
		     progress-bar)))
(define-slot (main-window btn-picker) ()
  (declare (connected btn-picker (pressed)))
  (setf *current-out* (or (#_QFileDialog::getExistingDirectory main-window "Select folder to download emojis" *current-out*)
			  *current-out*))
  (setf (q+ text btn-picker) *current-out*))
(define-slot (main-window btn-quit) ()
  (declare (connected btn-quit (pressed)))
  (uiop:quit 0))

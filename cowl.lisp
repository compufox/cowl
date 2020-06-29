;;;; cowl.lisp

(in-package #:cowl)

(defvar *emoji-template* "https://~A/api/v1/custom_emojis")
(defparameter *builder* (gtk-builder-new))

(defun agetf (place indicator &optional default)
  (or (cdr (assoc indicator place :test #'equal))
      default))

(defun start-download ()
  (let ((instance-entry (gtk-builder-get-object *builder* "txtInstance"))
	(file-chooser (gtk-builder-get-object *builder* "btnFileChooser"))
	(progress-bar (gtk-builder-get-object *builder* "prgDownload"))
	(error-window (gtk-builder-get-object *builder* "errWindow"))
	(error-label (gtk-builder-get-object *builder* "lblError"))
	(submit-button (gtk-builder-get-object *builder* "btnSubmit")))
    (handler-case
	(let* ((emoji-list (json:decode-json-from-string
			    (dex:get (format nil *emoji-template*
					     (str:replace-all "https://" ""
							      (gtk-entry-text instance-entry))))))
	       (emoji-amount (length emoji-list)))
	  (gtk-widget-show progress-bar)
	  (loop with outdir = (gtk-file-chooser-get-uri file-chooser)
		for emoji in emoji-list
		for count from 1 upto emoji-amount
		do
		   (dex:fetch (agetf emoji :url)
			      (merge-pathnames
			       (concatenate 'string
					    (agetf emoji :name)
					    "."
					    (pathname-type (agetf emoji :name)))
			       outdir))
		   (setf (gtk-progress-bar-fraction progress-bar)
			 (/ count emoji-amount))))
      (error (e)
	(format t "~a~%" e)))
;	(setf (gtk-label-label error-label)
;	      (format nil "Encountered error: ~a"
;		      e))
;	(gtk-widget-show-all error-window)))
    (setf (gtk-widget-sensitive submit-button) t)))
    
    

(defun main ()
  (within-main-loop
    (gtk-builder-add-from-file *builder* "./resources/ui.glade")
    (let ((window (gtk:gtk-builder-get-object *builder* "mainWindow"))
	  (submit-button (gtk:gtk-builder-get-object *builder* "btnSubmit"))
	  (quit-button (gtk:gtk-builder-get-object *builder* "btnQuit")))
      (g-signal-connect window "destroy" #'leave-gtk-main)
      (g-signal-connect quit-button "clicked" #'leave-gtk-main)
      (g-signal-connect submit-button "clicked"
			(lambda (w)
			  (declare (ignore w))
			  (setf (gtk-widget-sensitive w) nil)
			  (bt:make-thread #'start-download)))
      (gtk-widget-show-all window))))
      

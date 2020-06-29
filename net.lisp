(in-package :cowl)

(defvar *emoji-template* "https://~A/api/v1/custom_emojis")
(defvar *current-out* nil)

(defun fetch-emoji (emoji output)
  (let ((out-path (merge-pathnames
		   (concatenate 'string
				(agetf emoji :shortcode)
				"."
				(pathname-type (agetf emoji :url)))
		   output))
	(url (agetf emoji :url)))
    (dex:fetch url out-path :if-exists nil)))

(defun fetch-emoji-list (instance)
  (let ((url (format nil *emoji-template*
		     (str:replace-all "https://" "" instance))))
    (json:decode-json-from-string (dex:get url))))

(defun download-emojis (instance output progress)
  (handler-case
      (let* ((emoji-list (fetch-emoji-list instance))
	     (emoji-amount (length emoji-list))
	     (output (uiop:ensure-pathname (concatenate 'string output "/")
					   :namestring :native)))
	(q+ set-window-title progress "Downloading...")
	(q+ open progress)
	(setf (q+ maximum progress) emoji-amount)
	(loop for emoji in emoji-list
	      for count from 1 upto emoji-amount
	      do
		 (fetch-emoji emoji output)
		 (setf (q+ value progress) count)))
    (error (e)
      (format t "~a~%" e)
      (q+ close progress))))

(in-package :com.clearly-useful.nick)

;;; instrument asdf to bind nicknames
;;; when a system property is set.

(defun %get-nicks (component)
  (getf (asdf:component-property
	 (asdf:component-system component)
	 :com.clearly-useful)
	:nicks))

(defun %pair-nicks (nicks)
  (when nicks
    (loop for (designator nickname) on nicks by #'cddr
	 collect (list designator nickname))))

(defun %w/nicks (component fn)
  (let ((nicks (%get-nicks component)))
    (if nicks
	(call-with-package-nicknames (%pair-nicks nicks) fn)
	(funcall fn))))

(defmethod asdf:perform :around
    ((operation asdf:load-op) (file asdf:cl-source-file))
  (%w/nicks file #'call-next-method))

(defmethod asdf:perform :around
    ((operation asdf:compile-op) (file asdf:cl-source-file))
  (%w/nicks file #'call-next-method))

(defmethod asdf:perform :around
    ((operation asdf:compile-op) (file asdf:cl-source-file))
  (%w/nicks file #'call-next-method))

(defmethod asdf:perform :around
    ((operation asdf:compile-op) (file asdf:cl-source-file))
  (%w/nicks file #'call-next-method))

(in-package :com.clearly-useful.nick)

(%set-world-state (state-of-the-world))


(defpackage :foo)

(defvar *cl* (find-package :cl))
(defvar *cl-state* (package-state *cl*))
(defvar *foo* (find-package :foo))
(defvar *foo-state* (package-state *foo*))

;;test the test
(assert (package-state-equal-p *foo-state*
			       (package-state *foo*)))

(assert (package-state-equal-p *cl-state*
			       (package-state *cl*)))

;;test basic renaming
(assert (eq *foo*
	    (call-with-altered-state
	     (list (list *foo* "FROB" nil))
	     (lambda ()
	       (assert (not (package-state-equal-p
			     (package-state *foo*)
			     *foo-state*)))
	       (find-package :frob)))))


;;assure that things are back to normal
(assert (eq *foo* (find-package :foo)))
(assert (package-state-equal-p *foo-state*
			       (package-state *foo*)))

;;test assertive renaming
(assert (eq *foo*
	    (call-with-package-nicknames
	     '((foo cl))
	     (lambda ()
	       (find-package :cl)))))

(defparameter *marco* nil)

;;loads with cl bound to com.clearly-useful.nick
;;and sets cl::*marco*

(asdf:oos 'asdf:load-op :com.clearly-useful.nick.dummy)

(assert (eq *marco* :polo))

;;pretty important :P
(assert (eq *cl* (find-package :cl)))
(assert (package-state-equal-p *cl-state*
			       (package-state *cl*)))

;;;; com.clearly-useful.nick.lisp

(in-package #:com.clearly-useful.nick)

(defun all-package-names ()
  (loop for package in (list-all-packages)
       appending (cons (package-name package)
		       (package-nicknames package))))


(defun package-name-available-p (nick)
  (member (string nick) (all-package-names) :test 'string=))

(defun state-of-the-world ()
  (loop for package in (list-all-packages)
       collect (list package (package-name package)
		     (package-nicknames package))))

(defun package-state (package)
  (list (package-name package)
	(package-nicknames package)))

(defun %augment-package-state (state nick)
  (list (first state)
	(cons nick (second state))))

(defun set-package-state (package state)
  (let (
	#+allegro
	(excl:*enable-package-locked-errors* nil)
	(locked (package-locked-p package)))
    (when locked (unlock-package package))
    (unwind-protect
	 (if (not (null (cadr state)))
	     (rename-package package (first state) (cadr state))
	     (rename-package package (first state)))
      (when locked (lock-package package)))
    ))

(defun package-state-equal-p (a b)
  (and (string= (first a) (first b))
       (null (set-difference (cadr a) (cadr b) :test 'string=))
       (null (set-difference (cadr b) (cadr a) :test 'string=))))

(defun %set-world-state (state)
  (loop for (package . package-state) in state
       do (set-package-state package package-state)))

(defun %clear-state (state)
  (loop for list in state
       for package = (first list)
     do (set-package-state package (list (string (gensym))
					 (list (string (gensym)))))))


(defun call-with-altered-state (state fn)
  (let ((prior (state-of-the-world)))
    (unwind-protect (progn
		      (%set-world-state state)
		      (funcall fn))
      (%clear-state state)
      (%set-world-state prior))))




(defun call-with-package-nicknames (names fn)
  "names are a list of (list designator nickname)"
  (let ((conflicts (list)))
    (loop for list in names
	 for nick = (second list)
	 for existing = (find-package nick) 
	 when existing
	 do (let* ((state (package-state existing))
		   (name (first state))
		   (nicks (second state))
		   (nick (string nick)))
	      
	      (if (string= nick name)
		  ;;change the name of the package
		  (push (list existing
			      (string (gensym name))
			      nicks)
			conflicts)
		  ;;change one of the package nicknames
		  (push (list existing
			      name
			      (cons (gensym nick)
				    (remove nick
					    nicks
					    :test 'string=)))
			conflicts))))
    (setq names (loop for (name nick) in names
		   for package = (find-package name)
		   collect
		     (cons package
			   (%augment-package-state
			    (package-state package)
			    nick))))
    (call-with-altered-state (append conflicts names) fn)))

(in-package :com.clearly-useful.nick)

#+ecl
(ffi:defcbody %package-locked-p (ffi:object) ffi:object
	      "(si_coerce_to_package((#0))->pack.locked) ? ECL_T : ECL_NIL ")
#+ecl
(compile '%package-locked-p)

;;;;; some compat functions from elliottjohnson's project
;; slightly modifitted

;; -- snip --

;; Copyright (c) 2011 Elliott Johnson

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

(defun package-locked-p (package)
  "Returns true if a given resolveable PACKAGE is locked."
  (let ((pkg package))
    (when pkg
      #+allegro (values (excl:package-lock pkg) 
			(excl:package-definition-lock pkg))
      #+clisp (ext:package-lock pkg)
      #+cmucl (values (ext:package-lock pkg)
		      (ext:package-definition-lock pkg))
      #+sb-package-locks (sb-ext:package-locked-p pkg)
      #+ecl (%package-locked-p pkg)
      #-(or allegro clisp cmucl sb-package-locks ecl) nil)))

(defun lock-package (package)
  "Locks a provided package."
  (let ((pkg package))
    (when pkg
      #+allegro (setf (excl:package-lock pkg) t
		      (excl:package-definition-lock pkg) t)
      #+clisp (setf (ext:package-lock pkg) t)
      #+cmucl (setf (ext:package-lock pkg) t
		    (ext:package-definition-lock pkg) t)
      #+sb-package-locks (sb-ext:lock-package pkg)
      #+ecl (si:package-lock pkg t)
      #-(or allegro clisp cmucl sb-package-locks ecl) nil)))

(defun unlock-package (package)
  "Unlocks a provided package."
  (let ((pkg package))
    (when pkg
      #+allegro (setf (excl:package-lock pkg) nil
		      (excl:package-definition-lock pkg) nil)
      #+clisp (setf (ext:package-lock pkg) nil)
      #+cmucl (setf (ext:package-lock pkg) nil
		    (ext:package-definition-lock pkg) nil)
      #+sb-package-locks (sb-ext:unlock-package pkg)
      #+ecl (si:package-lock pkg nil)
      #-(or allegro clisp cmucl sb-package-locks ecl) nil)))

;;;;; --snip--


;;;; com.clearly-useful.nick.asd

(asdf:defsystem #:com.clearly-useful.nick
  :serial t
  :description "experimental automatic package nicknaming"
  :version "0.1"
  :author "Jason Aeschliman <j.aeschliman@gmail.com>"
  :license "revised BSD"
  :depends-on (#:asdf)
  :components ((:file "package")
	       (:file "compat")
               (:file "com.clearly-useful.nick")
	       (:file "asdf-exts")))


(asdf:defsystem  #:com.clearly-useful.nick.dummy
    :defsystem-depends-on (#:com.clearly-useful.nick)
    :serial t
    :components ((:file "dummy"))
    :properties
    ((:com.clearly-useful
      :nicks
      ;;assure that the package
      ;;com.clearly-useul.nick
      ;;is available via the name
      ;;cl during loading and compiling.
      (:com.clearly-useful.nick :cl))))

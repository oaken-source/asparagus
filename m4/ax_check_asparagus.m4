
dnl this script should be used for autoconf integration of asparagus.

# Allow to check for the asparagus testing framework
AC_DEFUN([AX_CHECK_ASPARAGUS], [

  dnl require sed
  AC_PROG_SED

  PKG_CHECK_MODULES([asparagus], [asparagus], [
      AC_SUBST([HAVE_ASPARAGUS], [1])
      AC_SUBST([asparagus_LIBS])
      AC_SUBST([asparagus_CFLAGS])

      dnl strip trailing whitespace or runtest chokes
      AC_SUBST([DEJAGNU], [$(echo $asparagus_LIBS | $SED 's/ *$//')])
    ], [
      AC_SUBST([HAVE_ASPARAGUS], [0])
      AC_MSG_WARN([missing asparagus framework - can not run test suite])
    ])

])

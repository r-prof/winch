#!/bin/bash

set -e
set -x
cd $(dirname $0)

PKG_CFLAGS=""

# Only on x64 (known to fail on i386)
if [ "x${R_ARCH}" = "x/x64" ]; then

nproc=`nproc || echo 2`

# Only if libbacktrace can be configured and built
# (need to use make because environment variables are set in etc/Makeconf)
if make -j ${nproc} -l ${nproc} -f ${R_HOME}/etc${R_ARCH}/Makeconf -f Makevars.configure.win; then

PKG_LIBBACKTRACE="-DHAVE_LIBBACKTRACE"
WINCH_LOCAL_LIBS="local/lib/libbacktrace.a"
PKG_LIBS=""

fi

fi

# Final, with our definitions
PKG_CFLAGS="$PKG_CFLAGS $PKG_LIBUNWIND $PKG_LIBBACKTRACE"

# Write to Makevars
sed -e "s|@cflags@|$PKG_CFLAGS|" -e "s|@libs@|$PKG_LIBS|" -e "s|@winch_local_libs@|$WINCH_LOCAL_LIBS|" -e "s|@header@|# Generated from Makevars.in, do not edit by hand|" Makevars.in > Makevars.new
if [ ! -f Makevars ] || (which diff > /dev/null && ! diff -q Makevars Makevars.new); then
  cp -f Makevars.new Makevars
fi
rm -f Makevars.new

# Success
exit 0

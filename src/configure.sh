#!/bin/sh

set -e
cd `dirname $0`

# Anticonf (tm) script by Jeroen Ooms, Murat Tasan and Kirill Müller (2020)
# This script will prefer cflags (specifically includefile dirs) and lib dirs
# in the following order of precedence:
#   (1) INCLUDE_DIR or LIB_DIR entered explicitly on the command line, e.g.
#       R CMD INSTALL --configure-vars='INCLUDE_DIR=/.../include LIB_DIR=/.../lib'
#   (2) Values found via 'pkg-config' for the libunwind package.

# Library settings
PKG_CONFIG_NAME="libunwind"
PKG_DEB_NAME="libunwind-dev"
PKG_RPM_NAME="libunwind-devel"
PKG_URL="https://github.com/libunwind/libunwind"
PKG_TEST_HEADER="<libunwind.h>"

PKG_CFLAGS=""
PKG_LIBUNWIND=""
PKG_LIBBACKTRACE=""
PKG_LIBS=""
WINCH_LOCAL_LIBS=""

# pkg-config values (if available)
case "$OSTYPE" in
 darwin*)
  # -lSystem sufficient on the Mac, no installation needed
  # (will check anyway)
  PKG_LIBUNWIND="-DHAVE_LIBUNWIND"
  PKG_LIBS="-lSystem"
  ;;
 msys*)
  # handled in configure.win.sh
  false
  ;;
 solaris*)
  PKG_LIBBACKTRACE="-DHAVE_LIBBACKTRACE"
  ;;
 *)
  PKG_LIBUNWIND="-DHAVE_LIBUNWIND"
  PKG_LIBBACKTRACE="-DHAVE_LIBBACKTRACE"

  if [ `command -v pkg-config` ]; then
    PKGCONFIG_CFLAGS=`pkg-config --cflags --silence-errors ${PKG_CONFIG_NAME} || true`
    PKGCONFIG_LIBS=`pkg-config --libs --silence-errors ${PKG_CONFIG_NAME} || true`
    PKGCONFIG_MODVERSION=`pkg-config --modversion --silence-errors ${PKG_CONFIG_NAME} || true`
  fi

  # Note that cflags may be empty in case of success
  if [ "$INCLUDE_DIR" ] || [ "$LIB_DIR" ]; then
    echo "Found INCLUDE_DIR and/or LIB_DIR!"
    PKG_CFLAGS="-I$INCLUDE_DIR $PKG_CFLAGS"
    PKG_LIBS="-L$LIB_DIR $PKG_LIBS"
  elif [ "$PKGCONFIG_CFLAGS" ] || [ "$PKGCONFIG_LIBS" ]; then
    echo "Found pkg-config cflags and libs ($PKG_CONFIG_NAME $PKGCONFIG_MODVERSION)!"
    PKG_CFLAGS="$PKGCONFIG_CFLAGS"
    PKG_LIBS="$PKGCONFIG_LIBS"
  else
    echo "No cflags and libs found!"
    PKG_CFLAGS=""
  fi
  ;;
esac

if [ -n "$PKG_LIBUNWIND" ]; then

# For debugging
echo "Using PKG_CFLAGS=$PKG_CFLAGS"
echo "Using PKG_LIBS=$PKG_LIBS"

# Find compiler
CC=`${R_HOME}/bin/R CMD config CC`
CFLAGS=`${R_HOME}/bin/R CMD config CFLAGS`
CPPFLAGS=`${R_HOME}/bin/R CMD config CPPFLAGS`

# Test configuration
echo "#include $PKG_TEST_HEADER" | ${CC} ${CPPFLAGS} ${PKG_CFLAGS} ${CFLAGS} -E -xc - >/dev/null 2>&1 || R_CONFIG_ERROR=1;

# Customize the error
if [ $R_CONFIG_ERROR ]; then
  echo "------------------------- ANTICONF ERROR ---------------------------"
  echo "$PKG_CONFIG_NAME was not found. Try installing:"
  echo " * deb: $PKG_DEB_NAME (Debian, Ubuntu, etc)"
  echo " * rpm: $PKG_RPM_NAME (Fedora, EPEL)"
  echo " * from source: $PKG_URL"
  echo "If $PKG_CONFIG_NAME is already installed, check that either:"
  echo "'pkg-config' is in your PATH AND PKG_CONFIG_PATH contains"
  echo "a $PKG_CONFIG_NAME.pc file."
  echo "If it cannot detect $PGK_CONFIG_NAME, you can set INCLUDE_DIR"
  echo "and LIB_DIR manually via:"
  echo "R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=...'"
  echo "--------------------------------------------------------------------"
  echo "Proceeding without $PKG_CONFIG_NAME."
  PKG_LIBUNWIND=""
fi

fi # if [ -n "$PKG_LIBUNWIND" ]; then

if [ -n "$PKG_LIBBACKTRACE" ]; then

  nproc=`nproc || echo 1`

  # Only if libbacktrace can be configured and built
  # (need to use make because environment variables are set in etc/Makeconf)
  if make -j ${nproc} -l ${nproc} -f ${R_HOME}/etc${R_ARCH}/Makeconf -f Makevars.configure; then
    WINCH_LOCAL_LIBS="local/lib/libbacktrace.a"
  else
    PKG_LIBBACKTRACE=""
  fi

fi # if [ -n "$PKG_LIBBACKTRACE" ]; then

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

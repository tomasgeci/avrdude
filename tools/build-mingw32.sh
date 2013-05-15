#! /bin/sh

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Joerg Wunsch wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------

# Script to cross-compile a MinGW32 executable under unixish host.
# Run this script from within the tools/ subdirectory.
# Override MINGW32_PREFIX and LIBUSB_PREFIX from the commandline
# when invoking the script, like
#
# env LIBUSB_PREFIX="$HOME/dos/ProgramFiles/LibUSB-Win32" ./build-mingw32.sh
#
# The LibUSB-Win32 package is shipped as a self-installing
# executable; it can be unpacked using Wine, and typically
# extracts into the Wine environment.
#
# libelf can be cross-compiled, and installed into the MinGW32
# target environment if desired.

MINGW32_PREFIX=${MINGW32_PREFIX:-/usr/local/mingw32}
LIBUSB_PREFIX=${LIBUSB_PREFIX:-/WINDOWS/ProgramFiles/LibUSB-Win32}

CC=mingw32-gcc

BUILDDIR=build-mingw32
mkdir -p ${BUILDDIR} || { echo "Cannot create build dir $BUILDDIR"; exit 1; }

cd ${BUILDDIR} || { echo "Cannot chdir to $BUILDDIR"; exit 1; }

LDFLAGS="-L${MINGW32_PREFIX}/lib -L${LIBUSB_PREFIX}/lib/gcc"
CPPFLAGS="-I${MINGW32_PREFIX}/include -I${LIBUSB_PREFIX}/include"

env \
    CC="${CC}" \
    CPPFLAGS="${CPPFLAGS}" \
    LDFLAGS="${LDFLAGS}" \
    ../../configure \
    --host=$(../../config.guess) \
    --target=i386-unknowns-mingw32

make all
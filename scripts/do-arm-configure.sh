#!/bin/sh
ARCH=arm-none-eabi
DIR=`dirname $0`/..
echo "DIR=${DIR}"
meson $DIR \
    -Dtarget-optspace=true \
    -Dnewlib-tinystdio=true \
    -Dnewlib-supplied-syscalls=false \
    -Dnewlib-reentrant-small=true\
    -Dnewlib-wide-orient=false\
    -Dnewlib-nano-malloc=true\
    -Dlite-exit=true\
    -Dnewlib-global-atexit=true\
    -Dincludedir=lib/newlib-nano/$ARCH/include \
    -Dlibdir=lib/newlib-nano/$ARCH/lib \
    --cross-file $DIR/cross-$ARCH.txt \
    --buildtype plain

# Build only Cortex-M: thumb/v7-m.  Skip v7e-m, which is for Cortex-M4
ninja \
    newlib/libc/machine/arm/libmachinethumb_v7_m.a \
    newlib/libc/argz/libargzthumb_v7_m.a \
    newlib/libc/ctype/libctypethumb_v7_m.a \
    newlib/libc/errno/liberrnothumb_v7_m.a \
    newlib/libc/iconv/libiconvthumb_v7_m.a \
    newlib/libc/misc/libmiscthumb_v7_m.a \
    newlib/libc/search/libsearchthumb_v7_m.a \
    newlib/libc/signal/libsignalthumb_v7_m.a \
    newlib/libc/ssp/libsspthumb_v7_m.a \
    newlib/libc/stdlib/libstdlibthumb_v7_m.a \
    newlib/libc/string/libstringthumb_v7_m.a \
    newlib/libc/time/libtimethumb_v7_m.a \
    newlib/libc/xdr/libxdrthumb_v7_m.a \
    newlib/libc/locale/liblocalethumb_v7_m.a \
    newlib/libc/tinystdio/libtinystdiothumb_v7_m.a \
    newlib/libc/libthumb_v7_m/libc.a \
    newlib/libm/machine/arm/libmachinethumb_v7_m.a \
    newlib/libm/common/libcommonthumb_v7_m.a


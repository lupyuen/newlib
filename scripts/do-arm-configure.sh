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

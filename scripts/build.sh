#!/usr/bin/env bash
# Build newlib with smallest size for Cortex-M3.  This script must be run at the top level e.g. ./scripts/build.sh.

ARCH=arm-none-eabi
# DIR=`dirname $0`/..
DIR=..
echo "meson dir: ${DIR}"
    
if [ ( -f build-arm-none-eabi/newlib/libc/libthumb_v7_m/libc.a ) -a ( -f build-arm-none-eabi/newlib/libm/libthumb_v7_m/libm.a ) ]; then
    echo Already built, quitting
    exit
fi

echo rm -rf build-arm-none-eabi
rm -rf build-arm-none-eabi

echo mkdir build-arm-none-eabi
mkdir build-arm-none-eabi

echo cd build-arm-none-eabi
cd build-arm-none-eabi

# Configure the build. Select minimal options.
echo meson $DIR \
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

# Build only Cortex-M3: thumb/v7-m.  Skip v7e-m, which is for Cortex-M4
echo ninja \
    newlib/libc/libthumb_v7_m/libc.a \
    newlib/libm/libthumb_v7_m/libm.a
ninja \
    newlib/libc/libthumb_v7_m/libc.a \
    newlib/libm/libthumb_v7_m/libm.a

echo ls -l newlib/libc/libthumb_v7_m
ls -l newlib/libc/libthumb_v7_m
echo ls -l newlib/libm/libthumb_v7_m
ls -l newlib/libm/libthumb_v7_m

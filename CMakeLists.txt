# Build newlib with smallest size for Cortex-M3.  This script must be run at the top level e.g. ./scripts/build.sh.
# Warning: ALl builds will use newlib libc and libm instead of standard C libraries. To check output: ar -t build/libnewlib.a
# cmake version in Yotta Docker image in 3.8.2.
project(newlib)

# enable verbose log. Must be after project()
# set(CMAKE_VERBOSE_MAKEFILE ON)
# set(ENV{VERBOSE} "1")
# message("VERBOSE: $ENV{VERBOSE}")

# apply codal build settings
include("${CODAL_UTILS_LOCATION}")

###############################################################################
# Warning: CMAKE_CXX_LINK_EXECUTABLE is changed globally here

# From https://github.com/lancaster-university/codal/blob/master/utils/cmake/toolchains/ARM_GCC/compiler-flags.cmake
# set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -Wl,-Map,<TARGET>.map -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -lnosys -lstdc++ -lsupc++ -lm -lc -lgcc -lstdc++ -lsupc++ -lm -lc -lgcc -Wl,--end-group  --specs=nano.specs -o <TARGET>")
# To force newlib to be linked, we remove both instances of "-lm -lc -lgcc"
message("CMAKE_CXX_LINK_EXECUTABLE before: ${CMAKE_CXX_LINK_EXECUTABLE}")
string(REPLACE " -lm "   " " CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX_LINK_EXECUTABLE})
string(REPLACE " -lc "   " " CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX_LINK_EXECUTABLE})
string(REPLACE " -lgcc " " " CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX_LINK_EXECUTABLE})

# Remove "--specs=nano.specs" because it links in _malloc_r from nano-mallocr.c.
string(REPLACE " --specs=nano.specs " " " CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX_LINK_EXECUTABLE})

string(CONCAT CMAKE_CXX_LINK_EXECUTABLE
    "${CMAKE_CXX_LINK_EXECUTABLE} "
    # exclude standard C libraries. We will use newlib.
    "-nostdlib "
    # wrap the __aeabi functions in gcc to become __wrap___aeabi so that we can rewrite them.
    # "-Wl,-wrap,__aeabi_d2f "
    "-Wl,-wrap,__aeabi_d2iz "
    "-Wl,-wrap,__aeabi_d2uiz "
    "-Wl,-wrap,__aeabi_dadd "
    "-Wl,-wrap,__aeabi_dcmpeq "
    "-Wl,-wrap,__aeabi_dcmpge "
    "-Wl,-wrap,__aeabi_dcmpgt "
    "-Wl,-wrap,__aeabi_dcmple "
    "-Wl,-wrap,__aeabi_dcmplt "
    "-Wl,-wrap,__aeabi_dcmpun "
    "-Wl,-wrap,__aeabi_ddiv "
    "-Wl,-wrap,__aeabi_dmul "
    "-Wl,-wrap,__aeabi_dsub "
    # "-Wl,-wrap,__aeabi_f2d "
    "-Wl,-wrap,__aeabi_fadd "
    "-Wl,-wrap,__aeabi_fdiv "
    "-Wl,-wrap,__aeabi_fmul "
    "-Wl,-wrap,__aeabi_fsub "
    # "-Wl,-wrap,__aeabi_i2d "
    # "-Wl,-wrap,__aeabi_ui2d "
    # "-Wl,-wrap,__powidf2 "
    # for unwrapped __aeabi functions, link with libgcc.a.
    # wrap the gcc floating-point functions.
    "-Wl,-wrap,__addsf3 "
    "-Wl,-wrap,__divsf3 "
    "-Wl,-wrap,__mulsf3 "
    "-Wl,-wrap,__subsf3 "
    "-lgcc "
)
set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_LINK_EXECUTABLE}" PARENT_SCOPE)  # Share to parent scope
message("CMAKE_CXX_LINK_EXECUTABLE after: ${CMAKE_CXX_LINK_EXECUTABLE}")

###############################################################################
# newlib

# CMAKE_CURRENT_SOURCE_DIR is codal/libraries/newlib
set(NEWLIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
message("NEWLIB_DIR: ${NEWLIB_DIR}")

# built library will be generated here
set (NEWLIB_LIB "${NEWLIB_DIR}/build-arm-none-eabi/newlib")

# build the library
execute_process(
    WORKING_DIRECTORY "${NEWLIB_DIR}" 
    COMMAND "chmod" "+x" "scripts/build.sh"
)
execute_process(
    WORKING_DIRECTORY "${NEWLIB_DIR}" 
    COMMAND "./scripts/build.sh"
)

# find newlib headers.
set(
    TOP_LEVEL_INCLUDE_DIRS
    "${NEWLIB_DIR}/include"
)

# uncomment to build libc and libm
# RECURSIVE_FIND_FILE(NEWLIB_SRC "${NEWLIB_LIB}" "*.o")
# uncomment to build libc only
RECURSIVE_FIND_FILE(NEWLIB_SRC "${NEWLIB_LIB}/libc" "*.o")

# omit mallocr and realloc because codal has its own allocator
list(
    REMOVE_ITEM 
    NEWLIB_SRC
    "${NEWLIB_LIB}/libc/stdlib/96a2987@@stdlibthumb_v7_m@sta/mallocr.c.o"
    "${NEWLIB_LIB}/libc/stdlib/96a2987@@stdlibthumb_v7_m@sta/realloc.c.o"
    "${NEWLIB_LIB}/libc/stdlib/96a2987@@stdlibthumb_v7_m@sta/reallocf.c.o"
)

set(
    TOP_LEVEL_SOURCE_FILES
    "${NEWLIB_DIR}/scripts/dummy.c"
    ${NEWLIB_SRC}
)

# create newlib target.
add_library(newlib ${TOP_LEVEL_SOURCE_FILES})
message("TOP_LEVEL_SOURCE_FILES: ${TOP_LEVEL_SOURCE_FILES}")

###############################################################################
# global settings

string(TOLOWER "${CODAL_TARGET_PROCESSOR}" TARGET_PROCESSOR)

# include directories
include_directories(    
    ${INCLUDE_DIRS} 
    ${TOP_LEVEL_INCLUDE_DIRS}
    ${LIB_DIR}
)

# expose it to parent cmake.
# target_include_directories(newlib PUBLIC "${NEWLIB_DIR}/include")

# exclude standard C includes
# set(
#     CMAKE_C_FLAGS 
#     "${CMAKE_C_FLAGS} -zzznostdinc -H -dI -DPREFER_SIZE_OVER_SPEED -D_LDBL_EQ_DBL"
# )

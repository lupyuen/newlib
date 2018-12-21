set(CMAKE_VERBOSE_MAKEFILE ON)
project(newlib)
include("${CODAL_UTILS_LOCATION}")

# CMAKE_CURRENT_SOURCE_DIR is codal/libraries/newlib

###############################################################################
# newlib

set(NEWLIB_DIR             "${CMAKE_CURRENT_SOURCE_DIR}")
set(NEWLIB_CTYPE_DIR       "${NEWLIB_DIR}/newlib/libc/ctype")
set(NEWLIB_STRING_DIR      "${NEWLIB_DIR}/newlib/libc/string")
set(NEWLIB_LIBM_COMMON_DIR "${NEWLIB_DIR}/newlib/libm/common")
set(NEWLIB_LIBM_MATH_DIR   "${NEWLIB_DIR}/newlib/libm/math")
message("NEWLIB_DIR: ${NEWLIB_DIR}")

# find newlib sources and headers.
set(
    TOP_LEVEL_INCLUDE_DIRS
    "${NEWLIB_DIR}/include"
    "${NEWLIB_DIR}/newlib/libc/include"
    "${NEWLIB_CTYPE_DIR}"
    "${NEWLIB_LIBM_COMMON_DIR}"
)
RECURSIVE_FIND_FILE(NEWLIB_LIBM_COMMON "${NEWLIB_LIBM_COMMON_DIR}" "*.c")
RECURSIVE_FIND_FILE(NEWLIB_LIBM_MATH   "${NEWLIB_LIBM_MATH_DIR}"   "*.c")

set(
    NEWLIB_CTYPE
    "${NEWLIB_CTYPE_DIR}/ctype_.c"
    "${NEWLIB_CTYPE_DIR}/isalnum.c"
    "${NEWLIB_CTYPE_DIR}/isalpha.c"
    "${NEWLIB_CTYPE_DIR}/iscntrl.c"
    "${NEWLIB_CTYPE_DIR}/isdigit.c"
    "${NEWLIB_CTYPE_DIR}/islower.c"
    "${NEWLIB_CTYPE_DIR}/isupper.c"
    "${NEWLIB_CTYPE_DIR}/isprint.c"
    "${NEWLIB_CTYPE_DIR}/ispunct.c"
    "${NEWLIB_CTYPE_DIR}/isspace.c"
    "${NEWLIB_CTYPE_DIR}/isxdigit.c"
    "${NEWLIB_CTYPE_DIR}/tolower.c"
    "${NEWLIB_CTYPE_DIR}/toupper.c"
)

set(
    NEWLIB_STRING
    "${NEWLIB_STRING_DIR}/bcopy.c"
    "${NEWLIB_STRING_DIR}/bzero.c"
    "${NEWLIB_STRING_DIR}/explicit_bzero.c"
    "${NEWLIB_STRING_DIR}/ffsl.c"
    "${NEWLIB_STRING_DIR}/ffsll.c"
    "${NEWLIB_STRING_DIR}/fls.c"
    "${NEWLIB_STRING_DIR}/flsl.c"
    "${NEWLIB_STRING_DIR}/flsll.c"
    "${NEWLIB_STRING_DIR}/index.c"
    "${NEWLIB_STRING_DIR}/memchr.c"
    "${NEWLIB_STRING_DIR}/memcmp.c"
    "${NEWLIB_STRING_DIR}/memcpy.c"
    "${NEWLIB_STRING_DIR}/memmove.c"
    "${NEWLIB_STRING_DIR}/memset.c"
    "${NEWLIB_STRING_DIR}/rindex.c"
    "${NEWLIB_STRING_DIR}/strcasecmp.c"
    "${NEWLIB_STRING_DIR}/strcat.c"
    "${NEWLIB_STRING_DIR}/strchr.c"
    "${NEWLIB_STRING_DIR}/strcmp.c"
    "${NEWLIB_STRING_DIR}/strcoll.c"
    "${NEWLIB_STRING_DIR}/strcpy.c"
    "${NEWLIB_STRING_DIR}/strcspn.c"
    "${NEWLIB_STRING_DIR}/strdup.c"
    "${NEWLIB_STRING_DIR}/strdup_r.c"
    #"${NEWLIB_STRING_DIR}/strerror.c"
    "${NEWLIB_STRING_DIR}/strerror_r.c"
    "${NEWLIB_STRING_DIR}/strlcat.c"
    "${NEWLIB_STRING_DIR}/strlcpy.c"
    "${NEWLIB_STRING_DIR}/strlen.c"
    "${NEWLIB_STRING_DIR}/strlwr.c"
    "${NEWLIB_STRING_DIR}/strncasecmp.c"
    "${NEWLIB_STRING_DIR}/strncat.c"
    "${NEWLIB_STRING_DIR}/strncmp.c"
    "${NEWLIB_STRING_DIR}/strncpy.c"
    "${NEWLIB_STRING_DIR}/strnlen.c"
    "${NEWLIB_STRING_DIR}/strnstr.c"
    "${NEWLIB_STRING_DIR}/strpbrk.c"
    "${NEWLIB_STRING_DIR}/strrchr.c"
    "${NEWLIB_STRING_DIR}/strsep.c"
    "${NEWLIB_STRING_DIR}/strsignal.c"
    "${NEWLIB_STRING_DIR}/strspn.c"
    "${NEWLIB_STRING_DIR}/strtok.c"
    "${NEWLIB_STRING_DIR}/strtok_r.c"
    "${NEWLIB_STRING_DIR}/strupr.c"
    "${NEWLIB_STRING_DIR}/strxfrm.c"
    "${NEWLIB_STRING_DIR}/strstr.c"
    "${NEWLIB_STRING_DIR}/swab.c"
    "${NEWLIB_STRING_DIR}/timingsafe_bcmp.c"
    "${NEWLIB_STRING_DIR}/timingsafe_memcmp.c"
)

set(
    TOP_LEVEL_SOURCE_FILES
    ${NEWLIB_CTYPE}
    ${NEWLIB_STRING}
    ${NEWLIB_LIBM_COMMON}
    ${NEWLIB_LIBM_MATH}
)

# create newlib target.
add_library(newlib ${TOP_LEVEL_SOURCE_FILES})
# message("TOP_LEVEL_SOURCE_FILES: ${TOP_LEVEL_SOURCE_FILES}")

###############################################################################
# global settings

string(TOLOWER "${CODAL_TARGET_PROCESSOR}" TARGET_PROCESSOR)

# exclude standard C includes
set(
    CMAKE_C_FLAGS 
    "${CMAKE_C_FLAGS} -zzznostdinc -H -dI -DPREFER_SIZE_OVER_SPEED -D_LDBL_EQ_DBL"
)

# include directories
include_directories(    
    ${INCLUDE_DIRS} 
    ${TOP_LEVEL_INCLUDE_DIRS}
    ${LIB_DIR}
    # TODO
    "/usr/local/Cellar/arm-none-eabi-gcc/7-2018-q2-update/gcc/arm-none-eabi/include"
    "/usr/local/Cellar/arm-none-eabi-gcc/7-2018-q2-update/gcc/lib/gcc/arm-none-eabi/7.3.1/include"
    "/usr/local/Cellar/arm-none-eabi-gcc/7-2018-q2-update/gcc/lib/gcc/arm-none-eabi/7.3.1/include-fixed/"
)

# expose it to parent cmake.
# target_include_directories(newlib PUBLIC "${NEWLIB_DIR}/include")

# **********************************************************
# Copyright (c) 2014-2018 A.H.L    All rights reserved.
# **********************************************************



# Prevent critical variables from changing after the initial configuration
if (CMAKE_CROSSCOMPILING)
    set (SAVED_RPI_SYSROOT ${RPI_SYSROOT} CACHE INTERNAL "Initial value for RPI_SYSROOT")
    set (SAVED_RPI_PREFIX ${RPI_PREFIX} CACHE INTERNAL "Initial value for RPI_PREFIX")
    # Save the initial values of CC and CXX environment variables
    set (SAVED_CC $ENV{CC} CACHE INTERNAL "Initial value for CC")
    set (SAVED_CXX $ENV{CXX} CACHE INTERNAL "Initial value for CXX")
    return ()
elseif ((SAVED_RPI_SYSROOT AND NOT SAVED_RPI_SYSROOT STREQUAL RPI_SYSROOT) OR (SAVED_RPI_PREFIX AND NOT SAVED_RPI_PREFIX STREQUAL RPI_PREFIX))
    set (RPI_SYSROOT ${SAVED_RPI_SYSROOT} CACHE PATH "Path to Raspberry Pi system root (RPI cross-compiling build only)" FORCE)
    set (RPI_PREFIX ${SAVED_RPI_PREFIX} CACHE STRING "Prefix path to Raspberry Pi cross-compiler tools (RPI cross-compiling build only)" FORCE)
    message (FATAL_ERROR "RPI_SYSROOT and RPI_PREFIX cannot be changed after the initial configuration/generation. "
            "If you wish to change that then the build tree would have to be regenerated from scratch. Auto reverting to its initial value.")
endif()

# Reference toolchain variable to suppress "unused variable" warning
if (CMAKE_TOOLCHAIN_FILE)
    mark_as_advanced (CMAKE_TOOLCHAIN_FILE)
endif()

set (CMAKE_SYSTEM_NAME Linux)
set (CMAKE_SYSTEM_PROCESSOR aarch64)
set (CMAKE_SYSTEM_VERSION 3)
set (TARGET_ABI "linux-gnu")
SET(CROSS_ROOTFS "/home/rootfs")

set (RPI_SYSROOT ${RPI_SYSROOT} CACHE PATH "Path to Raspberry Pi system root (RPI cross-compiling build only)")
if (NOT EXISTS ${RPI_SYSROOT})
    message (FATAL_ERROR "Could not find Raspberry Pi system root. "
            "Use RPI_SYSROOT environment variable or build option to specify the location of system root.")
endif(NOT EXISTS ${RPI_SYSROOT})

set (CMAKE_SYSROOT ${RPI_SYSROOT})

# where is the target environment
set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install)

set(CMAKE_FIND_ROOT_PATH "${CROSS_ROOTFS}")


# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)

# for libraries and headers in the target directories
# Only search libraries and headers in sysroot
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(TRIPLE arm-linux-gnueabihf)

SET(CMAKE_C_COMPILER   aarch64-${TARGET_ABI}-gcc)
SET(CMAKE_CXX_COMPILER aarch64-${TARGET_ABI}-g++)

find_program(GCC_FULL_PATH aarch64-${TARGET_ABI}-gcc)
if (NOT GCC_FULL_PATH)
  message(FATAL_ERROR "Cross-compiler aarch64-${TARGET_ABI}-gcc not found")
endif ()

get_filename_component(GCC_DIR ${GCC_FULL_PATH} PATH)
SET (CMAKE_LINKER       ${GCC_DIR}/aarch64-${TARGET_ABI}-ld        CACHE FILEPATH "linker")
SET (CMAKE_ASM_COMPILER ${GCC_DIR}/aarch64-${TARGET_ABI}-as        CACHE FILEPATH "assembler")
SET (CMAKE_OBJCOPY      ${GCC_DIR}/aarch64-${TARGET_ABI}-objcopy   CACHE FILEPATH "objcopy")
SET (CMAKE_STRIP        ${GCC_DIR}/aarch64-${TARGET_ABI}-strip     CACHE FILEPATH "strip")
SET (CMAKE_CPP          ${GCC_DIR}/aarch64-${TARGET_ABI}-cpp       CACHE FILEPATH "cpp")
set (CMAKE_AR           ${GCC_DIR}/aarch64-${TARGET_ABI}-ar        CACHE PATH "archive")
set (CMAKE_NM           ${GCC_DIR}/aarch64-${TARGET_ABI}-nm        CACHE PATH "nm")
set (CMAKE_OBJDUMP      ${GCC_DIR}/aarch64-${TARGET_ABI}-objdump   CACHE PATH "objdump")
set (CMAKE_RANLIB       ${GCC_DIR}/aarch64-${TARGET_ABI}-ranlib    CACHE PATH "ranlib")

add_compile_options(-target armv7-linux-gnueabihf)
add_compile_options(-mthumb)
add_compile_options(-mfpu=vfpv3)
add_compile_options(--sysroot=${CROSS_ROOTFS})

set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} -target ${TOOLCHAIN}")
set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} -B ${CROSS_ROOTFS}/usr/lib/gcc/${TOOLCHAIN}")
set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} -L${CROSS_ROOTFS}/lib/${TOOLCHAIN}")
set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} --sysroot=${CROSS_ROOTFS}")
# CFLAGS="${CFLAGS} -O3 -march=armv8-a+crc -mtune=cortex-a53 -mcpu=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard -funsafe-math-optimizations"
# LDFLAGS="${LDFLAGS} -O3 -march=armv8-a+crc -mtune=cortex-a53 -mcpu=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard -funsafe-math-optimizations"

set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    ${CROSS_LINK_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${CROSS_LINK_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${CROSS_LINK_FLAGS}" CACHE STRING "" FORCE)

# add extra directories to the system library search path
LIST(APPEND CMAKE_SYSTEM_LIBRARY_PATH "/usr/lib/arm-linux-gnueabihf")

# add the extra directories to the linker search path
SET(LINKER_FLAGS "-Wl,-dynamic-linker,/lib/ld-linux-armhf.so.3 -Wl,-rpath-link,
    ${CMAKE_FIND_ROOT_PATH}/usr/lib:${CMAKE_FIND_ROOT_PATH}/lib:
    ${CMAKE_FIND_ROOT_PATH}/lib/arm-linux-gnueabihf:${CMAKE_FIND_ROOT_PATH}/usr/lib/arm-linux-gnueabihf"
)

SET(CMAKE_EXE_LINKER_FLAGS "${LINKER_FLAGS}" CACHE STRING "linker flags" FORCE)


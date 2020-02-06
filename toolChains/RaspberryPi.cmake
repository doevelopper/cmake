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

# for libraries and headers in the target directories
# Only search libraries and headers in sysroot
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
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
SET (CMAKE_OBJCOPY      ${GCC_DIR}/aarch64-${TARGET_ABI}-objcopy   CACHE FILEPATH "objcopy: copy and translate object files.")
SET (CMAKE_STRIP        ${GCC_DIR}/aarch64-${TARGET_ABI}-strip     CACHE FILEPATH "strip")
SET (CMAKE_CPP          ${GCC_DIR}/aarch64-${TARGET_ABI}-cpp       CACHE FILEPATH "cpp")
set (CMAKE_AR           ${GCC_DIR}/aarch64-${TARGET_ABI}-ar        CACHE PATH "archive: create, modify, and extract from archives.")
set (CMAKE_NM           ${GCC_DIR}/aarch64-${TARGET_ABI}-nm        CACHE PATH "nm: list symbols from object files.")
set (CMAKE_OBJDUMP      ${GCC_DIR}/aarch64-${TARGET_ABI}-objdump   CACHE PATH "objdump: display information from object files.")
set (CMAKE_RANLIB       ${GCC_DIR}/aarch64-${TARGET_ABI}-ranlib    CACHE PATH "ranlib:  generate index to archive.")
set (CMAKE_READELF      ${GCC_DIR}/aarch64-${TARGET_ABI}-readelf   CACHE PATH "readelf:  Displays information about ELF files.")
set (CMAKE_SIZE         ${GCC_DIR}/aarch64-${TARGET_ABI}-size      CACHE PATH "size: List Section Size and Toal Size.")
set (CMAKE_addr2line    ${GCC_DIR}/aarch64-${TARGET_ABI}-addr2line CACHE PATH "addr2line: Convert Address to Filename and Numbers")
set (CMAKE_c++filt      ${GCC_DIR}/aarch64-${TARGET_ABI}-c++filt   CACHE PATH "c++filt: Demangle Command")
set (CMAKE_strings      ${GCC_DIR}/aarch64-${TARGET_ABI}-strings   CACHE PATH "strings: Display Printable Characters from a File")

add_compile_options(-target armv7-linux-gnueabihf)
add_compile_options(-mthumb)
add_compile_options(-mfpu=vfpv3)
add_compile_options(--sysroot=${CROSS_ROOTFS})

set (TOOLCHAIN aarch64-linux-gnu)

set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} -target ${TOOLCHAIN}")
set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} -B ${CROSS_ROOTFS}/usr/lib/gcc/${TOOLCHAIN}")
set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} -L${CROSS_ROOTFS}/lib/${TOOLCHAIN}")
set(CROSS_LINK_FLAGS "${CROSS_LINK_FLAGS} --sysroot=${CROSS_ROOTFS}")
# CFLAGS="${CFLAGS} -O3 -march=armv8-a+crc -mtune=cortex-a53 -mcpu=cortex-a53
#         -mfpu=neon-fp-armv8 -mfloat-abi=hard -funsafe-math-optimizations"
# LDFLAGS="${LDFLAGS} -O3 -march=armv8-a+crc -mtune=cortex-a53 -mcpu=cortex-a53
#         -mfpu=neon-fp-armv8 -mfloat-abi=hard -funsafe-math-optimizations"

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


set(CMAKE_CXX_COMPILER_TARGET_FORCED TRUE)
set(CMAKE_C_COMPILER_TARGET_FORCED TRUE)
set(CMAKE_C_COMPILER_TARGET aarch64)
set(CMAKE_CXX_COMPILER_TARGET aarch64)
add_definitions(-D__AARCH64_GNU__)
set(CMAKE_LINKER /usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-ld)

# #Where is the target environment
# SET(CMAKE_FIND_ROOT_PATH $ENV{HOME}/rpi/rootfs)
# SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --sysroot=${CMAKE_FIND_ROOT_PATH}")
# SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} --sysroot=${CMAKE_FIND_ROOT_PATH}")
# SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} --sysroot=${CMAKE_FIND_ROOT_PATH}")
# INCLUDE_DIRECTORIES($ENV{HOME}/rpi/rootfs/opt/vc/include)
# INCLUDE_DIRECTORIES($ENV{HOME}/rpi/rootfs/opt/vc/include/interface/vcos/pthreads)
# INCLUDE_DIRECTORIES($ENV{HOME}/rpi/rootfs/opt/vc/include/interface/vmcs_host/linux)


# Make sure the correct compiler is used
set(CMAKE_C_COMPILER ${CROSS_COMPILER_ROOT}/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_COMPILER_ROOT}/bin/arm-linux-gnueabihf-g++)
SET(CMAKE_C_FLAGS "-march=armv6 -mfpu=vfp -mfloat-abi=hard")
SET(CMAKE_CXX_FLAGS "-march=armv6 -mfpu=vfp -mfloat-abi=hard")
# Set search parmas for cmake find...
set(CMAKE_FIND_ROOT_PATH ${CROSS_COMPILER_ROOT})
# Search for programs only in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Search for libraries and headers only in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# force compiler flags at startup so we don't forget them
set(CMAKE_CXX_FLAGS "-std=c++14 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" CACHE STRING "C++ flags" FORCE)
set(CMAKE_C_FLAGS "-mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" CACHE STRING "C flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath-link,${CROSS_COMPILER_ROOT}/arm-linux-gnueabihf/libc/lib/arm-linux-gnueabihf" CACHE STRING "Linker flags" FORCE)
set(LINKER_FLAGS "-Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now,-lc -pthread -lpthread -ldl")
# help cmake use the right thread library
set(DCMAKE_THREAD_LIBS_INIT ${CROSS_COMPILER_ROOT}/arm-linux-gnueabihf/libc/lib/arm-linux-gnueabihf/libpthread.so.0)
set(CMAKE_SYSTEM_PREFIX_PATH "/usr/aarch64-linux-gnu")


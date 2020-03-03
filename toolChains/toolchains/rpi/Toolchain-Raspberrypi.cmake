# CMake Toolchain File

# Assumes that the CROSS_COMPILER_ROOT env var is set in accordance with the above terminal settings

# Use a variable to make maintenance easier
set(CROSS_COMPILER_ROOT $ENV{CROSS_COMPILER_ROOT})

# Default system settings
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR arm)

# #Specify the cross compiler
# SET(CMAKE_C_COMPILER $ENV{HOME}/rpi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-gcc)
# SET(CMAKE_CXX_COMPILER $ENV{HOME}/rpi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-g++)

set (CMAKE_C_COMPILER   ${RPI_PREFIX}-gcc     CACHE PATH    "C compiler")
set (CMAKE_CXX_COMPILER ${RPI_PREFIX}-c++     CACHE PATH    "C++ compiler")
set (CMAKE_STRIP        ${RPI_PREFIX}-strip   CACHE PATH    "strip")
set (CMAKE_AR           ${RPI_PREFIX}-ar      CACHE PATH    "archive")
set (CMAKE_LINKER       ${RPI_PREFIX}-ld      CACHE PATH    "linker")
set (CMAKE_NM           ${RPI_PREFIX}-nm      CACHE PATH    "nm")
set (CMAKE_OBJCOPY      ${RPI_PREFIX}-objcopy CACHE PATH    "objcopy")
set (CMAKE_OBJDUMP      ${RPI_PREFIX}-objdump CACHE PATH    "objdump")
set (CMAKE_RANLIB       ${RPI_PREFIX}-ranlib  CACHE PATH    "ranlib")

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

# help cmake use the right thread library
set(DCMAKE_THREAD_LIBS_INIT ${CROSS_COMPILER_ROOT}/arm-linux-gnueabihf/libc/lib/arm-linux-gnueabihf/libpthread.so.0)

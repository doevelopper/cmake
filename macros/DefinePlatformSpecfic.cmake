#       src/main/resources/config/macros/DefinePlatformSpecfic.cmake
#
#               Copyright (c) 2014-2018  A.H.L
#
#        Permission is hereby granted, free of charge, to any person obtaining
#        a copy of this software and associated documentation files (the
#        "Software"), to deal in the Software without restriction, including
#        without limitation the rights to use, copy, modify, merge, publish,
#        distribute, sublicense, and/or sell copies of the Software, and to
#        permit persons to whom the Software is furnished to do so, subject to
#        the following conditions:
#
#        The above copyright notice and this permission notice shall be
#        included in all copies or substantial portions of the Software.
#
#        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#        EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#        NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#        LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#        OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#        WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to 'Debug' as none was specified.")
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release" "MinSizeRel" "RelWithDebInfo" "Coverage" "Profiling"
    )
endif()

#if (CMAKE_BUILD_TYPE AND NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release|RelWithDebInfo|Coverage|Profiling)$")
#	message(FATAL_ERROR "Invalid value for CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
#endif()

#set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo;Coverage;Profiling" CACHE STRING "" FORCE )


#foreach(config DEBUG RELEASE RELWITHDEBINFO MINSIZEREL COVERAGE PROFILING )
#     foreach(var CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${config} CMAKE_LIBRARY_OUTPUT_DIRECTORY_${config} CMAKE_RUNTIME_OUTPUT_DIRECTORY_${config})
#         set(${var} "${TARGET_BUILD_DIRECTORY}-${config}")
#         string(TOLOWER "${${var}}" ${var})
##         file(MAKE_DIRECTORY ${var})
#     endforeach()
# endforeach()

cmake_host_system_information(RESULT HOST_LOGICAL_CORE_NO QUERY NUMBER_OF_LOGICAL_CORES)
cmake_host_system_information(RESULT HOST_PHYSICAL_CORE_NO QUERY NUMBER_OF_PHYSICAL_CORES)
cmake_host_system_information(RESULT HOST_PHYSICAL_MEMORY QUERY TOTAL_PHYSICAL_MEMORY)


set(AOL "${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}_GCC_${CMAKE_CXX_COMPILER_VERSION}")
#set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_COLOR_MAKEFILE ON)
set(CMAKE_RULE_MESSAGES ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)
set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)
#set(CMAKE_LINK_DEPENDS_NO_SHARED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(BUILD_SHARED_LIBS)
    set(CMAKE_DEBUG_POSTFIX             "${STATIC_POSTFIX}.d"   CACHE STRING "Set Debug library postfix" FORCE)
    set(CMAKE_RELEASE_POSTFIX           "${STATIC_POSTFIX}"     CACHE STRING "Set Release library postfix" FORCE)
    set(CMAKE_MINSIZEREL_POSTFIX        "${STATIC_POSTFIX}"     CACHE STRING "Set MinSizeRel library postfix" FORCE)
    set(CMAKE_RELWITHDEBINFO_POSTFIX    "${STATIC_POSTFIX}"     CACHE STRING "Set RelWithDebInfo library postfix" FORCE)
    set(CMAKE_FIND_LIBRARY_SUFFIXES     "${STATIC_POSTFIX}.so"  CACHE STRING "Set find library suffix" FORCE)
    set(CMAKE_FIND_LIBRARY_PREFIXES     "${STATIC_POSTFIX}lib"  CACHE STRING "Set find library prefix" FORCE)
else(BUILD_SHARED_LIBS)
    set(CMAKE_DEBUG_POSTFIX             ".d"         CACHE STRING "Set Debug library postfix" FORCE)
    set(CMAKE_RELEASE_POSTFIX           ""           CACHE STRING "Set Release library postfix" FORCE)
    set(CMAKE_MINSIZEREL_POSTFIX        ""           CACHE STRING "Set MinSizeRel library postfix" FORCE)
    set(CMAKE_RELWITHDEBINFO_POSTFIX    ".r.d"       CACHE STRING "Set RelWithDebInfo library postfix" FORCE)
    set(CMAKE_COVERAGE_POSTFIX          ".cov"       CACHE STRING "Set Coverage library postfix" FORCE)
    set(CMAKE_COVERAGE_POSTFIX          ".prof"      CACHE STRING "Set profile library postfix" FORCE)
    set(CMAKE_FIND_LIBRARY_SUFFIXES     ".a"         CACHE STRING "Set find library suffixe" FORCE)
    set(CMAKE_FIND_LIBRARY_PREFIXES     "lib"        CACHE STRING  "Set find library prefix" FORCE)
endif(BUILD_SHARED_LIBS)

#-----------------------------------------------------------------------------
# Output directories
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/${AOL}-${CMAKE_BUILD_TYPE})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib CACHE PATH "Output directory for static libraries")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib CACHE PATH "Output directory for shared libraries")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/bin CACHE PATH "Output directory for runtime binaries")

include(GNUInstallDirs)
set(CMAKE_INSTALL_SYSCONFDIR "${CMAKE_INSTALL_PREFIX}/etc")
set(CMAKE_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_PREFIX}/include")
set(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/lib")
set(CMAKE_INSTALL_BINDIR "${CMAKE_INSTALL_PREFIX}/bin")

#include(CheckIncludeFile)
#include(CheckIncludeFiles)
#include(CMakePackageConfigHelpers)

#check_include_files(sys/time.h HAVE_SYS_TIME_H)
#check_include_file(inttypes.h HAVE_INTTYPES_H)
#check_include_file(stdint.h HAVE_STDINT_H)
#check_include_file(stddef.h HAVE_STDDEF_H)
#check_include_file(stdlib.h HAVE_STDLIB_H)
#check_include_file(strings.h HAVE_STRINGS_H)
#check_include_file(string.h HAVE_STRING_H)
#check_include_file(sys/stat.h HAVE_SYS_STAT_H)
#check_include_file(sys/types.h HAVE_SYS_TYPES_H)
#check_include_file(ctype.h HAVE_CTYPE_H)
#check_include_file(memory.h HAVE_MEMORY_H)
#check_include_file(unistd.h HAVE_UNISTD_H)
#check_include_file(dlfcn.h HAVE_DLFCN_H)
#check_include_file(windows.h HAVE_WINDOWS_H)
#check_include_files("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)
#check_include_files("assert.h;ctype.h;errno.h;float.h;limits.h;locale.h;math.h;setjmp.h;signal.h;stdarg.h;stddef.h;stdio.h;stdlib.h;string.h;time.h" STDC_HEADERS)


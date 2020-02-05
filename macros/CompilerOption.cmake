#        src/main/resources/config/macros/CompilerOption.cmake
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

include(CMakeParseArguments)
include(CheckCXXCompilerFlag)

set (GNU_CXX_FLAGS -Wlogical-op  -Wstrict-null-sentinel)
set (CLANG_CXX_FLAGS )

set (COMMON_CXX_FLAGS -W -Wall -Wextra -Weffc++ -Wpedantic  -Woverloaded-virtual -Wstack-protector)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wconversion -Wsign-conversion -Wmisleading-indentation -Wduplicated-cond)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wnoexcept -Winit-self  -Wmissing-declarations -ftemplate-backtrace-limit=0)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wnull-dereference -Wuseless-cast -Wdouble-promotion -Wfloat-equal)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wcomment -Wimport  -Wchar-subscripts -Wswitch-default -Wdisabled-optimization)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wcast-qual  -Wold-style-cast -Wcast-align  -Wctor-dtor-privacy  )
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wredundant-decls -Wvariadic-macros -Wwrite-strings) #-Wmissing-include-dirs
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wlong-long -Wmissing-braces -Wreturn-type -Wsequence-point -Wsign-compare)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wmissing-format-attribute -Wpacked -Wparentheses -Wpointer-arith)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wunused-variable  -Wunused-parameter -Wunused-value -Wuninitialized)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wzero-as-null-pointer-constant  -Wduplicated-branches  -Wvolatile-register-var)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Wformat=2 -Wfloat-equal  -Wformat -Wformat-nonliteral -Wsign-promo )

set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Werror=reorder -Werror=non-virtual-dtor -fmax-errors=5 -Werror=return-type )
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -pedantic-errors -Werror=switch-default -Werror=unused-result)
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Werror=aggressive-loop-optimizations ) #-Werror=implicit-function-declaration )
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Werror=missing-field-initializers ) #-Werror=conversion )
set (COMMON_CXX_FLAGS ${COMMON_CXX_FLAGS} -Werror=format-security -Werror=shadow -Werror=address -Werror=sequence-point)

set (CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS} -O0 -g -D_DEBUG -D_FORTIFY_SOURCE=2 -fno-strict-aliasing -fno-omit-frame-pointer")
set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} O4 -DNDEBUG")
set (CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -O2 -g")
set (CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS} -Os -DNDEBUG")

set (CHECK_MEMORY_FLAGS  "-fsanitize=memory -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer")
set (CHECK_MEMORY_FLAGS  "${CHECK_MEMORY_FLAGS} -fsanitize=null -fsanitize=unreachable -fstack-check
-fvtable-verify=std")
set (CHECK_ADDRESS_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
set (CHECK_THREAD_FLAGS  "-fsanitize=thread")
set (CHECK_UNDEFINED_FLAGS "-fsanitize=undefined-trap -fsanitize-undefined-trap-on-error -fno-sanitize-recover")
set (CHECK_DATAFLOW_FLAGS "-fsanitize=dataflow")
set (CPP_COVERAGE_FLAGS "--coverage -fprofile-arcs -ftest-coverage")

#"Debug" "Release" "MinSizeRel" "RelWithDebInfo" "Coverage" "Profiling"

set ( CMAKE_CXX_FLAGS_PROFILE "-pg -O3 -DNDEBUG" CACHE STRING
    "Flags used by the C++ compiler during profile builds." FORCE
)

set ( CMAKE_C_FLAGS_PROFILE "-pg -O3 -DNDEBUG" CACHE STRING
    "Flags used by the C compiler during profile builds." FORCE
)

set ( CMAKE_EXE_LINKER_FLAGS_PROFILE "-pg" CACHE STRING
    "Flags used for linking binaries during profile builds." FORCE
)

set ( CMAKE_MODULE_LINKER_FLAGS_PROFILE "-pg" CACHE STRING
    "Flags used for linking binaries during profile builds." FORCE
)

set ( CMAKE_SHARED_LINKER_FLAGS_PROFILE "-pg" CACHE STRING
    "Flags used by the shared libraries linker during profile builds." FORCE
)

  set ( CMAKE_CXX_FLAGS_COVERAGE "--coverage -O3 -DNDEBUG" CACHE STRING
    "Flags used by the C++ compiler during coverage builds." FORCE
)

set ( CMAKE_C_FLAGS_COVERAGE "--coverage -O3 -DNDEBUG" CACHE STRING
    "Flags used by the C compiler during coverage builds." FORCE
)

set ( CMAKE_EXE_LINKER_FLAGS_COVERAGE "--coverage" CACHE STRING
    "Flags used for linking binaries during coverage builds." FORCE
)

set ( CMAKE_MODULE_LINKER_FLAGS_COVERAGE "--coverage" CACHE STRING
   "Flags used for linking binaries during coverage builds."  FORCE
)

set ( CMAKE_SHARED_LINKER_FLAGS_COVERAGE "--coverage" CACHE STRING
    "Flags used by the shared libraries linker during coverage builds." FORCE
)

MARK_AS_ADVANCED(
    CMAKE_CXX_FLAGS_PROFILE
    CMAKE_C_FLAGS_PROFILE
    CMAKE_EXE_LINKER_FLAGS_PROFILE
    CMAKE_MODULE_LINKER_FLAGS_PROFILE
    CMAKE_SHARED_LINKER_FLAGS_PROFILE
    CMAKE_CXX_FLAGS_COVERAGE
    CMAKE_C_FLAGS_COVERAGE
    CMAKE_EXE_LINKER_FLAGS_COVERAGE
    CMAKE_MODULE_LINKER_FLAGS_COVERAGE
	CMAKE_SHARED_LINKER_FLAGS_COVERAGE
	CMAKE_STATIC_LINKER_FLAGS_COVERAGE
)

find_program(APR_CONFIG_EXECUTABLE apr-1-config
    HINTS
        ${CMAKE_INSTALL_PREFIX}/bin 
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        /usr/local/apr/bin
        /usr/lib/x86_64-linux-gnu
)

mark_as_advanced(APR_CONFIG_EXECUTABLE)

macro(_apr_invoke _varname _regexp)
    execute_process(
            COMMAND ${APR_CONFIG_EXECUTABLE} ${ARGN}
            OUTPUT_VARIABLE _apr_output
            RESULT_VARIABLE _apr_failed
    )

    if(_apr_failed)
         message(FATAL_ERROR "${APR_CONFIG_EXECUTABLE} ${ARGN} failed")
    else()
         string(REGEX REPLACE "[\r\n]"  "" _apr_output "${_apr_output}")
         string(REGEX REPLACE " +$"     "" _apr_output "${_apr_output}")

         if(NOT ${_regexp} STREQUAL "")
             string(REGEX REPLACE "${_regexp}" " " _apr_output "${_apr_output}")
         endif()
         # XXX: We don't want to invoke separate_arguments() for APR_CFLAGS;
         # just leave as-is
         if(NOT ${_varname} STREQUAL "APR_CFLAGS")
             separate_arguments(_apr_output)
         endif()

         set(${_varname} "${_apr_output}")
    endif()
endmacro(_apr_invoke)

_apr_invoke(APR_CFLAGS    ""        --cppflags --cflags)
_apr_invoke(APR_INCLUDES  "(^| )-I" --includes)
_apr_invoke(APR_LIBS      ""        --link-ld)
_apr_invoke(APR_EXTRALIBS "(^| )-l" --libs)
_apr_invoke(APR_VERSION   ""        --version)

#message(STATUS "APR_CFLAGS      ${APR_CFLAGS}")
#message(STATUS "APR_INCLUDES    ${APR_INCLUDES}")
#message(STATUS "APR_LIBS        ${APR_LIBS}")
#message(STATUS "APR_EXTRALIBS   ${APR_EXTRALIBS}")
#message(STATUS "APR_VERSION     ${APR_VERSION}")

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(APR DEFAULT_MSG APR_INCLUDES APR_LIBS APR_VERSION)

# Bova hqs q hard coded link to build direstorir where includes qnd libs qre buolded
find_path(APR_INCLUDE_DIR apr-1/apr.h
    HINTS 
        ${CMAKE_INSTALL_PREFIX}/include
        ${CMAKE_INSTALL_INCLUDEDIR}
        /usr/local/apr/include
        /usr/include/apr-1.0/
)

find_library(APR_LIBRARY 
    NAMES libapr-1.a apr-1.a
    HINTS
        ${CMAKE_INSTALL_PREFIX}/lib 
        ${CMAKE_INSTALL_LIBDIR}
        ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        /usr/local/apr/lib 
        /usr/lib/apr
)

if (APR_LIBRARY AND APR_INCLUDE_DIR)
    set(APR_LIBRARIES ${APR_LIBRARY})
    set(APR_FOUND "YES")
else (APR_LIBRARY AND APR_INCLUDE_DIR)
    set(APR_FOUND "NO")
endif (APR_LIBRARY AND APR_INCLUDE_DIR)

#message(STATUS "APR_INCLUDE_DIR ${APR_INCLUDE_DIR}")
#message(STATUS "APR_VERSION  ${APR_VERSION}")
#message(STATUS "APR_LIBRARY ${APR_LIBRARY}")

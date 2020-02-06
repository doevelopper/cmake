#       levitics-arkhe-gcs/src/main/resources/config/modules/FindGoogleTestFwk.cmake
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


find_path(GMOCK_INCLUDE_DIR gmock/gmock.h
    HINTS ${CMAKE_INSTALL_INCLUDEDIR}
)

find_path(GTEST_INCLUDE_DIR gtest/gtest.h
    HINTS ${CMAKE_INSTALL_INCLUDEDIR}
)

mark_as_advanced(GMOCK_INCLUDE_DIR  GTEST_INCLUDE_DIR)

find_library(GMOCK_LIBRARY NAMES gmock gmockd
    HINTS ${CMAKE_INSTALL_LIBDIR}
)

find_library(GMOCK_MAIN_LIBRARY NAMES gmock_main gmock_maind
    HINTS ${CMAKE_INSTALL_LIBDIR}
)

find_library(GTEST_LIBRARY NAMES gtest gtestd
    HINTS ${CMAKE_INSTALL_LIBDIR}
)
 
find_library(GTEST_MAIN_LIBRARY NAMES gtest_main gtest_maind
    HINTS ${CMAKE_INSTALL_LIBDIR}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMock DEFAULT_MSG GMOCK_LIBRARY GMOCK_INCLUDE_DIR GMOCK_MAIN_LIBRARY)
find_package_handle_standard_args(GTest DEFAULT_MSG GTEST_LIBRARY GTEST_INCLUDE_DIR GTEST_MAIN_LIBRARY)

#message( STATUS "GMOCK_LIBRARY ${GMOCK_LIBRARY}")
#message( STATUS "GTEST_LIBRARY ${GTEST_LIBRARY}")
#message( STATUS "GMOCK_MAIN_LIBRARY ${GMOCK_MAIN_LIBRARY}")
#message( STATUS "GTEST_MAIN_LIBRARY ${GTEST_MAIN_LIBRARY}")
#message( STATUS "GMOCK_INCLUDE_DIR ${GMOCK_INCLUDE_DIR}")
#message( STATUS "GTEST_INCLUDE_DIR ${GTEST_INCLUDE_DIR}")

#if(NOT TARGET GTest::GTest)
#    add_library(GTest::GTest UNKNOWN IMPORTED)
#endif(NOT TARGET GTest::GTest)

#if(NOT TARGET GTest::Main)
#     add_library(GTest::Main UNKNOWN IMPORTED)
#endif(NOT TARGET GTest::Main)

#if(NOT TARGET GMock::GMock)
#    add_library(GMock::GMock UNKNOWN IMPORTED)
#endif(NOT TARGET GMock::GMock)

#if(NOT TARGET GMock::Main)
#    add_library(GMock::Main UNKNOWN IMPORTED)
#endif(NOT TARGET GMock::Main)

if(GMOCK_FOUND AND GTEST_FOUND)

#message( STATUS "GTEST_FOUND and GMOCK_FOUND")

   set(GMOCK_INCLUDE_DIRS ${GMOCK_INCLUDE_DIR})
   set(GMOCK_BOTH_LIBRARIES ${GMOCK_LIBRARIES} ${GMOCK_MAIN_LIBRARIES})

   set(GTEST_INCLUDE_DIRS ${GTEST_INCLUDE_DIR})
   set(GTEST_BOTH_LIBRARIES ${GTEST_LIBRARIES} ${GTEST_MAIN_LIBRARIES})

   find_package(Threads QUIET)

   if(NOT TARGET GTest::GTest)

       add_library(GTest::GTest UNKNOWN  IMPORTED)

       if(TARGET Threads::Threads)
            set_target_properties(GTest::GTest PROPERTIES
                    INTERFACE_LINK_LIBRARIES "Threads::Threads"
                    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                    IMPORTED_LOCATION "${GTEST_LIBRARY}"
            )

       endif(TARGET Threads::Threads)

        if(GTEST_INCLUDE_DIRS)
            set_target_properties(GTest::GTest PROPERTIES
                    INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}"
    #        INTERFACE_SYSTEM_INCLUDE_DIRECTORIES  "${GTEST_INCLUDE_DIRS}"
            )
        endif(GTEST_INCLUDE_DIRS)

    endif(NOT TARGET GTest::GTest)

    if(NOT TARGET GTest::Main)

        add_library(GTest::Main UNKNOWN IMPORTED)
        set_target_properties(GTest::Main PROPERTIES
                INTERFACE_LINK_LIBRARIES "GTest::GTest"
                IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                IMPORTED_LOCATION "${GTEST_MAIN_LIBRARY}"
        )

    endif(NOT TARGET GTest::Main)

    if(NOT TARGET GMock::GMock )

        add_library(GMock::GMock  UNKNOWN IMPORTED)

        if(TARGET Threads::Threads)
            set_target_properties(GMock::GMock  PROPERTIES
                    INTERFACE_LINK_LIBRARIES "Threads::Threads"
                    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                    IMPORTED_LOCATION "${GMOCK_LIBRARY}"
            )
        endif(TARGET Threads::Threads)

        if(GMOCK_INCLUDE_DIRS)
            set_target_properties(GMock::GMock  PROPERTIES
                 INTERFACE_INCLUDE_DIRECTORIES "${GMOCK_INCLUDE_DIRS}")
        endif(GMOCK_INCLUDE_DIRS)

    endif(NOT TARGET GMock::GMock)

    if(NOT TARGET GMock::Main)
        add_library(GMock::Main UNKNOWN IMPORTED)
        set_target_properties(GMock::Main PROPERTIES
               INTERFACE_LINK_LIBRARIES "GMock::GMock"
               IMPORTED_LOCATION "${GMOCK_MAIN_LIBRARY}"
       )
    endif(NOT TARGET GMock::Main)
endif()


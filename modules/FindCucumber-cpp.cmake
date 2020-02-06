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


set(CUCUMBER_BOOST_LIBBRARIES
    thread
    system
    regex
    date_time
    program_options
#    asio
#    assign
    filesystem
#    multi_array
    signals
)

find_package(Boost COMPONENTS ${CUCUMBER_BOOST_LIBBRARIES} REQUIRED QUIET
#    HINTS
)

if(Boost_FOUND)

    find_path(CUCUMBER_INCLUDE_DIR cucumber-cpp/autodetect.hpp
        HINTS 
            /usr/local/include
    )

    list(APPEND CUCUMBER_NAMES cucumber-cpp libcucumber-cpp)
    list(APPEND CUCUMBER_NO_MAIN_NAMES cucumber-cpp-nomain libcucumber-cpp-nomain)


    find_library(CUCUMBER_LIBRARY 
        NAMES ${CUCUMBER_NAMES}
        HINTS 
            /usr/local/lib
    )

    find_library(CUCUMBER_NO_MAIN_LIBRARY 
        NAMES ${CUCUMBER_NO_MAIN_NAMES}
        HINTS /usr/local/lib
    )

    find_program(CUCUMBER_BINARY NAMES cucumber)

    mark_as_advanced(CUCUMBER_LIBRARY CUCUMBER_NO_MAIN_LIBRARY CUCUMBER_BINARY)

    if (CUCUMBER_LIBRARY AND CUCUMBER_INCLUDE_DIR)
        if(NOT TARGET CUCUMBER-CPP::CUCUMBER-CPP)
            add_library(CUCUMBER-CPP::CUCUMBER-CPP UNKNOWN IMPORTED)
            set_target_properties(CUCUMBER-CPP::CUCUMBER-CPP PROPERTIES
            ## INTERFACE_COMPILE_DEFINITIONS "${CUCUMBER_DEFINITIONS}"
                INTERFACE_INCLUDE_DIRECTORIES "${CUCUMBER_INCLUDE_DIRS}"
                INTERFACE_LINK_LIBRARIES "GTest::GTest;GMock::GMock;Boost::program_options;Boost::date_time;Boost::filesystem;Boost::regex;Boost::system;Boost::thread"
                IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                IMPORTED_LOCATION "${CUCUMBER_LIBRARY}"
            )
        endif (NOT TARGET CUCUMBER-CPP::CUCUMBER-CPP)

        if(NOT TARGET CUCUMBER_NO_MAIN_LIBRARY::CUCUMBER_NO_MAIN_LIBRARY)
            add_library(CUCUMBER_NO_MAIN_LIBRARY::CUCUMBER_NO_MAIN_LIBRARY UNKNOWN IMPORTED)
            set_target_properties(CUCUMBER_NO_MAIN_LIBRARY::CUCUMBER_NO_MAIN_LIBRARY PROPERTIES
                ## INTERFACE_COMPILE_DEFINITIONS "${CUCUMBER_DEFINITIONS}"
                INTERFACE_INCLUDE_DIRECTORIES "${CUCUMBER_INCLUDE_DIRS}"
                ##INTERFACE_LINK_LIBRARIES Boost::Boost
                IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                IMPORTED_LOCATION "${CUCUMBER_NO_MAIN_LIBRARY}"
            )
        endif (NOT TARGET CUCUMBER_NO_MAIN_LIBRARY::CUCUMBER_NO_MAIN_LIBRARY)
    endif(CUCUMBER_LIBRARY AND CUCUMBER_INCLUDE_DIR)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(CUCUMBER-CPP
         REQUIRED_VARS CUCUMBER_LIBRARY CUCUMBER_NO_MAIN_LIBRARY CUCUMBER_INCLUDE_DIR
    )
else(Boost_FOUND)
     message (WARNING "Boost library not found. Integration test not available")
endif(Boost_FOUND)

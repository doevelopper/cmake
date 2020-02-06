#        Utils.cmake
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

find_program(VALGRIND "valgrind")
set(MEMORYCHECK_COMMAND_OPTIONS "--xml=yes --xml-file=test.xml")
set(MEMORYCHECK_SUPPRESSIONS_FILE "")
if(VALGRIND)
    add_custom_target(valgrind
        COMMAND "${VALGRIND}"
                  --tool=memcheck
                  --leak-check=yes
                  --show-reachable=yes
                  --num-callers=20
                  --track-fds=yes $<TARGET_FILE:moduleTest>)
endif()

function(add_memcheck_test name binary)
    set(memcheck_command "${CMAKE_MEMORYCHECK_COMMAND} ${CMAKE_MEMORYCHECK_COMMAND_OPTIONS}")
    separate_arguments(memcheck_command)
    add_test(${name} ${binary} ${ARGN})
    add_test(memcheck_${name} ${memcheck_command} ./${binary} ${ARGN})
endfunction(add_memcheck_test)

function(set_memcheck_test_properties name)
    set_tests_properties(${name} ${ARGN})
    set_tests_properties(memcheck_${name} ${ARGN})
endfunction(set_memcheck_test_properties)


function(run_it_test TARGET_TEST_NAME FEATURES_LOCATION)
    add_custom_target(run-${TARGET_TEST_NAME}
        DEPENDS ${TARGET_TEST_NAME}
	COMMAND ${TARGET_TEST_NAME} --port=3902 >/dev/null & cucumber _2.0.0_ ${FEATURES_LOCATION}
    )
endfunction(run_it_test)



macro(ADD_NEW_CUCUMBER_TEST TEST_SOURCE FOLDER_NAME FEATURE_FOLDER)
    set (TARGET_NAME ${TEST_SOURCE}_TESTTARGET)
    add_executable(${TARGET_NAME}
	    ${FEATURE_FOLDER}/features/step_definitions/${TEST_SOURCE}
    )

    target_link_libraries(${TARGET_NAME}
	    CUCUMBER-CPP::CUCUMBER-CPP
    )

    add_test(NAME ${TEST_SOURCE}
	    COMMAND ${TARGET_NAME}
    )

    set_property(TARGET ${TARGET_NAME}
	    PROPERTY FOLDER ${FOLDER_NAME}
    )
endmacro()



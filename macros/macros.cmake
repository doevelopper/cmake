#       levitics-arkhe-gcs/src/main/resources/config/macros/macros.cmake
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

macro (TODAY RESULT)
    if (WIN32)
        execute_process(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${RESULT} ${${RESULT}})
    elseif(UNIX)
        execute_process(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${RESULT} ${${RESULT}})
    else (WIN32)
        message(SEND_ERROR "date not implemented")
        set(${RESULT} 000000)
    endif (WIN32)
endmacro (TODAY)

macro(getuname name flag)
	find_program(UNAME NAMES uname)
    exec_program("${UNAME}" ARGS "${flag}" OUTPUT_VARIABLE "${name}")
endmacro(getuname)

function(getGitInfo)
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.git)
        set(GIT_EXECUTABLE "git")

        execute_process( COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_REVISION
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process( COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_HASH
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process( COMMAND ${GIT_EXECUTABLE} config --get remote.origin.url
            OUTPUT_VARIABLE GIT_ORIGIN_URL
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

        execute_process( COMMAND ${GIT_EXECUTABLE} config --get remote.root.url
            OUTPUT_VARIABLE GIT_ROOT_URL
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

        execute_process( COMMAND ${GIT_EXECUTABLE} branch --contains HEAD
            OUTPUT_VARIABLE GIT_BRANCH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

        execute_process(COMMAND  "${GIT_EXECUTABLE}" log -1 --format=%ad --date=local
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            OUTPUT_VARIABLE GIT_DATE
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process(COMMAND  "${GIT_EXECUTABLE}" rev-list HEAD --count
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            OUTPUT_VARIABLE NB_GIT_COMMIT
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process(COMMAND  "${GIT_EXECUTABLE}" rev-list --all --count
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            OUTPUT_VARIABLE ALL_GIT_COMMIT_COUNT
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process(COMMAND  "${GIT_EXECUTABLE}" log -1 --format=%s
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            OUTPUT_VARIABLE GIT_COMMIT_SUBJECT
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process( COMMAND "${GIT_EXECUTABLE}" diff-index --quiet HEAD --
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            RESULT_VARIABLE res
            OUTPUT_VARIABLE out
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE)

            if(res EQUAL 0)
                set(${REL} "GA")
            else()
                set(${REL} "-SNAPSHOOT")
            endif()

            set(GIT_REVISION ${GIT_REVISION} PARENT_SCOPE)
            set(VERSION_COMMIT ${GIT_STATE_ALWAYS} PARENT_SCOPE)
            set(GIT_ORIGIN_URL ${GIT_ORIGIN_URL} PARENT_SCOPE)
            set(GIT_COMMIT_SUBJECT ${GIT_COMMIT_SUBJECT} PARENT_SCOPE)
            set(GIT_DATE ${GIT_DATE} PARENT_SCOPE)
            set(GIT_BRANCH ${GIT_BRANCH} PARENT_SCOPE)
            set(NB_COMMIT ${NB_GIT_COMMIT} PARENT_SCOPE)
            set(HASH ${GIT_HASH} PARENT_SCOPE)
            set(ALL_GIT_COMMIT_COUNT ${ALL_GIT_COMMIT_COUNT} PARENT_SCOPE)

    endif(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.git)

    if(EXISTS ${PROJECT_BINARY_DIR}/Authors.txt)
        file(READ ${PROJECT_BINARY_DIR}/Authors.txt GIT_AUTHORS)
    else(EXISTS ${PROJECT_BINARY_DIR}/Authors.txt)
        set(GIT_AUTHORS)
        execute_process(COMMAND "${GIT_EXECUTABLE}" log
            OUTPUT_VARIABLE GIT_LOG
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

        string(REPLACE "\n" ";" GIT_LOG ${GIT_LOG})

        foreach(__line ${GIT_LOG})
            if(__line MATCHES "^Author:")
                string(REPLACE "Author: " "" __line "${__line}")
                string(REGEX REPLACE "[ ]?<.*" "" __line "${__line}")
                list(APPEND GIT_AUTHORS "${__line}")
          endif()
        endforeach()
        list(SORT GIT_AUTHORS)
        list(REMOVE_DUPLICATES GIT_AUTHORS)
        file(WRITE ${PROJECT_BINARY_DIR}/Authors.txt "${GIT_AUTHORS}")
    endif(EXISTS ${PROJECT_BINARY_DIR}/Authors.txt)
endfunction(getGitInfo)


function(generateGitInfo)
    if(EXISTS ${CMAKE_SOURCE_DIR}/.git)
        set(GIT_EXECUTABLE "git")
        add_custom_command(OUTPUT ${SRCDIR}/gitrevision.hh
            COMMAND ${CMAKE_COMMAND} -E echo_append "#define GITREVISION " > ${SRCDIR}/gitrevision.hh
            COMMAND ${GIT_SCM} log -1 "--pretty=format:%h %ai" >> ${SRCDIR}/gitrevision.hh
            DEPENDS ${GITDIR}/logs/HEAD
            VERBATIM
        )
    endif(EXISTS ${CMAKE_SOURCE_DIR}/.git)
endfunction(generateGitInfo)

function(targetName flag)
    if(${flag})
        if(NOT TARGET targetName)
            add_custom_target(targetName
                COMMENT "Running targetName ."
            )
        endif()
    endif(${flag})
endfunction(targetName)

find_program(VALGRIND "valgrind")
set(MEMORYCHECK_COMMAND_OPTIONS "--xml=yes --xml-file=test.xml")
set(MEMORYCHECK_SUPPRESSIONS_FILE "")
#if(VALGRIND)
#    add_custom_target(valgrind
#        COMMAND "${VALGRIND}"
#                  --tool=memcheck
#                  --leak-check=yes
#                  --show-reachable=yes
#                  --num-callers=20
#                  --track-fds=yes $<TARGET_FILE:moduleTest>)
#endif()

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

macro(info msg)
    message(STATUS "Info: ${msg}")
endmacro()

macro(infoValue variableName)
    info("${variableName}=\${${variableName}}")
endmacro()

macro(SHOWFLAG flag)
  message(STATUS "${flag} = ${${flag}}")
endmacro(SHOWFLAG)

# Followings are our coding convention.
set(LINT_FILTER) # basically everything Google C++ Style recommends. Except...

#  set(LINT_FILTER ${LINT_FILTER}-build/class,)
#  set(LINT_FILTER ${LINT_FILTER}-build/c++11,)
  set(LINT_FILTER ${LINT_FILTER}+build/c++14,)
#  set(LINT_FILTER ${LINT_FILTER}-build/c++tr1,)
#  set(LINT_FILTER ${LINT_FILTER}-build/deprecated,)
#  set(LINT_FILTER ${LINT_FILTER}-build/endif_comment,)
#  set(LINT_FILTER ${LINT_FILTER}-build/explicit_make_pair,)
#  set(LINT_FILTER ${LINT_FILTER}-build/forward_decl,)
  set(LINT_FILTER ${LINT_FILTER}-build/header_guard,)
#  set(LINT_FILTER ${LINT_FILTER}-build/include,)
#  set(LINT_FILTER ${LINT_FILTER}-build/include_subdir,)
#  set(LINT_FILTER ${LINT_FILTER}-build/include_alpha,)
#  set(LINT_FILTER ${LINT_FILTER}-build/include_order,)
  set(LINT_FILTER ${LINT_FILTER}+build/include_what_you_use,)
  set(LINT_FILTER ${LINT_FILTER}-build/namespaces_literals,)
  set(LINT_FILTER ${LINT_FILTER}-build/namespaces,)
#  set(LINT_FILTER ${LINT_FILTER}-build/printf_format,)
#  set(LINT_FILTER ${LINT_FILTER}-build/storage_class,)
  set(LINT_FILTER ${LINT_FILTER}-legal/copyright,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/alt_tokens,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/braces,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/casting,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/check,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/constructors,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/fn_size,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/inheritance,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/multiline_comment,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/multiline_string,)
  set(LINT_FILTER ${LINT_FILTER}-readability/namespace,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/nolint,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/nul,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/strings,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/todo,)
#  set(LINT_FILTER ${LINT_FILTER}-readability/utf8,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/arrays,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/casting,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/explicit,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/int,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/init,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/invalid_increment,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/member_string_references,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/memset,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/indentation_namespace,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/operator,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/printf,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/printf_format,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/references,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/string,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/threadsafe_fn,)
#  set(LINT_FILTER ${LINT_FILTER}-runtime/vlog,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/blank_line,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/braces,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/comma,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/comments,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/empty_conditional_body,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/empty_if_body,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/empty_loop_body,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/end_of_line,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/ending_newline,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/forcolon,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/indent,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/line_length,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/newline,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/operators,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/parens,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/semicolon,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/tab,)
#  set(LINT_FILTER ${LINT_FILTER}-whitespace/todo,)


# This the only rule cpplint.py disables by default. Enable it.
# However, the default implementation of build/include_alpha in cpplint.py is a bit sloppy.
# It doesn't correctly take care of "/" in include.
# Thus we changed cpplint.py for this.
#set(LINT_FILTER ${LINT_FILTER},+build/include_alpha)

# for logging and debug printing, we do need streams
#set(LINT_FILTER ${LINT_FILTER},-readability/streams)

# We use C++11 with some restrictions.
# set(LINT_FILTER ${LINT_FILTER},-build/c++11)
#

# Consider disabling them if they cause too many false positives.
# set(LINT_FILTER ${LINT_FILTER},-build/include_what_you_use)
# set(LINT_FILTER ${LINT_FILTER},-build/include_order)

# disable unwanted filters
#set(LINT_FILTER ${LINT_FILTER}-legal/copyright,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/braces,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/semicolon,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/blank_line,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/comma,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/operators,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/parens,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/indent,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/comments,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/newline,)
#set(LINT_FILTER ${LINT_FILTER}-whitespace/tab,)
#
#set(LINT_FILTER ${LINT_FILTER}-build/include_order,)
#set(LINT_FILTER ${LINT_FILTER}-build/namespaces,)
#set(LINT_FILTER ${LINT_FILTER}-build/include_what_you_use,)
#
#set(LINT_FILTER ${LINT_FILTER}-readability/streams,)
#set(LINT_FILTER ${LINT_FILTER}-readability/todo,)
#set(LINT_FILTER ${LINT_FILTER}-readability/casting,)
#
#set(LINT_FILTER ${LINT_FILTER}-runtime/references,)
#set(LINT_FILTER ${LINT_FILTER}-runtime/int,)
#set(LINT_FILTER ${LINT_FILTER}-runtime/explicit,)
#set(LINT_FILTER ${LINT_FILTER}-runtime/printf,)

mark_as_advanced(LINT_FILTER)

find_package(PythonInterp)


set(LINT_SCRIPT "${PROJECT_SOURCE_DIR}/src/main/resources/scripts/cpplint-1.3.0/cpplint.py")
mark_as_advanced(LINT_SCRIPT)
set(LINT_WRAPPER "${PROJECT_SOURCE_DIR}/src/main/resources/scripts/cpplint-1.3.0/cpplint-wrapper.py")
mark_as_advanced(LINT_WRAPPER)

# 120 chars per line, which is suggested as an option in the style guide
set(LINT_LINELENGTH 120)
mark_as_advanced(LINT_LINELENGTH)

# Registers a CMake target to run cpplint over all files in the given folder.
# Parameters:
#  target_name:
#    The name of the target to define. Your program should depend on it to invoke cpplint.
#  src_folder:
#    The folder to recursively run cpplint.
#  root_folder:
#    The root folder used to determine desired include-guard comments.

function(add_code_linter target_name src_folder top_level_directory)
	if(PYTHONINTERP_FOUND)

		# if(${PYTHON_VERSION_MAJOR} EQUAL 3)
			# message(WARNING "Cpplint won't detect errors. Install Python 2 to fix this issue.")
			# message(FATAL_ERROR "OUCH! The Python found is Python 3. Cpplint.py doesn't run on it so far.")
		# endif(${PYTHON_VERSION_MAJOR} EQUAL 3)

        if(NOT TARGET ${target_name}-lint)

            set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/cpplint/${target_name}")
            file(MAKE_DIRECTORY ${WORKING_DIR})

            add_custom_target(${target_name}-lint
				COMMAND ${PYTHON_EXECUTABLE} --version
				COMMAND ${PYTHON_EXECUTABLE} ${LINT_WRAPPER}
						--cpplint-file=${LINT_SCRIPT}
						--history-file=${WORKING_DIR}/lint_history
						--linelength=${LINT_LINELENGTH}

#						--exclude=${top_level_directory}/src/test/*.cpp
#						--exclude=${top_level_directory}/src/test/*.hpp
##                        --headers=hpp
                        --extensions=cpp,hpp
                        --filter=${LINT_FILTER}
##                        --root=cpp
##                        --repository=${top_level_directory}
                        --output=junit
##                        --style-error
##                        --recursive
                        --counting=total
                        --counting=detailed
                        --verbose=5
                        --root=cppbdd101
                        ${src_folder} > ${WORKING_DIR}/lint.xml 2>&1
                WORKING_DIRECTORY ${WORKING_DIR}
                COMMENT "[C++ style guide checker-linter] ${target_name} ${src_folder}"
            )
        endif()
	else(PYTHONINTERP_FOUND)
        add_custom_target(
            ${target_name}-lint
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis! Python interp missing"
        )
	endif(PYTHONINTERP_FOUND)

    add_dependencies(configure ${target_name}-lint)

endfunction()

function(add_code_linter_command target_name src_folder top_level_directory)
    if(PYTHONINTERP_FOUND)

#       if(${PYTHON_VERSION_MAJOR} EQUAL 3)
#           message(WARNING "Cpplint won't detect errors. Install Python 2 to fix this issue.")
#           message(FATAL_ERROR "OUCH! The Python found is Python 3. Cpplint.py doesn't run on it so far.")
#       endif(${PYTHON_VERSION_MAJOR} EQUAL 3)

        set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/cpplint/${target_name}")
#           file(MAKE_DIRECTORY ${WORKING_DIR})

#            add_custom_target(${target_name}-lint
            add_custom_command(TARGET ${target_name} PRE_BUILD

                COMMAND
                    ${CMAKE_COMMAND} -E make_directory ${WORKING_DIR}

                COMMAND 
                    ${PYTHON_EXECUTABLE} --version
                COMMAND 
                    ${PYTHON_EXECUTABLE} ${LINT_WRAPPER}
                        --cpplint-file=${LINT_SCRIPT}
                        --history-file=${WORKING_DIR}/lint_history
                        --linelength=${LINT_LINELENGTH}

#                        --exclude=${top_level_directory}/src/test/*.cpp
#                        --exclude=${top_level_directory}/src/test/*.hpp
##                       --headers=hpp
                        --extensions=cpp,hpp
                        --filter=${LINT_FILTER}
##                        --root=cpp
##                        --repository=${top_level_directory}
                        --output=junit
##                        --style-error
##                        --recursive
                        --counting=total
                        --counting=detailed
                        --verbose=5
                        --root=cppbdd101
                        ${src_folder} > ${WORKING_DIR}/lint.xml 2>&1

                WORKING_DIRECTORY 
                    ${WORKING_DIR}

                COMMENT 
                    "[C++ style guide checker-linter] ${target_name} ${src_folder}"
            )
        else(PYTHONINTERP_FOUND)
#            add_custom_target( ${target_name}-lint
            add_custom_command(TARGET ${target_name} PRE_BUILD
                COMMAND 
                    ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis! Python interp missing"
        )
        endif(PYTHONINTERP_FOUND)
endfunction()




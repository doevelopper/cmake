#        macros/CodingStyle.cmake
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

set (UNCRUSTIFY_CONFIG "${PROJECT_SOURCE_DIR}/src/main/resources/configs/code-formater.cfg")
set (UNCRUSTIFY_FLAGS -q --if-changed --no-backup -l CPP  -c ${UNCRUSTIFY_CONFIG})

find_program(UNCRUSTIFY uncrustify
    DOC "Code Source beautofyer"
)

function(apply_style_targets_command TARGET_NAME BASE_DIRECTORY)
    if(UNCRUSTIFY)

        mark_as_advanced(UNCRUSTIFY)

        file(GLOB_RECURSE SRC ${BASE_DIRECTORY} *.cpp *.hpp)

        add_custom_command( TARGET ${TARGET_NAME}
            PRE_BUILD
            COMMAND "${UNCRUSTIFY}"  ${UNCRUSTIFY_FLAGS} ${SRC}
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMENT "[Code Beautifying] : ${TARGET_NAME} in  ${BASE_DIRECTORY}"
        )

    else(UNCRUSTIFY)
        add_custom_command( TARGET ${TARGET_NAME} PRE_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] Code formating not applied"
        )
    endif(UNCRUSTIFY)

    #add_dependencies(${TARGET_NAME} style)

endfunction()


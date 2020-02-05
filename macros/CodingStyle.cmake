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
endfunction()


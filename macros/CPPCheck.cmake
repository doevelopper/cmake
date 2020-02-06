set(CPPCHECK_HTMLREPORT_GENERATOR "${PROJECT_SOURCE_DIR}/src/main/resources/scripts/cppcheck-htmlreport.py")
set(CONTROVERSIAL "–inconclusive")
set(CPPCHECK_TEMPLATE_ARG --template gcc) # --template="[{severity}][{id}] {message} {callstack} \(On {file}:{line}\)"

set(CPPCHECK_OPTIONS
    ${CONTROVERSIAL}
    --report-progress
#    --platform=native
    --platform=unix64
    --enable=warning,performance,portability,information,missingInclude,style
#    --project=/home/happyman/Documents/levitics-arkhe-cfs/build/Debug/compile_commands.json
#    --enable=all
    --std=c++14
    --std=c11
    --std=posix
    --inline-suppr
#    --language=c, c++
#    --suppress=missingIncludeSystem
#    --library=qt.cfg
    --verbose
#    --quiet
    --xml-version=2
    -j4
#    -j${Ncpu}
#    --error-exitcode=25000
#    -I${INC_DIR}
)

find_package(PythonInterp)

function(add_cppcheck_analysis target_name bin_folder)

    if(PYTHONINTERP_FOUND)

        find_program(CPPCHECK cppcheck
            NAMES cppcheck
            PATHS
                /usr/local/bin
                /opt/cmake/bin/
#           NO_DEFAULT_PATH
        )


        if(CPPCHECK)

            set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/cppcheck/${target_name}")
            file(MAKE_DIRECTORY ${WORKING_DIR})
            file(GLOB_RECURSE ALL_SOURCE_FILES ${bin_folder} *.cpp)
            file(GLOB_RECURSE ALL_HEADER_FILES ${bin_folder} *.hpp)
            # cppcheck --project=${CMAKE_BINARY_DIR}/compile_commands.json instead of globs above. to be tested

            add_custom_target( ${target_name}-cppcheck
#               COMMAND ${CPPCHECK} ${CPPCHECK_OPTIONS} ${CPPCHECK_TEMPLATE_ARG} ${ALL_SOURCE_FILES} ${ALL_HEADER_FILES}
                COMMAND ${CPPCHECK} ${CPPCHECK_OPTIONS} ${CPPCHECK_TEMPLATE_ARG} ${ALL_SOURCE_FILES} ${ALL_HEADER_FILES}
                    --cppcheck-build-dir=${WORKING_DIR} 2> ${WORKING_DIR}/cppcheck.xml
                COMMAND ${PYTHON_EXECUTABLE} ${CPPCHECK_HTMLREPORT_GENERATOR} --title=${target_name} --file=${WORKING_DIR}/cppcheck.xml
                    --source-dir=${bin_folder} --report-dir=${WORKING_DIR}
                WORKING_DIRECTORY ${bin_folder}
                DEPENDS ${ALL_SOURCE_FILES} ${ALL_HEADER_FILES}
                COMMENT "[CPPCheck Static Code Analysis] ${bin_folder}"
        )
        else(CPPCHECK)

            add_custom_target(
                ${target_name}-cppcheck
                COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis!"
           )

       endif(CPPCHECK)

    else(PYTHONINTERP_FOUND)
        add_custom_target(
            ${target_name}-cppcheck
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis! Python interp missing"
        )
    endif(PYTHONINTERP_FOUND)

    add_dependencies(configure ${target_name}-cppcheck)

endfunction()


function(add_cppcheck_analysis_command target_name bin_folder)

    if(PYTHONINTERP_FOUND)

        find_program(CPPCHECK cppcheck
            NAMES cppcheck
            PATHS
                /usr/local/bin
                /opt/cmake/bin/
#            NO_DEFAULT_PATH
        )

        if(CPPCHECK)
            set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/cppcheck/${target_name}")
#            file(MAKE_DIRECTORY ${WORKING_DIR})
            file(GLOB_RECURSE ALL_SOURCE_FILES ${bin_folder} *.cpp)
            file(GLOB_RECURSE ALL_HEADER_FILES ${bin_folder} *.hpp)

#            add_custom_target( ${target_name}-cppcheck
             add_custom_command(TARGET ${target_name} PRE_BUILD
                COMMAND
                    ${CMAKE_COMMAND} -E make_directory ${WORKING_DIR}
                COMMAND
                    ${CPPCHECK} ${CPPCHECK_OPTIONS} ${CPPCHECK_TEMPLATE_ARG} ${ALL_SOURCE_FILES} ${ALL_HEADER_FILES}
                        --cppcheck-build-dir=${WORKING_DIR} 2> ${WORKING_DIR}/cppcheck.xml
                COMMAND
                    ${PYTHON_EXECUTABLE} ${CPPCHECK_HTMLREPORT_GENERATOR} --title=${target_name} --file=${WORKING_DIR}/cppcheck.xml
                        --source-dir=${bin_folder} --report-dir=${WORKING_DIR}
                WORKING_DIRECTORY
                        ${bin_folder}
                DEPENDS
                     ${ALL_SOURCE_FILES} ${ALL_HEADER_FILES}
                COMMENT
                     "[CPPCheck Static Code Analysis] ${bin_folder}"
        )
        else(CPPCHECK)
#            add_custom_target( ${target_name}-cppcheck
            add_custom_command(TARGET ${target_name} PRE_BUILD
                COMMAND
                    ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis!"
           )
       endif(CPPCHECK)

    else(PYTHONINTERP_FOUND)
#        add_custom_target(${target_name}-cppcheck
        add_custom_command(TARGET ${target_name}
            PRE_BUILD
            COMMAND
                ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis! Python interp missing"
        )
    endif(PYTHONINTERP_FOUND)

#    add_dependencies(configure ${target_name}-cppcheck)

endfunction()


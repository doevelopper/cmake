#Cyclomatic Complexity Analyzer 
set(LIZARD_OPTIONS  
    -l cpp 
    --verbose
    --CCN 15
    --length 500
    --arguments 3 
    --warnings_only
	--exclude "*/src/test/*"
    --working_threads 4 #${Ncpu} 
    --modified
    --sort nloc #cyclomatic_complexity, token_count, parameter_count
   --Threshold nloc=5
#   --input_file=build/Debug/qa/cppcheck/SphynxCore/files.txt
)

set(LIZARD_SCRIPT "${PROJECT_SOURCE_DIR}/src/main/resources/scripts/lizard-1.15.6/lizard.py")
mark_as_advanced(LIZARD_SCRIPT LIZARD_OPTIONS)
find_package(PythonInterp)

function(add_cyclomatic_complexity_analyzer target_name bin_folder)
	if(PYTHONINTERP_FOUND)
        if(NOT TARGET ${target_name}-cyclomatic)
			set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/metrics/${target_name}")
            file(MAKE_DIRECTORY ${WORKING_DIR})
            add_custom_target(${target_name}-cyclomatic 
                COMMAND ${PYTHON_EXECUTABLE} ${LIZARD_SCRIPT} ${LIZARD_OPTIONS} ${bin_folder} --html > ${WORKING_DIR}/lizard.html
#                COMMAND ${PYTHON_EXECUTABLE} ${LIZARD_SCRIPT} ${LIZARD_OPTIONS} ${bin_folder} --xml  > ${WORKING_DIR}/lizard.xml
                WORKING_DIRECTORY ${WORKING_DIR}
                COMMENT "[Code metrics analyser]: ${target_name}"
            )
        endif()
    else(PYTHONINTERP_FOUND)
        add_custom_target(
            ${target_name}-cyclomatic
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis! Python interp missing"
        )
    endif(PYTHONINTERP_FOUND)

    add_dependencies(configure ${target_name}-cyclomatic)

endfunction(add_cyclomatic_complexity_analyzer)


function(add_cyclomatic_complexity_analyzer_command target_name bin_folder)
    if(PYTHONINTERP_FOUND)
            set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/metrics/${target_name}")
            add_custom_command(TARGET ${target_name} 
                PRE_BUILD

                COMMAND
                    ${CMAKE_COMMAND} -E make_directory ${WORKING_DIR}

                COMMAND 
                    ${PYTHON_EXECUTABLE} ${LIZARD_SCRIPT} ${LIZARD_OPTIONS} ${bin_folder} --html > ${WORKING_DIR}/lizard.html

#                COMMAND ${PYTHON_EXECUTABLE} ${LIZARD_SCRIPT} ${LIZARD_OPTIONS} ${bin_folder} --xml  > ${WORKING_DIR}/lizard.xml

                WORKING_DIRECTORY 
                   ${WORKING_DIR}

                COMMENT 
                   "[Code metrics analyser]: ${target_name}"
            )
    else(PYTHONINTERP_FOUND)
         add_custom_command(TARGET ${target_name}
            PRE_BUILD

            COMMAND 
                ${CMAKE_COMMAND} -E echo "[---SKIPPED---] CPPCheck  Static Code analysis! Python interp missing"
        )
    endif(PYTHONINTERP_FOUND)
endfunction(add_cyclomatic_complexity_analyzer_command)


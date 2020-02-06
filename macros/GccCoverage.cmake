

if(NOT COVERAGE_LIMITS)
    set(COVERAGE_LIMITS --rc genhtml_med_limit=40 --rc genhtml_hi_limit=80)
endif(NOT COVERAGE_LIMITS)

set(LCOV_OPTIONS "--quiet")
set(LCOV_GENTHML_OPTIONS "--demangle-cpp")

if(LCOV_BRANCH_COVERAGE)
    list(APPEND LCOV_OPTIONS "--rc" "lcov_branch_coverage=1")
    list(APPEND LCOV_GENTHML_OPTIONS "--branch-coverage")
else()
    list(APPEND LCOV_OPTIONS "--rc" "lcov_branch_coverage=0")
    list(APPEND LCOV_GENTHML_OPTIONS "--no-branch-coverage")
endif()

if(LCOV_FUNCTION_COVERAGE)
    list(APPEND LCOV_OPTIONS "--rc" "lcov_function_coverage=1")
    list(APPEND LCOV_GENTHML_OPTIONS "--function-coverage" "--demangle-cpp")
else()
    list(APPEND LCOV_OPTIONS "--rc" "lcov_function_coverage=0")
    list(APPEND LCOV_GENTHML_OPTIONS "--no-function-coverage")
endif()

set(LCOV_EXTRA_ARGS 
	--base-directory "${CPP_SOURCE_DIR}"
    --directory "${OUTPUT_DIR}"
    --no-external
    --gcov-tool "${COVERAGE_COMMAND}"
    --rc lcov_branch_coverage=1
    --rc geninfo_all_blocks=true
)

set(GENHTML_EXTRA_ARGS --show-details --frames --legend
    --branch-coverage --function-coverage --sort
    --demangle-cpp
    --title "${PROJECT_NAME}"
)

function(add_code_coverage_targets test_target module_name module_directory)
    if(CMAKE_COMPILER_IS_GNUCXX)
        find_program(GCOVR gcovr)
        find_program(GENHTML genhtml)
        find_program(LCOV lcov)
        find_program(GENINFO geninfo)
        find_program(GENDESC gendesc)
        find_program(GENPNG genpng)

        mark_as_advanced(LCOV GENINFO GENHTML GCOVR GENDESC GENPNG)

        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_COVERAGE}")
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_COVERAGE}")

		set(COVERAGE_WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/coverage/${module_name}")
		set(COVERAGE_RAW_FILE "${COVERAGE_WORKING_DIR}/coverage.raw.info")
		set(COVERAGE_FILTERED_FILE "${COVERAGE_WORKING_DIR}/coverage.info")
		set(COVERAGE_REPORT_DIR "${COVERAGE_WORKING_DIR}/coveragereport")
		file(MAKE_DIRECTORY ${COVERAGE_WORKING_DIR})

		add_test(NAME ${test_target}
				WORKING_DIRECTORY
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
				COMMAND
                    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${test_target}
		)

		add_custom_target( ${test_target}-coverage
			WORKING_DIRECTORY
                ${COVERAGE_WORKING_DIR}
	#        COMMAND ${CMAKE_COMMAND} -E echo "Test coverage is disabled"
			COMMENT
                "[Coverage report] : ${module_name}] ${module_directory}."
	#        DEPENDS
		)

		if(NOT TARGET coverage)
			add_custom_target(coverage
				COMMENT "Running ${module_name} coverage report."
			)
		endif()

		add_custom_command(TARGET ${test_target}-coverage
			COMMENT "Cleaning gcda files ${module_directory}"
			COMMAND lcov --directory ${module_directory} --zerocounters
			WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
		)

		add_custom_command(TARGET ${test_target}-coverage
			COMMENT "Running ${test_target}"
	#        COMMAND make test
			COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${test_target}
			WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
		)

		add_custom_command(TARGET ${test_target}-coverage
			COMMENT "Capturing date in ${module_directory}"
			COMMAND lcov --directory ${module_directory} --capture --output-file ${COVERAGE_WORKING_DIR}/${module_name}.info
			COMMAND lcov --remove ${COVERAGE_WORKING_DIR}/${module_name}.info 'build/*' '/usr/*' --output-file ${COVERAGE_WORKING_DIR}/${module_name}.cleaned.info
			WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
		)

		add_custom_command(TARGET ${test_target}-coverage
			COMMENT "Generating html report ${COVERAGE_WORKING_DIR}"
	#        COMMAND genhtml -o ${COVERAGE_WORKING_DIR} ${COVERAGE_WORKING_DIR}/${module_name}.info
			COMMAND genhtml --frames --show-details --title ${module_name} ${COVERAGE_LIMITS}  -s --legend --highlight --demangle-cpp -o ${COVERAGE_WORKING_DIR} ${COVERAGE_WORKING_DIR}/${MODULE_NAME}.cleaned.info
			WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
		)

		add_custom_command(TARGET ${test_target}-coverage
			COMMAND echo "Open ${COVERAGE_WORKING_DIR}/index.html to view the coverage analysis results."
			WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
		)

    else(CMAKE_COMPILER_IS_GNUCXX)
        add_custom_target(
            ${module_name}-coverage
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] No compliant compiler"
        )
    endif(CMAKE_COMPILER_IS_GNUCXX)
    add_dependencies(verify ${module_name}-coverage)
endfunction()
# Example post-processing with lcov:
#
# see also gen-coverage.py
#
#     lcov --rc lcov_branch_coverage=1 --capture --directory $PWD -o coverage_post_raw.info
#     lcov --capture --initial --directory $PWD -o coverage_init_raw.info
#     lcov --rc lcov_branch_coverage=1 --remove coverage_post_raw.info 'boost/*' '/c++/*' 'build-cov/*' 'cppformat/*' '/qt5/*' -o coverage_post.info
#     lcov --rc lcov_branch_coverage=1 --remove coverage_init_raw.info 'boost/*' '/c++/*' 'build-cov/*' 'cppformat/*' '/qt5/*' -o coverage_init.info
#     lcov --rc lcov_branch_coverage=1  -a coverage_init.info -a coverage_post.info -o coverage.info
#     genhtml --branch-coverage coverage.info -o coverage
#
# View e.g. via:
#
#     firefox coverage/index.html

# llvm-cov
#add_custom_target(${TARGET_NAME}-ccov-preprocessing
#    COMMAND
#        LLVM_PROFILE_FILE=${TARGET_NAME}.profraw $<TARGET_FILE:${TARGET_NAME}>
#    COMMAND
#        llvm-profdata merge -sparse ${TARGET_NAME}.profraw -o ${TARGET_NAME}.profdata
#    DEPENDS
#        ${TARGET_NAME})

#add_custom_target(${TARGET_NAME}-ccov-show
#    COMMAND
#        llvm-cov show $<TARGET_FILE:${TARGET_NAME}> -instr-profile=${TARGET_NAME}.profdata -show-line-counts-or-regions
#    DEPENDS
#        ${TARGET_NAME}-ccov-preprocessing)

#add_custom_target(${TARGET_NAME}-ccov-report
#    COMMAND
#        llvm-cov report $<TARGET_FILE:${TARGET_NAME}> -instr-profile=${TARGET_NAME}.profdata
#    DEPENDS
#        ${TARGET_NAME}-ccov-preprocessing)

#add_custom_target(${TARGET_NAME}-ccov
#    COMMAND
#        llvm-cov show $<TARGET_FILE:${TARGET_NAME}> -instr-profile=${TARGET_NAME}.profdata -show-line-counts-or-regions -output-dir=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_NAME}-llvm-cov -format="html"
#    DEPENDS
#        ${TARGET_NAME}-ccov-preprocessing)

#add_custom_command(TARGET ${TARGET_NAME}-ccov POST_BUILD
#    COMMAND ;
#    COMMENT
#        "Open ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_NAME}-llvm-cov/index.html in your browser to view the coverage report."
#)


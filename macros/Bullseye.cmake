#Find bullseye executables first

# ENV BULLSEYE_VERSION ${BULLSEYE:-8.15.31}
# RUN cd /tmp/ \
    # && curl -Lk http://www.bullseye.com/download/BullseyeCoverage-$BULLSEYE_VERSION-Linux-x64.tar | tar x -C /opt \
   ##&&  echo | /opt/BullseyeCoverage-$BULLSEYE_VERSION/install --key 4ChKeY0AX2Et3CDftN2cqkhg0NUEf03o4gQX \
    # && echo | /opt/BullseyeCoverage-$BULLSEYE_VERSION/install --key 2Ct8nh2WOwHc2t4gvl1IYzzX1uGCW82sERqr \
    # && rm -rf /opt/BullseyeCoverage-$BULLSEYE_VERSION*

#  ENV PATH /opt/BullseyeCoverage/bin:$PATH
#export COVFILE=$HOME/bullseye.cov && cov01 --on && cov01 --status && make -j12 && cov01 --off
   

set(BULLSEYE_PATH "/opt/BullseyeCoverage/bin")
if(ENABLE_COVERAGE)

    find_program(BULLSEYE_GCC
                NAMES "gcc"
                PATHS ${BULLSEYE_PATH}
                NO_DEFAULT_PATH
    )

    find_program(BULLSEYE_G++                 
                NAMES "g++"                 
                PATHS ${BULLSEYE_PATH}                 
                NO_DEFAULT_PATH        
    )
    find_program(BULLSEYE_CXX                 
                NAMES "c++"                 
                PATHS ${BULLSEYE_PATH}                 
                NO_DEFAULT_PATH        
    )
    find_program(BULLSEYE_C++                 
                NAMES "c++"                 
                PATHS ${BULLSEYE_PATH}                 
                NO_DEFAULT_PATH        
    )
    find_program(BULLSYE_CC 
                    NAMES "cl" 
                    PATHS ${BULLSEYE_PATH} 
                    NO_DEFAULT_PATH
                )
    find_program(BULLSEYE_COV_ENABLE 
                    NAMES "cov01" 
                    PATHS ${BULLSEYE_PATH} 
                    NO_DEFAULT_PATH
                )
    find_program(BULLSEYE_COV_XML 
                    NAMES "covxml" 
                    PATHS ${BULLSEYE_PATH} 
                    NO_DEFAULT_PATH
                )
    find_program(BULLSEYE_COV_HTML
                    NAMES "covhtml" 
                    PATHS ${BULLSEYE_PATH} 
                    NO_DEFAULT_PATH
                )
    #find_package_handle_standard_args(BULLSEYE DEFAULT_MSG BULLSEYE_GCC BULLSEYE_G++ BULLSEYE_CXX BULLSEYE_C++)
    find_package_handle_standard_args(BULLSEYE DEFAULT_MSG 
                    BULLSEYE_CXX 
                    BULLSEYE_CC 
                    BULLSEYE_COV_ENABLE
                    BULLSEYE_COV_XML
                    BULLSEYE_COV_HTML)
    set(CMAKE_CXX_COMPILER "${BULLSEYE_CC}"}

    set(CMAKE_GCC_COMPILER "${BULLSEYE_GCC}")
    set(CMAKE_G++_COMPILER "${BULLSEYE_G++}")
    set(CMAKE_CXX_COMPILER "${BULLSEYE_CXX}")
    set(CMAKE_C++_COMPILER "${BULLSEYE_C++}")

    message(STATUS "CMAKE_CXX_COMPILER : ${CMAKE_GCC_COMPILER} ${CMAKE_G++_COMPILER} ${CMAKE_CXX_COMPILER} ${CMAKE_C++_COMPILER}")
    message(STATUS "BULLSEYE_PATH      : ${BULLSEYE_PATH}")
else(ENABLE_COVERAGE)
    message(STATUS "Code coverage skipped.")
endif(ENABLE_COVERAGE)


function(add_coverage_targets TEST_TARGET MODULE_NAME MODULE_DIRECTORY)

#   export COVFILE=`pwd`/coverage.cov
#   cov01 -1
#   gcc example.c -o example
#   ./example
#   cov01 -0
#   covxml -f coverage.cov -o report.xml
#   rm example


    set(COVERAGE_WORKING_DIR "${TARGET_BUILD_DIRECTORY}/qa/coverage/${MODULE_NAME}")
    set(COVERAGE_RAW_FILE "${COVERAGE_WORKING_DIR}/coverage.raw.info")
    set(COVERAGE_FILTERED_FILE "${COVERAGE_WORKING_DIR}/coverage.info")
    set(COVERAGE_REPORT_DIR "${COVERAGE_WORKING_DIR}/coveragereport")
    file(MAKE_DIRECTORY ${COVERAGE_WORKING_DIR})


    add_test(NAME ${TEST_TARGET}
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin
            COMMAND ${CMAKE_BINARY_DIR}/bin/${TEST_TARGET}
    )

    if(NOT TARGET coverage)
        add_custom_target(coverage
            COMMENT "Running ${MODULE_NAME} coverage report."
        )
    endif()

    add_custom_command(TARGET coverage
        COMMENT "Enable / show status of coverage build"
        COMMAND ${BULLSEYE_COV_ENABLE} --on --verbose --no-banner 
        WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
    )

    add_custom_command(TARGET coverage
        COMMENT "Running ${TEST_TARGET}"
        COMMAND ${CMAKE_BINARY_DIR}/bin/${TEST_TARGET}
        WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
    )

    add_custom_command(TARGET coverage
        COMMENT "Disable coverage build"
        COMMAND ${BULLSEYE_COV_ENABLE} --off --verbose --no-banner 
        WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
    )

    add_custom_command(TARGET coverage
        COMMENT "Export as XML"
        COMMAND ${BULLSEYE_COV_XML} -f ${COVERAGE_WORKING_DIR}/${COVERAGE_RAW_FILE} --output ${COVERAGE_WORKING_DIR}/coveragereport.xml
        WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
    )

    add_custom_command(TARGET coverage
        COMMENT "Export as HTML"
        COMMAND ${BULLSEYE_COV_HTML}  --no-banner --verbose --file ${COVERAGE_WORKING_DIR}/${COVERAGE_RAW_FILE}
        WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
    )

    add_custom_command(TARGET coverage
        COMMAND echo "Open ${COVERAGE_WORKING_DIR}/index.html to view the coverage analysis results."
        WORKING_DIRECTORY ${COVERAGE_WORKING_DIR}
    )
    
endfunction()
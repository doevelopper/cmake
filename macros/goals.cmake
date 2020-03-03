#[[
      CMakeLists.txt

          ┆  Copyright (c) 2014-2018 A.H.L

       Permission is hereby granted, free of charge, to any person obtaining
       a copy of this software and associated documentation files (the
       "Software"), to deal in the Software without restriction, including
       without limitation the rights to use, copy, modify, merge, publish,
       distribute, sublicense, and/or sell copies of the Software, and to
       permit persons to whom the Software is furnished to do so, subject to
       the following conditions:

       The above copyright notice and this permission notice shall be
       included in all copies or substantial portions of the Software.

       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
       MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
       NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
       LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
       OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
       WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

#if(NOT TARGET ${PROJECT_NAME}-${BUILD_TYPE})
#    add_custom_target(${PROJECT_NAME}-${BUILD_TYPE}
#        COMMAND
#            ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ${CMAKE_SOURCE_DIR}
#        WORKING_DIRECTORY
#            ${CMAKE_SOURCE_DIR}/build-${CMAKE_BUILD_TYPE} #${PROJECT_SOURCE_DIR} vs ${CMAKE_SOURCE_DIR}
#        COMMAND
#            ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build-${CMAKE_BUILD_TYPE}
#        COMMENT
#            "Switch CMAKE_BUILD_TYPE to ${BUILD_TYPE}. Building  ${BUILD_TYPE} application"
#    )
#endif()
#[[

** ...Start
** ...Update
** ...Configure
** ...Build
** ...Submit
** ...Test
** ...Coverage
** ...MemCheck
** ...Submit
]]

# Build goals added hire are an adaptation for maven build licyle
# https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html
# common default goals name between maven and make

if(NOT TARGET rmproper)
    add_custom_target(rmproper
        COMMAND :
        COMMENT "Remove all files generated by the previous build."
    )

    add_custom_command(TARGET rmproper
        PRE_BUILD
        COMMAND :
        COMMENT "Execute processes needed prior to the actual project cleaning."
    )

    add_custom_command(TARGET rmproper
        POST_BUILD
        COMMAND :
		# COMMAND rm -vf ${CMAKE_SOURCE_DIR}/*.log
		# COMMAND rm -vf ${CMAKE_SOURCE_DIR}/Makefile
		# COMMAND rm -vf ${CMAKE_SOURCE_DIR}/install_manifest.txt
		# COMMAND rm -vf ${CMAKE_SOURCE_DIR}/cmake_install.cmake
		# COMMAND find ${CMAKE_SOURCE_DIR} -type f -name CMakeCache.txt | xargs -r rm -vf
		# COMMAND find ${CMAKE_SOURCE_DIR} -type d -name CMakeFiles | xargs -r rm -rvf
		# COMMAND find ${CMAKE_SOURCE_DIR} -type f -name "*.marks" | xargs -r rm -vf
		# COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target clean
		# COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target rmdotdiles
		# COMMAND ${CMAKE_COMMAND} -E remove_directory CMakeFiles
		# COMMAND ${CMAKE_COMMAND} -E remove CMakeCache.txt cmake_install.cmake Makefile
		# WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Execute processes needed to finalize the project cleaning."
    )
endif()


if(NOT TARGET style)
    add_custom_target(style
        COMMAND :
        COMMENT "Prettying source code with uncrustify"
    )
endif()

if(NOT TARGET cyclomatic)
    add_custom_target(cyclomatic
        COMMAND :
        COMMENT "Cyclomatic Complexity Analyzer."
    )
endif()

# if(NOT TARGET cppcheck)
    # add_custom_target(cppcheck
        # COMMAND :
        # COMMENT "Static code analysis."
        ## DEPENDS linter
    # )
# endif()

# if(NOT TARGET linter)
    # add_custom_target(linter
        # COMMAND :
        # COMMENT "Check the C++ source code to analyze it for syntax errors and other faults."
        ##DEPENDS cyclomatic
    # )
# endif()

if(NOT TARGET site)
    add_custom_target(site
        COMMAND :
        COMMENT "Generate the project's site documentation."
    )
    add_custom_command(TARGET site
        PRE_BUILD
        COMMAND :
        COMMENT "Execute processes needed prior to the actual project site generation."
    )

    add_custom_command(TARGET site
        POST_BUILD
        COMMAND :
        COMMENT "Execute processes needed to finalize the site generation, and to prepare for site deployment."
    )
endif()

if(NOT TARGET site-deploy)
    add_custom_target(site-deploy
        COMMAND :
        COMMENT "Deploy the generated site documentation to the specified web server."
        # DEPENDS site
    )
endif()

if(NOT TARGET compile)
    add_custom_target(compile
        COMMAND :
        COMMENT "Compile the source code of the project."
    )
endif()

if(NOT TARGET test-compile)
    add_custom_target(test-compile
        COMMAND :
        COMMENT "Compile the test source code into the test destination directory."
    )

    add_custom_command(TARGET test-compile
        #COMMAND LD_LIBRARY_PATH=${ROOT_LIBRARY_DIR} ROOTSYS=${ROOTSYS} make
        POST_BUILD
        COMMAND
            ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin/conf
        COMMAND
            ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin/logs
        COMMAND
            ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SOURCE_DIR}/src/main/resources/configs/log4cxx.xml ${CMAKE_INSTALL_PREFIX}/bin/conf
        COMMENT
            "Copy of files nessesary for application runtime"
	)
endif()

if(NOT TARGET unit-test)
    add_custom_target(unit-test test
        COMMAND :
        COMMENT "Run tests using a suitable unit testing framework. These tests should not require the code be packaged or deployed."
        # DEPENDS test-compile
    )
endif()


if(NOT TARGET pack)
    add_custom_target(pack
        COMMAND :
        COMMENT "Take the compiled code and package it in its distributable format, such as a ZIP."
        # DEPENDS unit-test
    )

    add_custom_command(TARGET pack
        PRE_BUILD
        COMMAND :
        COMMENT "Perform any operations necessary to prepare a package before the actual packaging."
    )
endif()

if(NOT TARGET integration-test)
    add_custom_target(integration-test
        COMMAND :
        COMMENT "Process and deploy the package if necessary into an environment where integration tests can be run."
        # DEPENDS pack
    )

    add_custom_command(TARGET integration-test
        PRE_BUILD
        COMMAND :
        COMMENT "Perform actions required before integration tests are executed. This may involve things such as setting up the required environment."
    )

    add_custom_command(TARGET integration-test
        POST_BUILD
        COMMAND :
        COMMENT "Perform actions required after integration tests have been executed. This may including cleaning up the environment."
    )
endif()

# add_dependencies(integration-test pack)

if(NOT TARGET verify)
    add_custom_target(verify
        COMMAND :
        COMMENT "Rrun any checks to verify the package is valid and meets quality criteria."
        # DEPENDS integration-test
    )
endif()

if(NOT TARGET do-install)
    add_custom_target( do-install
        COMMAND :
        COMMENT "Install the package into the local repository, for use as a dependency in other projects locally."
        # DEPENDS verify
    )
endif()

if(NOT TARGET deploy)
    add_custom_target( deploy
        COMMAND :
        COMMENT "Integration or release environment, copies the final package to the remote repository for sharing with other developers and projects."
        # DEPENDS verify
    )
endif()

# ___

# if(NOT TARGET ${PROJECT_NAME}-process-test-classes)
    # add_custom_target(${PROJECT_NAME}-process-test-classes
        # COMMENT "Post-process the generated files from test compilation."
        # DEPENDS ${PROJECT_NAME}-test-compile
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-validate)
    # add_custom_target(${PROJECT_NAME}-validate
        # COMMENT "Validate the project is correct and all necessary information is available."
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-initialize)
    # add_custom_target(${PROJECT_NAME}-initialize
        # COMMENT "Initialize build state, e.g. set properties or create directories."
        # DEPENDS ${PROJECT_NAME}-validate
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-generate-sources)
    # add_custom_target(${PROJECT_NAME}-generate-sources
        # COMMENT "Generate any source code for inclusion in compilation."
        # DEPENDS ${PROJECT_NAME}-initialize
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-process-sources)
    # add_custom_target(${PROJECT_NAME}-process-sources
        # COMMENT "Process the source code, for example to filter any values."
        # DEPENDS ${PROJECT_NAME}-generate-sources
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-generate-resources)
    # add_custom_target(${PROJECT_NAME}-generate-resources
        # COMMENT "Generate resources for inclusion in the package."
        # DEPENDS ${PROJECT_NAME}-process-sources
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-process-resources)
    # add_custom_target(${PROJECT_NAME}-process-resources
        # COMMENT "Copy and process the resources into the destination directory, ready for packaging."
        # DEPENDS ${PROJECT_NAME}-generate-resources
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-process-classes)
    # add_custom_target(${PROJECT_NAME}-process-classes
        # COMMENT "Post-process the generated files from compilation."
        # DEPENDS ${PROJECT_NAME}-compile
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-generate-test-sources)
    # add_custom_target(${PROJECT_NAME}-generate-test-sources
        # COMMENT "Generate any test source code for inclusion in compilation."
        # DEPENDS ${PROJECT_NAME}-process-classes
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-process-test-sources)
    # add_custom_target(${PROJECT_NAME}-process-test-sources
        # COMMENT "Process the test source code, for example to filter any values."
        # DEPENDS ${PROJECT_NAME}-generate-test-sources
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-generate-test-resources)
    # add_custom_target(${PROJECT_NAME}-generate-test-resources
        # COMMENT "Create resources for testing."
        # DEPENDS ${PROJECT_NAME}-process-test-sources
    # )
# endif()

# if(NOT TARGET ${PROJECT_NAME}-process-test-resources)
    # add_custom_target(${PROJECT_NAME}-process-test-resources
        # COMMENT "Copy and process the resources into the test destination directory."
        # DEPENDS ${PROJECT_NAME}-generate-test-resources
    # )
# endif()

# if(NOT TARGET run-test)
    # add_custom_target(run-test
        # COMMAND :
        # COMMENT "Run tests using a suitable unit testing framework. These tests should not require the code be packaged or deployed."
        # DEPENDS test-compile
    # )
    # add_custom_command(TARGET run-test
        ##COMMAND LD_LIBRARY_PATH=${ROOT_LIBRARY_DIR} ROOTSYS=${ROOTSYS} make
        # PRE_BUILD
        # COMMAND
            # ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin/conf
        # COMMAND
            # ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin/logs
        # COMMAND
            # ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SOURCE_DIR}/src/main/resources/configs/log4cxx.xml ${CMAKE_INSTALL_PREFIX}/bin/conf
        # COMMENT
            # "Copy of files nessesary for application runtime"
    # )
# endif()

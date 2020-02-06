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

set(FEATURE_TEST_FORMAT --format progress)  #--format pretty OR --format pretty --tags @wip OR ...
set(FEATURE_TEST_OPTION --backtrace --format html --color)

find_program(CUCUMBER_RUBY cucumber
	DOC "Features testing tools"
)

function(add_feature_test_command TARGET_NAME BASE_DIRECTORY)
	if(CUCUMBER_RUBY)
		add_custom_command(TARGET ${TARGET_NAME}

			POST_BUILD

			COMMAND
				${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/qa/atp

			COMMAND
			   ${TARGET_NAME} --port 3902  >/dev/null &

			COMMAND
				${CUCUMBER_RUBY} ${FEATURE_TEST_FORMAT} ${FEATURE_TEST_OPTION}
					--out ${CMAKE_INSTALL_PREFIX}/qa/atp/${TARGET_NAME}.feature-tests-report.html
					--strict ${BASE_DIRECTORY}/features

			COMMAND
				# kill -9 $(lsof -t -i:3902 -sTCP:LISTEN)
				# kill -9 $(lsof -i:3902 -t) 2> /dev/null
				lsof -ti tcp:3902 | xargs kill

			WORKING_DIRECTORY
				#${CMAKE_CURRENT_SOURCE_DIR}
				${BASE_DIRECTORY}

			COMMENT
			    "Run ${TARGET_NAME} integration test."
		)

    else(CUCUMBER_RUBY)

        add_custom_command( TARGET ${TARGET_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] Integration test"
        )

    endif(CUCUMBER_RUBY)
	add_dependencies( integration-test ${TARGET_NAME})
endfunction()

function(add_feature_test_target TARGET_NAME BASE_DIRECTORY)

	if(CUCUMBER_RUBY)
		add_custom_target(${TARGET_NAME}.integration-test
			COMMAND
				${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/qa/atp
			COMMAND
				${TARGET_NAME}.it-test.steps --port 3902  >/dev/null &

			COMMAND
				 ${CUCUMBER_RUBY} ${FEATURE_TEST_FORMAT} ${FEATURE_TEST_OPTION}
					--out ${CMAKE_INSTALL_PREFIX}/qa/atp/${TARGET_NAME}.feature-tests-report.html
					--strict ${BASE_DIRECTORY}/features

			WORKING_DIRECTORY
				${BASE_DIRECTORY}

			COMMENT
				"Run ${TARGET_NAME} integration test."
		)

		add_custom_command(TARGET ${TARGET_NAME}
			POST_BUILD
			COMMAND
				# kill -9 $(lsof -t -i:3902 -sTCP:LISTEN)  ## best
				lsof -ti tcp:3902 | xargs kill
			COMMENT
				"Killing process to close cucumber wire port. (bind: Address already in use)"
		)
		#        fuser -k -n  tcp 3902 || true # kill -9 *.Seps which is using port 3902
		#        iptables -I INPUT -p tcp --dport 3902 -j DROP ;# need to be root for this command
		# 	check pro opened lsof -i -P -n | grep LISTEN

    else(CUCUMBER_RUBY)

        add_custom_target( ${TARGET_NAME}.integration-test
            COMMAND ${CMAKE_COMMAND} -E echo "[---SKIPPED---] Integration test"
        )

    endif(CUCUMBER_RUBY)

	add_dependencies( integration-test ${TARGET_NAME}.integration-test)

endfunction()


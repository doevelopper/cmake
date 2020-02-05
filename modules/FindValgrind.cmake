find_program(MEMORYCHECK_COMMAND NAMES valgrind 
    PATH /usr/bin /usr/local/bin 
)

set(MEMORYCHECK_COMMAND_OPTIONS 
	--trace-children=yes 
	--leak-check=full 
	--error-exitcode=1 
	--suppressions=${CMAKE_CURRENT_SOURCE_DIR}/../valgrind.supp
)

include( FindPackageHandleStandardArgs)
find_package_handle_standard_args(VALGRIND 
    DEFAULT_MSG
    MEMORYCHECK_COMMAND 
)


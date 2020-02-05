
# Installation
# wget http://downloads.sourceforge.net/project/expat/expat/2.0.1/expat-2.0.1.tar.gz
# tar -xvf expat-2.0.1.tar.gz
# cd expat-2.0.1
# ./configure && make && sudo make install

# wget https://rough-auditing-tool-for-security.googlecode.com/files/rats-2.4.tgz
# tar -xzvf rats-2.4.tgz
# cd rats-2.4
# ./configure && make && sudo make install
# ./rats

# Basic run : rats --resultsonly <path_to_source_directory>
# Advanced config: rats --quiet --xml -w 3 <path_to_source_directory>
#     --xml, --html generate output in the specified format
#     -w <1,[2],3> set the warning level:
#      1 will only include high level warnings (i.e. less false positives,
#               but more false negatives)),
#      2 is the medium and default option,
#      3 will produce more output and miss less vulnerabilities, but might also report many false positives.


set (RATS_OPTIONS
    --quiet --xml
)

find_program(RATS rats)

function(add_rats_command target_name bin_folder)

    set(WORKING_DIR "${CMAKE_INSTALL_PREFIX}/qa/audit/${target_name}")
    add_custom_command(TARGET ${target_name}
        PRE_BUILD
        COMMAND
            ${RATS} ${RATS_OPTIONS}  > ${WORKING_DIR}/rats.xml
        COMMENT "The Rough Auditing Tool for Security output report to ${WORKING_DIR}/rats.xml" VERBATIM
    )
endfunction(add_rats_command)

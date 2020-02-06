# Copyright (c) 2011-2014 Stefan Eilemann <eile@eyescale.ch>

# Sets the following variables if git is found:
# GIT_REVISION: The current HEAD sha hash
# GIT_STATE: A description of the working tree, e.g., 1.8.0-48-g6d23f80-dirty
# GIT_ORIGIN_URL: The origin of the working tree
# GIT_ROOT_URL: The root remote of the working tree
# GIT_BRANCH: The name of the current branch
# GIT_AUTHORS: A list of all authors in the git history

if(GIT_INFO_DONE_${PROJECT_NAME})
    return()
endif()

set(GIT_INFO_DONE_${PROJECT_NAME} ON)
set(GIT_REVISION "0")
set(GIT_STATE)
set(GIT_ORIGIN_URL)
set(GIT_ROOT_URL)
set(GIT_BRANCH)

if(EXISTS ${PROJECT_SOURCE_DIR}/.git)
    if(NOT GIT_FOUND)
        find_package(Git QUIET)
    endif()
    if(GIT_FOUND)
        execute_process( COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
                         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                         OUTPUT_VARIABLE GIT_REVISION OUTPUT_STRIP_TRAILING_WHITESPACE)

        execute_process( COMMAND "${GIT_EXECUTABLE}" describe --long --tags --dirty --always
                         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                         OUTPUT_VARIABLE GIT_STATE OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)
        execute_process( COMMAND "${GIT_EXECUTABLE}" config --get remote.origin.url
                         OUTPUT_VARIABLE GIT_ORIGIN_URL OUTPUT_STRIP_TRAILING_WHITESPACE
                         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
        execute_process( COMMAND "${GIT_EXECUTABLE}" config --get remote.root.url
                         OUTPUT_VARIABLE GIT_ROOT_URL OUTPUT_STRIP_TRAILING_WHITESPACE
                         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
        execute_process( COMMAND "${GIT_EXECUTABLE}" branch --contains HEAD
                         OUTPUT_VARIABLE GIT_BRANCH OUTPUT_STRIP_TRAILING_WHITESPACE
                         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

        if(EXISTS ${PROJECT_BINARY_DIR}/Authors.txt)
                 file(READ ${PROJECT_BINARY_DIR}/Authors.txt GIT_AUTHORS)
        else()
        # cache authors to not slow down cmake runs
            set(GIT_AUTHORS)
            execute_process(COMMAND "${GIT_EXECUTABLE}" log
                            OUTPUT_VARIABLE GIT_LOG OUTPUT_STRIP_TRAILING_WHITESPACE
                            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
                            string(REPLACE "\n" ";" GIT_LOG ${GIT_LOG})
            foreach(__line ${GIT_LOG})
                if(__line MATCHES "^Author:")
                    string(REPLACE "Author: " "" __line "${__line}")
                    string(REGEX REPLACE "[ ]?<.*" "" __line "${__line}")
                    list(APPEND GIT_AUTHORS "${__line}")
                endif()
            endforeach()
            list(SORT GIT_AUTHORS)
            list(REMOVE_DUPLICATES GIT_AUTHORS)
            file(WRITE ${PROJECT_BINARY_DIR}/Authors.txt "${GIT_AUTHORS}")
        endif()

        if(NOT GIT_REVISION)
            set(GIT_REVISION "0")
        endif()
        if(NOT GIT_ROOT_URL)
            set(GIT_ROOT_URL ${GIT_ORIGIN_URL})
        endif()
        if(NOT GIT_STATE)
            set(GIT_STATE "<no-tag>")
        endif()
        string(REPLACE "* " "" GIT_BRANCH ${GIT_BRANCH})

    else()
        message(STATUS "No revision version support, git not found")
    endif()
endif()


#  GIT_WC_INFO(<dir> <var-prefix>)
# is defined to extract information of a git working copy at
# a given location.
#
# The macro defines the following variables:
#  <var-prefix>_WC_REVISION_HASH - Current SHA1 hash
#  <var-prefix>_WC_REVISION - Current SHA1 hash
#  <var-prefix>_WC_REVISION_NAME - Name associated with <var-prefix>_WC_REVISION_HASH
#  <var-prefix>_WC_URL - output of command `git config --get remote.origin.url'
#  <var-prefix>_WC_ROOT - Same value as working copy URL
#  <var-prefix>_WC_LAST_CHANGED_DATE - date of last commit
#  <var-prefix>_WC_GITSVN - Set to false
#  <var-prefix>_WC_LATEST_TAG - Latest tag found in history
#  <var-prefix>_WC_LATEST_TAG_LONG - <last tag>-<commits since then>-g<actual commit hash>

if(GIT_FOUND)
  execute_process(COMMAND ${GIT_EXECUTABLE} --version
                  OUTPUT_VARIABLE git_version
                  ERROR_QUIET
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  if (git_version MATCHES "^git version [0-9]")
    string(REPLACE "git version " "" GIT_VERSION_STRING "${git_version}")
  endif()
  unset(git_version)

  macro(GIT_WC_INFO dir prefix)
    execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --verify -q --short=7 HEAD
       WORKING_DIRECTORY ${dir}
       ERROR_VARIABLE GIT_error
       OUTPUT_VARIABLE ${prefix}_WC_REVISION_HASH
       OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(${prefix}_WC_REVISION ${${prefix}_WC_REVISION_HASH})
    if(NOT ${GIT_error} EQUAL 0)
      message(SEND_ERROR "Command \"${GIT_EXECUTBALE} rev-parse --verify -q --short=7 HEAD\" in directory ${dir} failed with output:\n${GIT_error}")
    else(NOT ${GIT_error} EQUAL 0)
      execute_process(COMMAND ${GIT_EXECUTABLE} name-rev ${${prefix}_WC_REVISION_HASH}
         WORKING_DIRECTORY ${dir}
         OUTPUT_VARIABLE ${prefix}_WC_REVISION_NAME
          OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif(NOT ${GIT_error} EQUAL 0)

    execute_process(COMMAND ${GIT_EXECUTABLE} config --get remote.origin.url
       WORKING_DIRECTORY ${dir}
       OUTPUT_VARIABLE ${prefix}_WC_URL
       OUTPUT_STRIP_TRAILING_WHITESPACE)

    execute_process(COMMAND ${GIT_EXECUTABLE} show -s --format="%ci" ${${prefix}_WC_REVISION_HASH}
       WORKING_DIRECTORY ${dir}
       OUTPUT_VARIABLE ${prefix}_show_output
       OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX REPLACE "^([0-9][0-9][0-9][0-9]\\-[0-9][0-9]\\-[0-9][0-9]).*"
      "\\1" ${prefix}_WC_LAST_CHANGED_DATE "${${prefix}_show_output}")

    execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=0
       WORKING_DIRECTORY ${dir}
       OUTPUT_VARIABLE ${prefix}_WC_LATEST_TAG
       OUTPUT_STRIP_TRAILING_WHITESPACE
       ERROR_QUIET)
    execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags
       WORKING_DIRECTORY ${dir}
       OUTPUT_VARIABLE ${prefix}_WC_LATEST_TAG_LONG
       OUTPUT_STRIP_TRAILING_WHITESPACE
       ERROR_QUIET)

    set(${prefix}_WC_GITSVN False)

    # Check if this git is likely to be a git-svn repository
    execute_process(COMMAND ${GIT_EXECUTABLE} config --get-regexp "^svn-remote"
      WORKING_DIRECTORY ${dir}
      OUTPUT_VARIABLE git_config_output
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )

    if(NOT "${git_config_output}" STREQUAL "")
      # In case git-svn is used, attempt to extract svn info
      execute_process(COMMAND ${GIT_EXECUTABLE} svn info
        WORKING_DIRECTORY ${dir}
        TIMEOUT 3
        ERROR_VARIABLE git_svn_info_error
        OUTPUT_VARIABLE ${prefix}_WC_INFO
        RESULT_VARIABLE git_svn_info_result
        OUTPUT_STRIP_TRAILING_WHITESPACE)

      if(${git_svn_info_result} EQUAL 0)
        set(${prefix}_WC_GITSVN True)
        string(REGEX REPLACE "^(.*\n)?URL: ([^\n]+).*"
          "\\2" ${prefix}_WC_URL "${${prefix}_WC_INFO}")
        string(REGEX REPLACE "^(.*\n)?Revision: ([^\n]+).*"
          "\\2" ${prefix}_WC_REVISION "${${prefix}_WC_INFO}")
        string(REGEX REPLACE "^(.*\n)?Repository Root: ([^\n]+).*"
          "\\2" ${prefix}_WC_ROOT "${${prefix}_WC_INFO}")
        string(REGEX REPLACE "^(.*\n)?Last Changed Author: ([^\n]+).*"
          "\\2" ${prefix}_WC_LAST_CHANGED_AUTHOR "${${prefix}_WC_INFO}")
        string(REGEX REPLACE "^(.*\n)?Last Changed Rev: ([^\n]+).*"
          "\\2" ${prefix}_WC_LAST_CHANGED_REV "${${prefix}_WC_INFO}")
        string(REGEX REPLACE "^(.*\n)?Last Changed Date: ([^\n]+).*"
          "\\2" ${prefix}_WC_LAST_CHANGED_DATE "${${prefix}_WC_INFO}")
      endif(${git_svn_info_result} EQUAL 0)
    endif(NOT "${git_config_output}" STREQUAL "")

    # If there is no 'remote.origin', default to "NA" value and print a warning message.
    if(NOT ${prefix}_WC_URL)
      message(WARNING "No remote origin set for git repository: ${dir}" )
      set( ${prefix}_WC_URL "NA" )
    else()
      set(${prefix}_WC_ROOT ${${prefix}_WC_URL})
    endif()

  endmacro(GIT_WC_INFO)
endif(GIT_FOUND)
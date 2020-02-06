#
# summary()
#
# Emit a summary of the build options, etc.
#

macro(SHOWFLAG flag)
  message(STATUS "${flag} = ${${flag}}")
endmacro(SHOWFLAG)
#SHOWFLAG("CMAKE_C_COMPILER_ID")
#SHOWFLAG("CMAKE_CXX_COMPILER_ID")
#SHOWFLAG("CMAKE_COMPILER_IS_GNUCC")
#SHOWFLAG("CMAKE_COMPILER_IS_GNUCXX")
function(summary)
    if (BUILD_SHARED_LIBS)
        set(LINK_STRATEGY "Shared")
    else()
        set(LINK_STRATEGY "Static")
    endif()

    message(STATUS "")
    message(STATUS "Configuration Summary for ${PROJECT_NAME}:")
    message(STATUS "")
    message(STATUS "  APR2_FOUND           ${APR2_FOUND}")
    message(STATUS "  APR2_INCLUDE_DIRS    ${APR2_INCLUDE_DIRS}")
    message(STATUS "  APR2_LIBRARIES       ${APR2_LIBRARIES}")
    message(STATUS "")
    message(STATUS "  PROJECT_DESCRIPTION  ${PROJECT_DESCRIPTION}")
    message(STATUS "  PROJECT_NAME         ${PROJECT_NAME}")
    message(STATUS "  PROJECT_LICENSE      ${PROJECT_LICENSE}")
    message(STATUS "  PROJECT_LICURL       ${PROJECT_LICURL}")
    message(STATUS "  PROJECT_URL          ${PROJECT_URL}")
    message(STATUS "  PROJECT_VERSION      ${PROJECT_VERSION}")
    message(STATUS "")
    message(STATUS "  Build Type           ${CMAKE_BUILD_TYPE}")
    message(STATUS "  Install Prefix       ${CMAKE_INSTALL_PREFIX}")
    message(STATUS "  Language Level       ${CXX_LANGUAGE_LEVEL}")
    message(STATUS "  Link Strategy        ${LINK_STRATEGY}${MSVCRT_STRATEGY}")
    message(STATUS "")

# Uncomment to dump all variables out to console    
# include (NewPlatformDebug)

endfunction()

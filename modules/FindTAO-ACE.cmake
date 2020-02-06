set(ENV{ACE_ROOT} ${CMAKE_CURRENT_DIR}....) #work arround to  avoid seeting env by hand

SET (TAO_FOUND TRUE)
SET (TAO_LIBRARIES "")
SET (TAO_INCLUDE_DIRS "")
SET (TAO_DEFINITIONS "")

IF (NOT ACE_ROOT)
    # See if ACE_ROOT is set in process environment
    IF ( NOT $ENV{ACE_ROOT} STREQUAL "" )
        SET (ACE_ROOT "$ENV{ACE_ROOT}")
	MESSAGE(STATUS "Detected ACE_ROOT set to '${ACE_ROOT}'")
    ENDIF ()
ENDIF ()

# If ACE_ROOT is available, set up our hints
IF (ACE_ROOT)
    SET (ACE_INCLUDE_HINTS HINTS "${ACE_ROOT}/include" "${ACE_ROOT}")
    SET (ACE_LIBRARY_HINTS HINTS "${ACE_ROOT}/lib")
ENDIF ()

find_path(ACE_INCLUDE_DIR NAMES ace/ACE.h ${ACE_INCLUDE_HINTS}
)

find_library(ACE_LIBRARY NAMES ACE ${ACE_LIBRARY_HINTS}
)


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ACE DEFAULT_MSG ACE_LIBRARY ACE_INCLUDE_DIR)

# Advanced options for not cluttering the cmake UIs
mark_as_advanced(ACE_INCLUDE_DIR ACE_LIBRARY)


IF (ACE_FOUND)
    LIST (APPEND TAO_FOUND_COMPONENTS "ACE")
    LIST (APPEND TAO_LIBRARIES ${ACE_LIBRARIES})
    LIST (APPEND TAO_INCLUDE_DIRS ${ACE_INCLUDE_DIR})
    SET (TAO_DEFINITIONS ${ACE_DEFINITIONS} "-D_REENTRANT")
    list (APPEND TAO_CLIENT_LIBRARIES  ${ACE_LIBRARIES})
ELSE ()
    LIST (APPEND TAO_MISSING_COMPONENTS "ACE")
    SET (TAO_FOUND FALSE)
ENDIF ()


IF (NOT TAO_ROOT)
    # See if TAO_ROOT is set in process environment
    IF ( NOT $ENV{TAO_ROOT} STREQUAL "" )
        SET (TAO_ROOT "$ENV{TAO_ROOT}")
	MESSAGE(STATUS "Detected TAO_ROOT set to '${TAO_ROOT}'")
    # If ACE_ROOT is set, maybe TAO is there too
    ELSEIF (ACE_ROOT)
        SET (TAO_ROOT "${ACE_ROOT}")
	MESSAGE(STATUS "Set TAO_ROOT to '${TAO_ROOT}'")
    ENDIF ()
ENDIF ()

IF (TAO_ROOT)
    SET (TAO_INCLUDE_HINTS HINTS "${TAO_ROOT}/include" "${TAO_ROOT}/TAO" "${TAO_ROOT}")
    SET (TAO_LIBRARY_HINTS HINTS "${TAO_ROOT}/lib" "${ACE_ROOT}/lib")
    SET (TAO_RUNTIME_HINTS HINTS "${TAO_ROOT}/bin" "${ACE_ROOT}/bin")
ENDIF ()

find_path(TAO_INCLUDE_DIR NAMES "tao/corba.h" ${TAO_INCLUDE_HINTS}
)

find_library (TAO_LIBRARY NAMES TAO ${TAO_LIBRARY_HINTS}
)


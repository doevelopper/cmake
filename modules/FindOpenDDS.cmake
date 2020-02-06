#.rst:
# FindOpenDDS
# -------
#
# This module attempts to finds OpenDDS.
#
# It defines the following variables:
#
# * OpenDDS_FOUND                - True if OpenDDS was found
# * OpenDDS_INCLUDE_DIRS
# * OpenDDS_LIBRARY_DIRS
# * OpenDDS_LIBRARIES
# * OpenDDS_TAO_IDL_EXECUTABLE
# * OpenDDS_IDL_EXECUTABLE
# * OpenDDS_ROOT_DIR
# * OpenDDS_FLAGS
# * OpenDDS_TAO_FLAGS
#
# Provides following function to compile idl files:
# * dds_compile_idl(<file-list> <output-variable;generated_source_files> <output-variable;generated_header_files> )


# debug:
# set(CMAKE_VERBOSE_MAKEFILE on)

function(FindOpenDDS)
    # find IDL compilers
    find_program(_tao_idl "tao_idl")
    find_program(_opendds_idl "opendds_idl")
    if (_tao_idl AND _opendds_idl)
        # export variables
        set(OpenDDS_IDL_EXECUTABLE ${_opendds_idl} PARENT_SCOPE)
        set(OpenDDS_TAO_IDL_EXECUTABLE ${_tao_idl} PARENT_SCOPE)
        set(_FOUND TRUE)

        if(NOT OpenDDS_FIND_QUIETLY)
              message("OpenDDS found")
        endif()

    else(OPENDDS_IDL_COMMAND_)
        set(_FOUND FALSE)

        if(NOT OpenDDS_FIND_QUIETLY)
            message(WARNING "OpenDDS not found")
        endif()
    endif()

    # export variables
    set(OpenDDS_FOUND ${_FOUND} PARENT_SCOPE)

    if (_FOUND)
       # export variables
       set(_tao_flags "")
       list(APPEND _tao_flags "-I$ENV{TAO_ROOT}")
       list(APPEND _tao_flags "-I$ENV{DDS_ROOT}")
       list(APPEND _tao_flags "-I.")
       list(APPEND _tao_flags "-Wb,pre_include=ace/pre.h")
       list(APPEND _tao_flags "-Wb,post_include=ace/post.h")
       list(APPEND _tao_flags "-Sa")
       list(APPEND _tao_flags "-St")

       set(_opendds_flags "")
       list(APPEND _opendds_flags "-Lspcpp")
       list(APPEND _opendds_flags "-I$ENV{DDS_ROOT}")
       list(APPEND _opendds_flags "-I.")
       list(APPEND _opendds_flags "-Sa")
       list(APPEND _opendds_flags "-St")

       set(OpenDDS_FLAGS "${_opendds_flags}" PARENT_SCOPE)
       set(OpenDDS_TAO_FLAGS "${_tao_flags}" PARENT_SCOPE)
       set(OpenDDS_ROOT_DIR $ENV{DDS_ROOT} PARENT_SCOPE)

       set(_include_dirs "")
       list(APPEND _include_dirs $ENV{DDS_ROOT})
       list(APPEND _include_dirs $ENV{ACE_ROOT})
       list(APPEND _include_dirs $ENV{TAO_ROOT})
       set(OpenDDS_INCLUDE_DIRS ${_include_dirs} PARENT_SCOPE)

       set(_library_dirs "")
       list(APPEND _library_dirs $ENV{DDS_ROOT}/lib)
       list(APPEND _library_dirs $ENV{ACE_ROOT}/lib)
       list(APPEND _library_dirs $ENV{TAO_ROOT}/lib)
       set(OpenDDS_LIBRARY_DIRS ${_library_dirs} PARENT_SCOPE)

       set(_all_libs "")
       foreach(_lib_dir ${_library_dirs})
           file(GLOB _libs "${_lib_dir}/*.so")
           foreach(_lib ${_libs})
               list(APPEND _all_libs "${_lib}")
           endforeach(_lib)
      endforeach(_lib_dir)

      set(OpenDDS_LIBRARIES ${_all_libs} PARENT_SCOPE)

    endif()

endfunction()

FindOpenDDS()

function(dds_compile_idl idl_filenames generated_source_files generated_header_files)
	# abort if OpenDDS not found
	if (NOT OpenDDS_FOUND)
		message(FATAL_ERROR "OpenDDS not found")
	endif()

	set(_res_cpp "")
	set(_res_h "")
	foreach(filename ${idl_filenames})
		# split path
		# get_filename_component(filename_wd ${filename} NAME)
		get_filename_component(filename_we ${filename} NAME_WE)
		get_filename_component(filename_abs ${filename} ABSOLUTE)
		get_filename_component(directory ${filename_abs} DIRECTORY)

		# copy idl file to build directory to work on it
		configure_file(${filename} ${filename} COPYONLY)

		###### The OpenDDS IDL is first processed by the TAO IDL compiler.

		# construct tao_idl result filenames
		set( IDL_C_CPP "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}C.cpp" )
		set( IDL_C_H   "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}C.h" )
		set( IDL_C_INL "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}C.inl" )
		set( IDL_S_CPP "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}S.cpp" )
		set( IDL_S_H   "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}S.h" )

		# append result filenames
		list(APPEND _res_cpp ${IDL_C_CPP})
		list(APPEND _res_cpp ${IDL_S_CPP})
		list(APPEND _res_h   ${IDL_C_H})
		list(APPEND _res_h   ${IDL_C_INL})
		list(APPEND _res_h   ${IDL_S_H})

		# compile tao_idl
		add_custom_command(
			OUTPUT ${IDL_C_CPP} ${IDL_C_H} ${IDL_C_INL} ${IDL_S_CPP} ${IDL_S_H}
			DEPENDS ${filename}
			COMMAND ${OpenDDS_TAO_IDL_EXECUTABLE}
			ARGS ${OpenDDS_TAO_FLAGS} ${filename}
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		)

		###### In addition, we need to process the IDL file with the OpenDDS IDL compiler to generate the
		###### serialization and key support code that OpenDDS requires to marshal and demarshal the
		###### Message, as well as the type support code for the data readers and writers.

		# construct opendds_idl result filenames
		set( TYPE_SUPPORT_IDL "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupport.idl" )
		set( TYPE_SUPPORT_H   "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportImpl.h" )
		set( TYPE_SUPPORT_CPP "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportImpl.cpp" )
		# append result filenames
		list(APPEND _res_cpp ${TYPE_SUPPORT_CPP})
		list(APPEND _res_h ${TYPE_SUPPORT_H})
		list(APPEND _res_h ${TYPE_SUPPORT_IDL})

		set(res "${res};${TYPE_SUPPORT_IDL};${TYPE_SUPPORT_H};${TYPE_SUPPORT_CPP}")

		# compile opendds_idl
		add_custom_command(
			OUTPUT ${TYPE_SUPPORT_IDL} ${TYPE_SUPPORT_H} ${TYPE_SUPPORT_CPP}
			DEPENDS ${filename} ${IDL_C_CPP} ${IDL_C_H} ${IDL_C_INL} ${IDL_S_CPP} ${IDL_S_H}
			COMMAND ${OpenDDS_IDL_EXECUTABLE}
			ARGS ${OpenDDS_FLAGS} ${filename}
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		)

		###### The generated IDL file should itself be compiled with
		###### the TAO IDL compiler to generate stubs and skeletons

		# construct tao_idl result filenames
		set( TYPE_SUPPORT_IDL_C_CPP "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportC.cpp" )
		set( TYPE_SUPPORT_IDL_C_H   "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportC.h" )
		set( TYPE_SUPPORT_IDL_C_INL "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportC.inl" )
		set( TYPE_SUPPORT_IDL_S_CPP "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportS.cpp" )
		set( TYPE_SUPPORT_IDL_S_H   "${CMAKE_CURRENT_BINARY_DIR}/${filename_we}TypeSupportS.h" )

		# append result filenames
		list(APPEND _res_cpp ${TYPE_SUPPORT_IDL_C_CPP})
		list(APPEND _res_cpp ${TYPE_SUPPORT_IDL_S_CPP})
		list(APPEND _res_h   ${TYPE_SUPPORT_IDL_C_H})
		list(APPEND _res_h   ${TYPE_SUPPORT_IDL_C_INL})
		list(APPEND _res_h   ${TYPE_SUPPORT_IDL_S_H})

		# compile tao_idl
		add_custom_command(
			OUTPUT ${TYPE_SUPPORT_IDL_C_CPP} ${TYPE_SUPPORT_IDL_C_H} ${TYPE_SUPPORT_IDL_C_INL} ${TYPE_SUPPORT_IDL_S_CPP} ${TYPE_SUPPORT_IDL_S_H}
			DEPENDS ${TYPE_SUPPORT_IDL}
			COMMAND ${OpenDDS_TAO_IDL_EXECUTABLE}
			ARGS ${OpenDDS_TAO_FLAGS} ${TYPE_SUPPORT_IDL}
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		)

	endforeach(filename)

	# output result filenames
	set(${generated_source_files} ${_res_cpp} PARENT_SCOPE)
	set(${generated_header_files} ${_res_h} PARENT_SCOPE)

endfunction()


# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:

FindHDF5
---------

by Michael Hirsch www.scivision.dev

Finds HDF5 library for C, CXX, Fortran.


Result Variables
^^^^^^^^^^^^^^^^

``HDF5_FOUND``
  HDF5 libraries were found
``HDF5_INCLUDE_DIRS``
  HDF5 include directory
``HDF5_LIBRARIES``
  HDF5 library files

Components
==========

``C``

``CXX``

``Fortran``

The ``HL`` component is implied and silently accepted to keep
compatibility with factory FindHDF5


Targets
^^^^^^^

``HDF5::HDF5``
  HDF5 Imported Target
#]=======================================================================]

function(detect_config)

if(Fortran IN_LIST HDF5_FIND_COMPONENTS AND NOT HDF5_Fortran_FOUND)
  return()
endif()

if(CXX IN_LIST HDF5_FIND_COMPONENTS AND NOT HDF5_CXX_FOUND)
  return()
endif()

set(CMAKE_REQUIRED_INCLUDES ${HDF5_INCLUDE_DIR})

foreach(f H5pubconf.h H5pubconf-64.h)
  if(EXISTS ${HDF5_INCLUDE_DIR}/${f})
    set(_conf ${HDF5_INCLUDE_DIR}/${f})
    break()
  endif()
endforeach()

if(NOT _conf)
  message(WARNING "Could not find HDF5 config header H5pubconf.h, therefore cannot detect HDF5 configuration.")
  set(HDF5_C_FOUND false PARENT_SCOPE)
  return()
endif()

# get version
# from CMake/Modules/FindHDF5.cmake
include(CheckSymbolExists)
check_symbol_exists(H5_HAVE_FILTER_SZIP ${_conf} _szip)
check_symbol_exists(H5_HAVE_FILTER_DEFLATE ${_conf} _zlib)

file(STRINGS ${_conf} _def
REGEX "^[ \t]*#[ \t]*define[ \t]+H5_VERSION[ \t]+" )
if( "${_def}" MATCHES
"H5_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+)(-patch([0-9]+))?\"" )
  set(HDF5_VERSION "${CMAKE_MATCH_1}" )
  if( CMAKE_MATCH_3 )
    set(HDF5_VERSION ${HDF5_VERSION}.${CMAKE_MATCH_3})
  endif()

  set(HDF5_VERSION ${HDF5_VERSION} PARENT_SCOPE)
endif()

# this helps avoid picking up miniconda zlib over the desired zlib
get_filename_component(_hint ${HDF5_C_LIBRARY} DIRECTORY)
if(NOT ZLIB_ROOT)
  set(ZLIB_ROOT "${_hint}/..;${_hint}/../..")
endif()
if(NOT SZIP_ROOT)
  set(SZIP_ROOT "${ZLIB_ROOT}")
endif()

if(_zlib)
  find_package(ZLIB REQUIRED)

  if(_szip)
    # Szip even though not used by h5fortran.
    # If system HDF5 dynamically links libhdf5 with szip,
    # our builds will fail if we don't also link szip.
    # however, we don't require SZIP for this case as other HDF5 libraries may statically
    # link SZIP.
    find_package(SZIP)
    if(SZIP_FOUND)
      list(APPEND CMAKE_REQUIRED_LIBRARIES SZIP::SZIP)
    endif()
  endif()

  list(APPEND CMAKE_REQUIRED_LIBRARIES ZLIB::ZLIB)
endif()

list(APPEND CMAKE_REQUIRED_LIBRARIES ${CMAKE_DL_LIBS})

set(THREADS_PREFER_PTHREAD_FLAG true)
find_package(Threads)
if(Threads_FOUND)
  list(APPEND CMAKE_REQUIRED_LIBRARIES Threads::Threads)
endif()

if(UNIX)
  list(APPEND CMAKE_REQUIRED_LIBRARIES m)
endif()

set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} PARENT_SCOPE)

endfunction(detect_config)


# === main program

set(CMAKE_REQUIRED_LIBRARIES)
set(_lsuf hdf5 hdf5/serial)
set(_psuf static ${_lsuf})

# we don't use pkg-config directly because some distros pkg-config for HDF5 is broken
# however at least the paths are often correct
find_package(PkgConfig)
if(PkgConfig_FOUND AND NOT HDF5_C_LIBRARY)
  pkg_search_module(pc_hdf5 hdf5 hdf5-serial)
endif()

if(Fortran IN_LIST HDF5_FIND_COMPONENTS)
# NOTE: the "lib*" are for Windows Intel compiler, even for self-built HDF5.
# CMake won't look for lib prefix automatically.
  find_library(HDF5_Fortran_LIBRARY
    NAMES hdf5_fortran libhdf5_fortran
    HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
    PATH_SUFFIXES ${_lsuf}
    NAMES_PER_DIR
    DOC "HDF5 Fortran API")
  find_library(HDF5_Fortran_HL_LIBRARY
    NAMES hdf5_hl_fortran hdf5hl_fortran libhdf5_hl_fortran libhdf5hl_fortran
    HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
    PATH_SUFFIXES ${_lsuf}
    NAMES_PER_DIR
    DOC "HDF5 Fortran HL high-level API")

  find_library(HDF5_Fortran_HL_stub
    NAMES hdf5_hl_f90cstub libhdf5_hl_f90cstub
    HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
    PATH_SUFFIXES ${_lsuf}
    NAMES_PER_DIR
    DOC "Fortran C HL interface, not all HDF5 implementations have/need this")
  find_library(HDF5_Fortran_stub
    NAMES hdf5_f90cstub libhdf5_f90cstub
    HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
    PATH_SUFFIXES ${_lsuf}
    NAMES_PER_DIR
    DOC "Fortran C interface, not all HDF5 implementations have/need this")

  set(HDF5_Fortran_LIBRARIES ${HDF5_Fortran_HL_LIBRARY} ${HDF5_Fortran_LIBRARY})
  if(HDF5_Fortran_HL_stub AND HDF5_Fortran_stub)
    list(APPEND HDF5_Fortran_LIBRARIES ${HDF5_Fortran_HL_stub} ${HDF5_Fortran_stub})
  endif()

  find_path(HDF5_Fortran_INCLUDE_DIR
    NAMES hdf5.mod
    HINTS ${pc_hdf5_INCLUDE_DIRS}
    PATH_SUFFIXES ${_psuf}
    DOC "HDF5 Fortran modules")

  if(HDF5_Fortran_HL_LIBRARY AND HDF5_Fortran_LIBRARY AND HDF5_Fortran_INCLUDE_DIR)
    list(APPEND CMAKE_REQUIRED_LIBRARIES ${HDF5_Fortran_LIBRARIES})
    set(HDF5_Fortran_FOUND true)
    set(HDF5_HL_FOUND true)
  endif()
endif()


if(CXX IN_LIST HDF5_FIND_COMPONENTS)
  find_library(HDF5_CXX_LIBRARY
    NAMES hdf5_cpp libhdf5_cpp
    HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
    PATH_SUFFIXES ${_lsuf}
    NAMES_PER_DIR
    DOC "HDF5 C++ API")
  find_library(HDF5_CXX_HL_LIBRARY
    NAMES hdf5_hl_cpp libhdf5_hl_cpp
    HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
    PATH_SUFFIXES ${_lsuf}
    NAMES_PER_DIR
    DOC "HDF5 C++ high-level API")

  set(HDF5_CXX_LIBRARIES ${HDF5_CXX_HL_LIBRARY} ${HDF5_CXX_LIBRARY})

  if(HDF5_CXX_HL_LIBRARY AND HDF5_CXX_LIBRARY)
    set(HDF5_CXX_FOUND true)
    set(HDF5_HL_FOUND true)
  endif()
endif()

# C is always needed
find_library(HDF5_C_LIBRARY
  NAMES hdf5 libhdf5
  HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
  PATH_SUFFIXES ${_lsuf}
  NAMES_PER_DIR
  DOC "HDF5 C library (necessary for all languages)")
find_library(HDF5_C_HL_LIBRARY
  NAMES hdf5_hl libhdf5_hl
  HINTS ${pc_hdf5_LIBRARY_DIRS} ${pc_hdf5_LIBDIR}
  PATH_SUFFIXES ${_lsuf}
  NAMES_PER_DIR
  DOC "HDF5 C high level interface")
set(HDF5_C_LIBRARIES ${HDF5_C_HL_LIBRARY} ${HDF5_C_LIBRARY})

find_path(HDF5_INCLUDE_DIR
  NAMES hdf5.h
  HINTS ${pc_hdf5_INCLUDE_DIRS}
  PATH_SUFFIXES ${_psuf}
  DOC "HDF5 C header")

if(HDF5_C_HL_LIBRARY AND HDF5_C_LIBRARY AND HDF5_INCLUDE_DIR)
  list(APPEND CMAKE_REQUIRED_LIBRARIES ${HDF5_C_LIBRARIES})
  set(HDF5_C_FOUND true)
  set(HDF5_HL_FOUND true)
endif()

# required libraries
if(HDF5_C_FOUND)
  detect_config()
endif(HDF5_C_FOUND)

# --- configure time checks
# these checks avoid messy, confusing errors at build time

if(HDF5_Fortran_FOUND)

set(CMAKE_REQUIRED_INCLUDES ${HDF5_Fortran_INCLUDE_DIR} ${HDF5_INCLUDE_DIR})

include(CheckFortranSourceCompiles)
set(_code "program test_minimal
use hdf5, only : h5open_f, h5close_f
use h5lt, only : h5ltmake_dataset_f
implicit none (type, external)
integer :: i
call h5open_f(i)
if (i /= 0) error stop 'could not open hdf5 library'
call h5close_f(i)
if (i /= 0) error stop
end")
check_fortran_source_compiles(${_code} HDF5_Fortran_links SRC_EXT f90)

if(HDF5_Fortran_links AND CMAKE_VERSION VERSION_GREATER_EQUAL 3.14)
  include(CheckFortranSourceRuns)
  check_fortran_source_runs(${_code} HDF5_runs SRC_EXT f90)
endif()

endif(HDF5_Fortran_FOUND)


if(HDF5_C_FOUND)

set(CMAKE_REQUIRED_INCLUDES ${HDF5_INCLUDE_DIR})

include(CheckCSourceCompiles)
set(_code "
#include \"hdf5.h\"

int main(void){
hid_t f = H5Fcreate (\"junk.h5\", H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
herr_t status = H5Fclose (f);
return 0;
}")
check_c_source_compiles("${_code}" HDF5_C_links)

set(HDF5_links ${HDF5_C_links})

endif(HDF5_C_FOUND)

if(HDF5_Fortran_FOUND AND NOT HDF5_Fortran_links)
  set(HDF5_links false)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HDF5
  REQUIRED_VARS HDF5_C_LIBRARIES HDF5_links
  VERSION_VAR HDF5_VERSION
  HANDLE_COMPONENTS)

if(HDF5_FOUND)
  set(HDF5_INCLUDE_DIRS ${HDF5_Fortran_INCLUDE_DIR} ${HDF5_INCLUDE_DIR})
  set(HDF5_LIBRARIES ${HDF5_Fortran_LIBRARIES} ${HDF5_CXX_LIBRARIES} ${HDF5_C_LIBRARIES})

  if(NOT TARGET HDF5::HDF5)
    add_library(HDF5::HDF5 INTERFACE IMPORTED)
    set_target_properties(HDF5::HDF5 PROPERTIES
      INTERFACE_LINK_LIBRARIES "${HDF5_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${HDF5_INCLUDE_DIRS}")
    if(_zlib)
      target_link_libraries(HDF5::HDF5 INTERFACE ZLIB::ZLIB)
    endif()
    if(_szip)
      target_link_libraries(HDF5::HDF5 INTERFACE SZIP::SZIP)
    endif()

    if(Threads_FOUND)
      target_link_libraries(HDF5::HDF5 INTERFACE Threads::Threads)
    endif()

    target_link_libraries(HDF5::HDF5 INTERFACE ${CMAKE_DL_LIBS})

    if(UNIX)
      target_link_libraries(HDF5::HDF5 INTERFACE m)
    endif()
  endif()
endif()

mark_as_advanced(HDF5_Fortran_LIBRARY HDF5_Fortran_HL_LIBRARY
HDF5_C_LIBRARY HDF5_C_HL_LIBRARY
HDF5_CXX_LIBRARY HDF5_CXX_HL_LIBRARY
HDF5_INCLUDE_DIR HDF5_Fortran_INCLUDE_DIR)

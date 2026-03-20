# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindnetCDF
----------

Find netCDF4 library

based on: https://github.com/Kitware/VTK/blob/master/CMake/FindNetCDF.cmake
in general, netCDF requires C compiler even if only using Fortran

Imported targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` target:

``netCDF::netcdf``
  netCDF C / C++ libraries

``netCDF::netcdff``
  netCDF Fortran libraries

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

``netCDF_FOUND``
  netCDF4 is found (also ``netCDF_C_FOUND`` and ``netCDF_Fortran_FOUND``)
``netCDF_C_LIBRARIES`` and ``netCDF_Fortran_LIBRARIES
  uncached list of libraries (using full path name) to link against
``netCDF_C_INCLUDE_DIRS`` and ``netCDF_Fortran_INCLUDE_DIRS``
  uncached list of libraries (using full path name) to include

Search details:

1. look for CMake-build config files (for C / C++ only)
2. CMake manual search optionally using pkg-config (this step always needed for Fortran, and for C if step 1 fails)

#]=======================================================================]

include(CheckSourceCompiles)

function(netcdf_c)

find_path(netCDF_C_INCLUDE_DIR
NAMES netcdf.h
DOC "netCDF C include directory"
)

if(NOT netCDF_C_INCLUDE_DIR)
  return()
endif()

find_library(netCDF_C_LIBRARY
NAMES netcdf
DOC "netCDF C library"
)

if(NOT netCDF_C_LIBRARY)
  return()
endif()

set(CMAKE_REQUIRED_FLAGS)
set(CMAKE_REQUIRED_INCLUDES ${netCDF_C_INCLUDE_DIR})

set(CMAKE_REQUIRED_LIBRARIES ${netCDF_C_LIBRARY})
if(ZLIB_FOUND)
  list(APPEND CMAKE_REQUIRED_LIBRARIES ${ZLIB_LIBRARIES})
endif()

list(APPEND CMAKE_REQUIRED_LIBRARIES ${CMAKE_DL_LIBS} ${CMAKE_THREAD_LIBS_INIT})

if(UNIX)
  list(APPEND CMAKE_REQUIRED_LIBRARIES m)
endif()

check_source_compiles(C
[=[
#include <netcdf.h>
#include <stdio.h>

int main(void){
printf("%s", nc_inq_libvers());
return 0;
}
]=]
netCDF_C_links
)

if(NOT netCDF_C_links)
  return()
endif()

set(netCDF_C_FOUND true PARENT_SCOPE)
set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} PARENT_SCOPE)

endfunction(netcdf_c)


function(netcdf_fortran)

find_path(netCDF_Fortran_INCLUDE_DIR
NAMES netcdf.mod
HINTS ${netCDF_C_INCLUDE_DIR}
DOC "netCDF Fortran Include"
)

if(NOT netCDF_Fortran_INCLUDE_DIR)
  return()
endif()

if(CMAKE_VERSION VERSION_LESS 3.20)
  get_filename_component(netCDF_LIBDIR ${netCDF_C_LIBRARY} DIRECTORY)
else()
  cmake_path(GET netCDF_C_LIBRARY PARENT_PATH netCDF_LIBDIR)
endif()

find_library(netCDF_Fortran_LIBRARY
NAMES netcdff
HINTS ${netCDF_LIBDIR}
DOC "netCDF Fortran library"
)

if(NOT netCDF_Fortran_LIBRARY)
  return()
endif()

set(CMAKE_REQUIRED_FLAGS)
set(CMAKE_REQUIRED_INCLUDES ${netCDF_Fortran_INCLUDE_DIR})
list(PREPEND CMAKE_REQUIRED_LIBRARIES ${netCDF_Fortran_LIBRARY})

check_source_compiles(Fortran
"program a
use netcdf
implicit none
end program"
netCDF_Fortran_links
)

if(NOT netCDF_Fortran_links)
  return()
endif()

set(netCDF_Fortran_FOUND true PARENT_SCOPE)

endfunction(netcdf_fortran)

#============================================================
# main program

find_package(ZLIB)
find_package(Threads)
# top scope so can be reused

netcdf_c()

set(_ncdf_req netCDF_C_LIBRARY)

if(Fortran IN_LIST netCDF_FIND_COMPONENTS)
  netcdf_fortran()
  list(APPEND _ncdf_req netCDF_Fortran_LIBRARY)
endif()

set(CMAKE_REQUIRED_FLAGS)
set(CMAKE_REQUIRED_INCLUDES)
set(CMAKE_REQUIRED_LIBRARIES)

mark_as_advanced(netCDF_C_INCLUDE_DIR netCDF_Fortran_INCLUDE_DIR netCDF_C_LIBRARY netCDF_Fortran_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(netCDF
REQUIRED_VARS _ncdf_req
HANDLE_COMPONENTS
)

if(netCDF_FOUND)
  set(netCDF_C_INCLUDE_DIRS ${netCDF_C_INCLUDE_DIR})
  set(netCDF_C_LIBRARIES ${netCDF_C_LIBRARY})

  if(NOT TARGET netCDF::netcdf)
    add_library(netCDF::netcdf INTERFACE IMPORTED)
    set_property(TARGET netCDF::netcdf PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${netCDF_C_INCLUDE_DIR}")
    set_property(TARGET netCDF::netcdf PROPERTY INTERFACE_LINK_LIBRARIES "${netCDF_C_LIBRARY}")

    target_link_libraries(netCDF::netcdf INTERFACE
    $<$<BOOL:${ZLIB_FOUND}>:${ZLIB_LIBRARIES}>
    ${CMAKE_THREAD_LIBS_INIT}
    ${CMAKE_DL_LIBS}
    $<$<BOOL:${UNIX}>:m>
    )
  endif()

  if(netCDF_Fortran_FOUND)
    set(netCDF_Fortran_INCLUDE_DIRS ${netCDF_Fortran_INCLUDE_DIR})
    set(netCDF_Fortran_LIBRARIES ${netCDF_Fortran_LIBRARY})
    if(NOT TARGET netCDF::netcdff)
      add_library(netCDF::netcdff INTERFACE IMPORTED)
      set_property(TARGET netCDF::netcdff PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${netCDF_Fortran_INCLUDE_DIR}")
      set_property(TARGET netCDF::netcdff PROPERTY INTERFACE_LINK_LIBRARIES "${netCDF_Fortran_LIBRARY}")

      target_link_libraries(netCDF::netcdff INTERFACE
      $<$<BOOL:${ZLIB_FOUND}>:${ZLIB_LIBRARIES}>
      ${CMAKE_THREAD_LIBS_INIT}
      ${CMAKE_DL_LIBS}
      $<$<BOOL:${UNIX}>:m>
      )
      target_link_libraries(netCDF::netcdff INTERFACE netCDF::netcdf)
    endif()
  endif()


endif()

# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:

FindSZIP
---------

by Michael Hirsch, Ph.D. www.scivision.dev

Finds SZIP developed by HDF Group & used by HDF5.


Result Variables
^^^^^^^^^^^^^^^^

``SZIP_FOUND``
  SZIP libraries were found
``SZIP_INCLUDE_DIRS``
  SZIP include directory
``SZIP_LIBRARIES``
  SZIP library files


Targets
^^^^^^^

``SZIP::SZIP``
  SZIP Imported Target
#]=======================================================================]

include(FeatureSummary)
set_package_properties(SZIP PROPERTIES
URL "http://www.compressconsult.com/szip/"
DESCRIPTION "compression library"
PURPOSE "Some system HDF5 libraries have dynamic links to SZIP")

find_library(SZIP_LIBRARY NAMES szip sz)

find_path(SZIP_INCLUDE_DIR NAMES szlib.h)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SZIP
  REQUIRED_VARS SZIP_LIBRARY SZIP_INCLUDE_DIR)

if(SZIP_FOUND)
  set(SZIP_INCLUDE_DIRS ${SZIP_INCLUDE_DIR})
  set(SZIP_LIBRARIES ${SZIP_LIBRARY})

  if(NOT TARGET SZIP::SZIP)
    add_library(SZIP::SZIP UNKNOWN IMPORTED)
    set_target_properties(SZIP::SZIP PROPERTIES
      IMPORTED_LOCATION ${SZIP_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${SZIP_INCLUDE_DIR})
  endif()
endif()

mark_as_advanced(SZIP_LIBRARY SZIP_INCLUDE_DIR)

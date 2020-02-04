cmake_minimum_required(VERSION 3.12)  # 3.12 for Fortran submodule
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(netcdf4fortran_interface
  LANGUAGES Fortran
  VERSION 0.1.0
  HOMEPAGE_URL https://github.com/scivision/nc4fortran)
enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/compilers.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/netcdf.cmake)

set(CTEST_TEST_TIMEOUT 15)

# --- build

add_subdirectory(src)

add_subdirectory(src/tests)

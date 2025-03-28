cmake_minimum_required(VERSION 3.19...3.30)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed. Do like:
  cmake -B build")
endif()

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

project(nc4fortran
LANGUAGES C Fortran
VERSION 1.7.2
)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(options.cmake)
include(cmake/compilers.cmake)

file(GENERATE OUTPUT .gitignore CONTENT "*")

if(find_netcdf)
  find_package(NetCDF COMPONENTS C Fortran)
endif()
if(NOT NetCDF_FOUND AND NOT TARGET NetCDF::NetCDF_Fortran)
  include(cmake/netcdf.cmake)
endif()

# --- code coverage
if(nc4fortran_COVERAGE AND nc4fortran_IS_TOP_LEVEL)
  include(cmake/Modules/CodeCoverage.cmake)
  append_coverage_compiler_flags()
  set(COVERAGE_EXCLUDES ${PROJECT_SOURCE_DIR}/test)
endif()

# --- clang-tidy
if(tidy AND nc4fortran_IS_TOP_LEVEL)
  find_program(CLANG_TIDY_EXE NAMES "clang-tidy" REQUIRED)
  set(CMAKE_C_CLANG_TIDY ${CLANG_TIDY_EXE})
endif()

# --- build

add_library(nc4fortran)
target_include_directories(nc4fortran PUBLIC
$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
$<INSTALL_INTERFACE:include>
)
target_link_libraries(nc4fortran PUBLIC NetCDF::NetCDF_Fortran)
set_target_properties(nc4fortran PROPERTIES
Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include
LABELS core
VERSION ${PROJECT_VERSION}
)

add_subdirectory(src)

# GLOBAL needed for FetchContent use
add_library(nc4fortran::nc4fortran INTERFACE IMPORTED GLOBAL)
target_link_libraries(nc4fortran::nc4fortran INTERFACE nc4fortran)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/nc4fortran.mod TYPE INCLUDE)

install(TARGETS nc4fortran EXPORT nc4fortran-targets)

# additional Find*.cmake necessary
install(FILES
${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindHDF5.cmake
${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindNetCDF.cmake
DESTINATION cmake
)


if(nc4fortran_BUILD_TESTING)
  add_subdirectory(test)
endif()

include(cmake/pkgconf.cmake)
include(cmake/install.cmake)

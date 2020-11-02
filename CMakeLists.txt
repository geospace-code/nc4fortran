cmake_minimum_required(VERSION 3.15)

include(cmake/compiler_find.cmake)

project(nc4fortran
  LANGUAGES C Fortran
  VERSION 1.1.0
  DESCRIPTION "thin, light object-oriented NetCDF4 Fortran interface"
  HOMEPAGE_URL https://github.com/geospace-code/nc4fortran)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/policy.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/compilers.cmake)

# --- find NetCDF4

if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  find_package(NetCDF COMPONENTS Fortran REQUIRED)
else()
  find_package(NetCDF COMPONENTS Fortran)
endif()

if(NOT NetCDF_FOUND)
  message(STATUS "nc4fortran: NetCDF4 not working, so nc4fortran is not available.")
  return()
endif()

# --- build

add_library(nc4fortran)
target_include_directories(nc4fortran
  PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include  # for IBM XL
  INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_link_libraries(nc4fortran PUBLIC NetCDF::NetCDF_Fortran)
set_target_properties(nc4fortran PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include)
add_library(nc4fortran::nc4fortran ALIAS nc4fortran)

add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(src/tests)
endif()

if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/install.cmake)

  include(FeatureSummary)
  set_package_properties(NetCDF PROPERTIES URL "https://www.unidata.ucar.edu/software/netcdf/" DESCRIPTION "fast, versatile file I/O format")
  feature_summary(WHAT ALL)
endif()

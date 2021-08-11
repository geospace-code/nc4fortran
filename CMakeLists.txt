cmake_minimum_required(VERSION 3.20...3.21)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION PROJECT_VERSION
  REGEX "^([0-9]+\.[0-9]+\.[0-9]+)" LIMIT_INPUT 16 LENGTH_MAXIMUM 16 LIMIT_COUNT 1)

project(nc4fortran
  LANGUAGES C Fortran
  VERSION ${PROJECT_VERSION}
  DESCRIPTION "thin, light object-oriented NetCDF4 Fortran interface"
  HOMEPAGE_URL https://github.com/geospace-code/nc4fortran)

include(CTest)
if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/options.cmake)
include(cmake/compilers.cmake)

# --- find NetCDF4

if(NOT netcdf_external)
  find_package(NetCDF COMPONENTS Fortran)
endif()

if(NOT NetCDF_FOUND OR netcdf_external)
  include(cmake/netcdf.cmake)
endif()

# --- build

add_library(nc4fortran)
target_include_directories(nc4fortran
  PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include  # for IBM XL
  INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_link_libraries(nc4fortran PUBLIC NetCDF::NetCDF_Fortran)
set_target_properties(nc4fortran PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include
  LABELS core
  VERSION ${PROJECT_VERSION})

# GLOBAL needed for FetchContent use
add_library(nc4fortran::nc4fortran INTERFACE IMPORTED GLOBAL)
target_link_libraries(nc4fortran::nc4fortran INTERFACE nc4fortran)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/nc4fortran.mod
  DESTINATION include)

install(TARGETS nc4fortran EXPORT ${PROJECT_NAME}Targets)

# additional Find*.cmake necessary
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindHDF5.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindSZIP.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindNetCDF.cmake
  DESTINATION lib/cmake/Modules)


add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(src/tests)
endif()

include(cmake/pkgconf.cmake)
include(cmake/install.cmake)

include(FeatureSummary)
# set_package_properties(NetCDF PROPERTIES URL "https://www.unidata.ucar.edu/software/netcdf/" DESCRIPTION "fast, versatile file I/O format")
add_feature_info(BuildNetCDF netcdf_external "build NetCDF libraries")
feature_summary(WHAT ENABLED_FEATURES)

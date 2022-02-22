cmake_minimum_required(VERSION 3.20...3.23)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

file(READ ${CMAKE_CURRENT_LIST_DIR}/codemeta.json _j)
string(JSON PROJECT_VERSION GET ${_j} version)

project(nc4fortran
LANGUAGES C Fortran
VERSION ${PROJECT_VERSION}
DESCRIPTION "thin, light object-oriented NetCDF4 Fortran interface"
HOMEPAGE_URL https://github.com/geospace-code/nc4fortran
)

include(CTest)
if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

include(cmake/options.cmake)
include(cmake/compilers.cmake)
include(cmake/libraries.cmake)

# --- find or build NetCDF4

include(cmake/netcdf.cmake)

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

# GLOBAL needed for FetchContent use
add_library(nc4fortran::nc4fortran INTERFACE IMPORTED GLOBAL)
target_link_libraries(nc4fortran::nc4fortran INTERFACE nc4fortran)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/nc4fortran.mod TYPE INCLUDE)

install(TARGETS nc4fortran EXPORT ${PROJECT_NAME}-targets)

# additional Find*.cmake necessary
install(FILES
${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindHDF5.cmake
${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/check_hdf5_mpi.f90
${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindSZIP.cmake
${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindNetCDF.cmake
DESTINATION cmake
)


add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
endif()

include(cmake/pkgconf.cmake)
include(cmake/install.cmake)

include(FeatureSummary)
# set_package_properties(NetCDF PROPERTIES URL "https://www.unidata.ucar.edu/software/netcdf/" DESCRIPTION "fast, versatile file I/O format")
add_feature_info(BuildNetCDF netcdf_external "build NetCDF libraries")
feature_summary(WHAT ENABLED_FEATURES)

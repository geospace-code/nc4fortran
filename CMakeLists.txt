cmake_minimum_required(VERSION 3.11...3.25)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

project(nc4fortran
LANGUAGES C Fortran
VERSION 1.7.0
)

include(CTest)
if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

find_package(NetCDF COMPONENTS C Fortran)
if(NOT NetCDF_FOUND)
message(FATAL_ERROR "NetCDF not found or working on the system. First build:

cmake -S scripts -B scripts/build -DCMAKE_INSTALL_PREFIX=~/mylibs
cmake --build scripts/build

Then build nc4fortran:

cmake -B build -DCMAKE_PREFIX_PATH=~/mylibs
cmake --build build
")
endif()

# --- build

set(s ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_library(nc4fortran ${s}/interface.f90 ${s}/utils.f90
${s}/read.f90 ${s}/reader.f90 ${s}/read_scalar.f90
${s}/write.f90 ${s}/writer.f90 ${s}/write_scalar.f90
${s}/attributes.f90
)
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

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/nc4fortran.mod DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(TARGETS nc4fortran EXPORT ${PROJECT_NAME}-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# additional Find*.cmake necessary
install(FILES
${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindHDF5.cmake
${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindNetCDF.cmake
DESTINATION cmake
)


if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(test)
endif()

include(cmake/pkgconf.cmake)
include(cmake/install.cmake)

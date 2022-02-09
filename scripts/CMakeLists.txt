cmake_minimum_required(VERSION 3.20...3.22)
project(NetCDF_build
LANGUAGES C Fortran
)

set(autobuild on)

# --- system checks
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "please specify where to install NetCDF under, like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/mylibs")
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules/)


# --- commence NetCDF build/install
include(${PROJECT_SOURCE_DIR}/../cmake/libraries.cmake)

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

message(STATUS "Build / install NetCDF to ${CMAKE_INSTALL_PREFIX}")

include(${PROJECT_SOURCE_DIR}/../cmake/netcdf.cmake)

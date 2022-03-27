cmake_minimum_required(VERSION 3.20...3.23)
project(NetCDF_build
LANGUAGES C Fortran
)

# --- system checks
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "please specify where to install NetCDF under, like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/mylibs")
endif()

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules/)


# --- commence NetCDF build/install
set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/libraries.json json)

message(STATUS "Build / install NetCDF to ${CMAKE_INSTALL_PREFIX}")

include(${PROJECT_SOURCE_DIR}/../cmake/netcdf.cmake)

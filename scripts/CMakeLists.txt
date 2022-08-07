cmake_minimum_required(VERSION 3.19...3.25)
project(NetCDF_build
LANGUAGES C Fortran
)

# --- system checks
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "please specify where to install NetCDF under, like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/mylibs")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)

set(CMAKE_TLS_VERIFY on)

# --- commence NetCDF build/install
set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/libraries.json json)

message(STATUS "Build / install NetCDF to ${CMAKE_INSTALL_PREFIX}")

include(${PROJECT_SOURCE_DIR}/../cmake/netcdf.cmake)

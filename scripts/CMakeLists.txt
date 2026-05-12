cmake_minimum_required(VERSION 3.25...3.30)
project(NetCDF_build
LANGUAGES C Fortran
)

# --- system checks
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX})
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.29)
  if(NOT IS_WRITABLE ${CMAKE_INSTALL_PREFIX})
    message(FATAL_ERROR "CMAKE_INSTALL_PREFIX is not writable: ${CMAKE_INSTALL_PREFIX}")
  endif()
else()
  file(TOUCH ${CMAKE_INSTALL_PREFIX}/.cmake_writable "")
endif()

# --- commence NetCDF build/install
set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/libraries.json json)

message(STATUS "Build / install NetCDF to ${CMAKE_INSTALL_PREFIX}")

include(${PROJECT_SOURCE_DIR}/../cmake/netcdf.cmake)

cmake_minimum_required(VERSION 3.13...3.20)

project(nc4fortranExample
LANGUAGES Fortran)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../cmake/Modules)

find_package(nc4fortran CONFIG)

if(NOT nc4fortran_FOUND)
  message(FATAL_ERROR "could not find nc4fortran")
endif()

include(${nc4fortran_DIR}/nc4fortranTargets.cmake)

if(NOT TARGET nc4fortran::nc4fortran)
  message(FATAL_ERROR "nc4fortran not found.")
endif()

find_package(NetCDF COMPONENTS Fortran REQUIRED)

# --- Fortran interface for examples
add_library(fortran_interface fortran_interface.f90)
target_link_libraries(fortran_interface PRIVATE nc4fortran::nc4fortran)

# --- example 1
add_executable(example1 example1.f90)
target_link_libraries(example1 nc4fortran::nc4fortran)
add_test(NAME nc4fortran:Example1 COMMAND $<TARGET_FILE:example1>
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

# --- example 2
add_executable(example2 example2.f90)
target_link_libraries(example2 nc4fortran::nc4fortran)
add_test(NAME nc4fortran:Example2 COMMAND $<TARGET_FILE:example2>
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

cmake_minimum_required(VERSION 3.14)
project(nc4fortranExample
LANGUAGES C CXX Fortran)
enable_testing()

find_package(nc4fortran CONFIG)

if(nc4fortran_FOUND)
  include(${nc4fortran_DIR}/nc4fortranTargets.cmake)
else()
  include(FetchContent)
  FetchContent_Declare(nc4fortran_proj
    GIT_REPOSITORY https://github.com/geospace-code/nc4fortran.git
    GIT_TAG v1.0.2)
  FetchContent_MakeAvailable(nc4fortran_proj)
endif()

if(NOT NCDFOK)
  message(FATAL_ERROR "NetCDF4 is not working on your system, so nc4fortran cannot work.")
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

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

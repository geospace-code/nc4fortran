cmake_minimum_required(VERSION 3.20)

project(nc4fortranExample
LANGUAGES C Fortran
)

enable_testing()

find_package(nc4fortran CONFIG REQUIRED)

# --- Fortran interface for examples
add_library(fortran_interface fortran_interface.f90)
target_link_libraries(fortran_interface PRIVATE nc4fortran::nc4fortran)

# --- example 1
add_executable(example1 example1.f90)
target_link_libraries(example1 nc4fortran::nc4fortran)
add_test(NAME nc4fortran:Example1 COMMAND example1
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# --- example 2
add_executable(example2 example2.f90)
target_link_libraries(example2 nc4fortran::nc4fortran)
add_test(NAME nc4fortran:Example2 COMMAND example2
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

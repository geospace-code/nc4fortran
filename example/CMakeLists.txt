cmake_minimum_required(VERSION 3.15...3.28)

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

# --- NetCDF shared lib paths needed
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
get_property(incdir TARGET nc4fortran::nc4fortran PROPERTY INTERFACE_INCLUDE_DIRECTORIES)

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
  if(WIN32)
    set_property(TEST ${test_names} PROPERTY
    ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:${incdir}/../bin"
    )
  elseif(APPLE)
    set_property(TEST ${test_names} PROPERTY
    ENVIRONMENT_MODIFICATION "DYLD_LIBRARY_PATH=path_list_prepend:${incdir}/../lib"
    )
  else()
    set_property(TEST ${test_names} PROPERTY
    ENVIRONMENT_MODIFICATION "LD_LIBRARY_PATH=path_list_prepend:${incdir}/../lib"
    )
  endif()
endif()

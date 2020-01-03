cmake_minimum_required(VERSION 3.3)
project(NetCDF4Fortran Fortran)
enable_testing()

if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-fimplicit-none)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  add_compile_options(-warn declarations)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  add_compile_options(-Mdclchk)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/netcdf.cmake)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR})

add_subdirectory(src)

add_executable(netcdf_rw simple_xy_wr.f90)
target_compile_options(netcdf_rw PRIVATE ${FFLAGS})
target_include_directories(netcdf_rw PRIVATE ${NetCDF_INCLUDE_DIRS})
target_link_libraries(netcdf_rw PRIVATE ${NetCDF_LIBRARIES})
add_test(NAME NetCDF COMMAND netcdf_rw)

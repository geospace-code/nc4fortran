cmake_minimum_required(VERSION 3.3)
project(NetCDF4Fortran Fortran)
enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/netcdf.cmake)

add_subdirectory(src)

add_executable(netcdf_rw simple_xy_wr.f90)
target_compile_options(netcdf_rw PRIVATE ${FFLAGS})
target_include_directories(netcdf_rw PRIVATE ${NetCDF_INCLUDE_DIRS})
target_link_libraries(netcdf_rw PRIVATE ${NetCDF_LIBRARIES})
add_test(NAME NetCDF COMMAND netcdf_rw)

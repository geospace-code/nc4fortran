# apt install libnetcdf-dev libnetcdff-dev     # need BOTH installed

find_package(NetCDF COMPONENTS Fortran)
if(NOT NetCDF_FOUND)
  return()
endif()

set(CMAKE_REQUIRED_INCLUDES ${NetCDF_INCLUDE_DIRS})
set(CMAKE_REQUIRED_LIBRARIES ${NetCDF_LIBRARIES})

include(CheckFortranSourceCompiles)
check_fortran_source_compiles("use netcdf; end" NCDFOK SRC_EXT f90)

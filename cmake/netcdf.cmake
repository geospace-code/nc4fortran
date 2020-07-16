# apt install libnetcdf-dev libnetcdff-dev     # need BOTH installed

if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  find_package(NetCDF COMPONENTS Fortran REQUIRED)
else()
  find_package(NetCDF COMPONENTS Fortran)
endif()

set(CMAKE_REQUIRED_FLAGS)
set(CMAKE_REQUIRED_INCLUDES)
set(CMAKE_REQUIRED_LIBRARIES NetCDF::NetCDF_Fortran)

include(CheckFortranSourceCompiles)
check_fortran_source_compiles("use netcdf; end" NCDFOK SRC_EXT f90)

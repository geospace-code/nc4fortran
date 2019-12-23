# apt install libnetcdf-dev libnetcdff-dev     # need BOTH installed

find_package(NetCDF COMPONENTS Fortran REQUIRED)

set(CMAKE_REQUIRED_INCLUDES ${NetCDF_INCLUDE_DIRS})
set(CMAKE_REQUIRED_LIBRARIES ${NetCDF_LIBRARIES})

include(CheckFortranSourceCompiles)
check_fortran_source_compiles("use netcdf; end" NCDFOK SRC_EXT f90)

if(NOT NCDFOK)
  message(FATAL_ERROR "NetCDF not linking with ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}")
endif()

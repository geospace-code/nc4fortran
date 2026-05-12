include(FetchContent)
include(GNUInstallDirs)

file(MAKE_DIRECTORY ${CMAKE_INSTALL_FULL_INCLUDEDIR} ${CMAKE_INSTALL_FULL_LIBDIR})

# need HDF5, NetCDF-C and NetCDF-Fortran
# due to limitations of NetCDF-C and NetCDF-Fortran, as per their docs,
# we MUST use shared libraries or they don't archive/link properly.

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

# --- NetCDF-C

set(NETCDF_ENABLE_PARALLEL4 OFF)
set(NETCDF_ENABLE_PNETCDF OFF)
set(NETCDF_ENABLE_CDF5 OFF)
set(DISABLE_ZSTANDARD_PLUGIN ON)
set(NETCDF_BUILD_UTILITIES OFF)
set(NETCDF_ENABLE_DOXYGEN OFF)
set(ENABLE_TESTS OFF)
set(NETCDF_ENABLE_TESTS OFF)
set(NETCDF_ENABLE_PARALLEL_TESTS OFF)
set(NETCDF_ENABLE_LARGE_FILE_TESTS OFF)
set(BUILD_TESTING OFF)
set(NETCDF_ENABLE_HDF4 OFF)
set(USE_DAP OFF)
set(NETCDF_ENABLE_DAP OFF)
set(NETCDF_ENABLE_DAP2 OFF)
set(NETCDF_ENABLE_DAP4 OFF)
set(NETCDF_ENABLE_REMOTE_FUNCTIONALITY OFF)
set(NETCDF_ENABLE_BYTERANGE OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(BUILD_SHARED_LIBS on)

# BUILD_SHARED_LIBS=on for netcdf-fortran symbol finding bug

string(JSON netcdfC_url GET ${json} netcdfC)

FetchContent_Declare(NETCDF_C
URL ${netcdfC_url}
FIND_PACKAGE_ARGS NAMES NetCDF COMPONENTS C
)

FetchContent_MakeAvailable(NETCDF_C)

# --- NetCDF-Fortran

set(BUILD_EXAMPLES OFF)

string(JSON netcdfFortran_url GET ${json} netcdfFortran)

set(netCDF_ROOT ${netcdf_c_BINARY_DIR})

# Ensure netcdf-fortran can read both generated netcdf_meta.h and netcdf.h
# from one include directory, and bypass netCDFConfig.cmake during configure.
file(COPY_FILE ${netcdf_c_SOURCE_DIR}/include/netcdf.h ${netcdf_c_BINARY_DIR}/include/netcdf.h ONLY_IF_DIFFERENT)
set(netCDF_INCLUDE_DIR ${netcdf_c_BINARY_DIR}/include)
set(netCDF_LIBRARIES netCDF::netcdf)

FetchContent_Declare(NETCDF_FORTRAN
URL ${netcdfFortran_url}
FIND_PACKAGE_ARGS NAMES NetCDF COMPONENTS Fortran
)
# BUILD_SHARED_LIBS=on for netcdf-fortran symbol finding bug
# netCDEF_LIBRARIES and netCDF_INCLUDE_DIR from netcdf-fortran/CMakeLists.txt

block(SCOPE_FOR POLICIES)
if(POLICY CMP0169)
  cmake_policy(SET CMP0169 OLD)
endif()

FetchContent_GetProperties(NETCDF_FORTRAN)
if(NOT netcdf_fortran_POPULATED)
  FetchContent_Populate(NETCDF_FORTRAN)
endif()

endblock()

include(${CMAKE_CURRENT_LIST_DIR}/patch_netcdf_fortran.cmake)

# instead of FetchContent_MakeAvailable until NetCDF is updated to be FetchContent friendly.
add_subdirectory(${netcdf_fortran_SOURCE_DIR} ${netcdf_fortran_BINARY_DIR})

# --- imported target

if(NOT TARGET NetCDF::NetCDF_Fortran)
  if(TARGET libnetcdff)
    add_library(NetCDF::NetCDF_Fortran ALIAS libnetcdff)
  elseif(TARGET netcdff)
    add_library(NetCDF::NetCDF_Fortran ALIAS netcdff)
  endif()
endif()

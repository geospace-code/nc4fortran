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
set(NETCDF_BUILD_UTILITIES OFF)
set(NETCDF_ENABLE_TESTS OFF)
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
set(NETCDF_ENABLE_TESTS OFF)

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

FetchContent_Declare(NETCDF_FORTRAN
URL ${netcdfFortran_url}
FIND_PACKAGE_ARGS NAMES NetCDF COMPONENTS Fortran
)
# BUILD_SHARED_LIBS=on for netcdf-fortran symbol finding bug
# netCDEF_LIBRARIES and netCDF_INCLUDE_DIR from netcdf-fortran/CMakeLists.txt

FetchContent_MakeAvailable(NETCDF_C NETCDF_FORTRAN)

# --- imported target

if(NOT TARGET NetCDF::NetCDF_Fortran)
  add_library(NetCDF::NetCDF_Fortran ALIAS libnetcdff)
endif()

include(ExternalProject)
include(GNUInstallDirs)

# need HDF5, NetCDF-C and NetCDF-Fortran
# due to limitations of NetCDF-C and NetCDF-Fortran, as per their docs,
# we MUST use shared libraries or they don't archive/link properly.

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

if(NOT DEFINED HDF5_ROOT AND DEFINED ENV{HDF5_ROOT})
  set(HDF5_ROOT $ENV{HDF5_ROOT})
endif()

find_package(HDF5 COMPONENTS C Fortran)
if(HDF5_FOUND)
  add_custom_target(HDF5)
else()
  include(${CMAKE_CURRENT_LIST_DIR}/hdf5.cmake)
endif()

# --- NetCDF-C

find_package(NetCDF COMPONENTS C)
if(NetCDF_C_FOUND)
  add_custom_target(NETCDF_C)
else()
  include(${CMAKE_CURRENT_LIST_DIR}/netcdf-c.cmake)
endif()


# --- NetCDF-Fortran

# NetCDF-Fortran needs these for its checks of NetCDF-C, but doesn't set them.
find_package(ZLIB)
find_package(Threads)

set(CMAKE_REQUIRED_LIBRARIES
${ZLIB_LIBRARIES}
${CMAKE_THREAD_LIBS_INIT}
${CMAKE_DL_LIBS}
)

set(netcdf_fortran_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_MODULE_PATH:PATH=${CMAKE_MODULE_PATH}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DnetCDF_LIBRARIES:FILEPATH=${NetCDF_C_LIBRARIES}
-DnetCDF_INCLUDE_DIR:PATH=${NetCDF_C_INCLUDE_DIRS}
-DCMAKE_BUILD_TYPE:STRING=Release
-DBUILD_SHARED_LIBS:BOOL=ON
-DENABLE_TESTS:BOOL=OFF
-DBUILD_EXAMPLES:BOOL=OFF
-DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER}
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
-DHDF5_ROOT:PATH=${HDF5_ROOT}
)

if(WIN32)
  set(NetCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_FULL_BINDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(NetCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_FULL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()

set(NetCDF_Fortran_INCLUDE_DIRS ${CMAKE_INSTALL_FULL_INCLUDEDIR})

string(JSON netcdfFortran_url GET ${json} netcdfFortran url)

ExternalProject_Add(NETCDF_FORTRAN
URL ${netcdfFortran_url}
CONFIGURE_HANDLED_BY_BUILD ON
CMAKE_ARGS ${netcdf_fortran_cmake_args}
CMAKE_CACHE_ARGS -DCMAKE_REQUIRED_LIBRARIES:STRING=${CMAKE_REQUIRED_LIBRARIES}
BUILD_BYPRODUCTS ${NetCDF_Fortran_LIBRARIES}
DEPENDS NETCDF_C
USES_TERMINAL_DOWNLOAD true
USES_TERMINAL_UPDATE true
USES_TERMINAL_PATCH true
USES_TERMINAL_CONFIGURE true
USES_TERMINAL_BUILD true
USES_TERMINAL_INSTALL true
USES_TERMINAL_TEST true
)
# BUILD_SHARED_LIBS=on for netcdf-fortran symbol finding bug
# netCDEF_LIBRARIES and netCDF_INCLUDE_DIR from netcdf-fortran/CMakeLists.txt

# --- imported target

file(MAKE_DIRECTORY ${NetCDF_Fortran_INCLUDE_DIRS})
# avoid race condition

# this GLOBAL is required to be visible via other project's FetchContent
add_library(NetCDF::NetCDF_Fortran INTERFACE IMPORTED GLOBAL)
target_include_directories(NetCDF::NetCDF_Fortran INTERFACE "${NetCDF_Fortran_INCLUDE_DIRS}")
target_link_libraries(NetCDF::NetCDF_Fortran INTERFACE "${NetCDF_Fortran_LIBRARIES}")

add_dependencies(NetCDF::NetCDF_Fortran NETCDF_FORTRAN)

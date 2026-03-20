include(ExternalProject)
include(GNUInstallDirs)

# need HDF5, netCDF-C and netCDF-Fortran
# due to limitations of netCDF-C and netCDF-Fortran, as per their docs,
# we MUST use shared libraries or they don't archive/link properly.

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

if(NOT DEFINED HDF5_ROOT AND DEFINED ENV{HDF5_ROOT})
  set(HDF5_ROOT $ENV{HDF5_ROOT})
endif()

if(nc4fortran_find_hdf5)
  find_package(HDF5 COMPONENTS C Fortran)
endif()
if(HDF5_FOUND)
  add_custom_target(HDF5)
else()
  include(${CMAKE_CURRENT_LIST_DIR}/hdf5.cmake)
endif()

# --- netCDF-C

if(nc4fortran_find_netcdf)
  find_package(netCDF COMPONENTS C)
endif()
if(TARGET netCDF::netcdf)
  add_custom_target(NETCDF_C)
else()
  include(${CMAKE_CURRENT_LIST_DIR}/netcdf-c.cmake)
endif()


# --- netCDF-Fortran

set(netcdf_fortran_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DNetCDF_LIBRARIES:FILEPATH=${netCDF_C_LIBRARIES}
-DNetCDF_INCLUDE_DIR:PATH=${netCDF_C_INCLUDE_DIRS}
-DCMAKE_BUILD_TYPE:STRING=Release
-DBUILD_SHARED_LIBS:BOOL=ON
-DNETCDF_ENABLE_TESTS:BOOL=OFF
-DBUILD_EXAMPLES:BOOL=OFF
-DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER}
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
-DHDF5_ROOT:PATH=${HDF5_ROOT}
)

if(WIN32)
  set(netCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_FULL_BINDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(netCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_FULL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()

set(netCDF_Fortran_INCLUDE_DIRS ${CMAKE_INSTALL_FULL_INCLUDEDIR})

string(JSON netcdfFortran_url GET ${json} netcdfFortran url)

ExternalProject_Add(NETCDF_FORTRAN
URL ${netcdfFortran_url}
CONFIGURE_HANDLED_BY_BUILD ON
CMAKE_ARGS ${netcdf_fortran_cmake_args}
BUILD_BYPRODUCTS ${netCDF_Fortran_LIBRARIES}
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

file(MAKE_DIRECTORY ${netCDF_Fortran_INCLUDE_DIRS})
# avoid race condition

add_library(netCDF::netcdff INTERFACE IMPORTED)
target_include_directories(netCDF::netcdff INTERFACE "${netCDF_Fortran_INCLUDE_DIRS}")
target_link_libraries(netCDF::netcdff INTERFACE "${netCDF_Fortran_LIBRARIES}")

#set_property(TARGET netCDF::netcdff PROPERTY EXPORT_FIND_PACKAGE_NAME netCDF)

add_dependencies(netCDF::netcdff NETCDF_FORTRAN)

include(ExternalProject)
# need HDF5, NetCDF-C and NetCDF-Fortran
# due to limitations of NetCDF-C 4.7.4 and NetCDF-Fortran 4.5.3, as per their docs,
# we MUST use shared libraries or they don't archive/link properly.

find_package(HDF5 COMPONENTS C Fortran REQUIRED)

set(netcdf_external true CACHE BOOL "autobuild NetCDF")

if(NOT DEFINED NetCDF_ROOT)
  set(NetCDF_ROOT ${PROJECT_BINARY_DIR}/netcdf)
endif()

set(NetCDF_INCLUDE_DIRS ${NetCDF_ROOT}/include)

set(NetCDF_C_LIBRARIES ${NetCDF_ROOT}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
set(NetCDF_Fortran_LIBRARIES ${NetCDF_ROOT}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
if(MINGW)
  # libnetcdf.dll.a
  # not yet working https://github.com/Unidata/netcdf-c/issues/554
  string(APPEND NetCDF_C_LIBRARIES ".a")
  string(APPEND NetCDF_Fortran_LIBRARIES ".a")
endif()


# --- NetCDF-C
ExternalProject_Add(NETCDF_C
URL https://github.com/Unidata/netcdf-c/archive/v4.7.4.zip
URL_HASH SHA256=170c9c9020f8909811b06e1034d5ea9288b3d5bd90793e3dd27490191faa7566
TLS_VERIFY ON
CONFIGURE_HANDLED_BY_BUILD TRUE
INACTIVITY_TIMEOUT 30
# Shared_libs=on for netcdf-fortran symbol finding bug
CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${NetCDF_ROOT} -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_SHARED_LIBS:BOOL=ON -DENABLE_PARALLEL4:BOOL=OFF -DENABLE_PNETCDF:BOOL=OFF -DBUILD_UTILITIES:BOOL=OFF -DENABLE_TESTS:BOOL=off -DBUILD_TESTING:BOOL=OFF -DENABLE_HDF4:BOOL=OFF -DUSE_DAP:BOOL=off -DENABLE_DAP:BOOL=OFF -DENABLE_DAP2:BOOL=OFF -DENABLE_DAP4:BOOL=OFF
BUILD_BYPRODUCTS ${NetCDF_C_LIBRARIES})

# --- imported target

file(MAKE_DIRECTORY ${NetCDF_INCLUDE_DIRS})
# avoid race condition

# this GLOBAL is required to be visible via other project's FetchContent of h5fortran
add_library(NetCDF::NetCDF_C INTERFACE IMPORTED GLOBAL)
target_include_directories(NetCDF::NetCDF_C INTERFACE "${NetCDF_INCLUDE_DIRS}")
target_link_libraries(NetCDF::NetCDF_C INTERFACE "${NetCDF_C_LIBRARIES}")
add_dependencies(NetCDF::NetCDF_C NETCDF_C)

# -- external deps
target_link_libraries(NetCDF::NetCDF_C INTERFACE HDF5::HDF5)

# --- NetCDF-Fortran
ExternalProject_Add(NETCDF_FORTRAN
URL https://github.com/Unidata/netcdf-fortran/archive/v4.5.3.zip
URL_HASH SHA256=a2b9395622ba7411037ca153ad3a6d0824f445b238f1f5c3d3352f8ab7f3117b
TLS_VERIFY ON
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 30
# Shared_libs=on for netcdf-fortran symbol finding bug
# netCDEF_LIBRARIES and netCDF_INCLUDE_DIR from netcdf-fortran/CMakeLists.txt
CMAKE_ARGS -DnetCDF_LIBRARIES:FILEPATH=${NetCDF_C_LIBRARIES} -DnetCDF_INCLUDE_DIR:PATH=${NetCDF_INCLUDE_DIRS} -DCMAKE_INSTALL_PREFIX:PATH=${NetCDF_ROOT} -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_SHARED_LIBS:BOOL=ON -DENABLE_TESTS:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF
BUILD_BYPRODUCTS ${NetCDF_Fortran_LIBRARIES}
DEPENDS NETCDF_C)

# --- imported target

# this GLOBAL is required to be visible via other project's FetchContent of h5fortran
add_library(NetCDF::NetCDF_Fortran INTERFACE IMPORTED GLOBAL)
target_include_directories(NetCDF::NetCDF_Fortran INTERFACE "${NetCDF_INCLUDE_DIRS}")
target_link_libraries(NetCDF::NetCDF_Fortran INTERFACE "${NetCDF_Fortran_LIBRARIES}")
add_dependencies(NetCDF::NetCDF_Fortran NETCDF_FORTRAN)

include(ExternalProject)
# need HDF5, NetCDF-C and NetCDF-Fortran
# due to limitations of NetCDF-C 4.7.4 and NetCDF-Fortran 4.5.3, as per their docs,
# we MUST use shared libraries or they don't archive/link properly.

if(NOT hdf5_external)
  if(autobuild)
    find_package(HDF5 COMPONENTS C Fortran)
  endif()
  if(NOT (HDF5_FOUND OR TARGET HDF5::HDF5))
    include(${CMAKE_CURRENT_LIST_DIR}/hdf5.cmake)
  endif()
else()
  find_package(HDF5 COMPONENTS C Fortran REQUIRED)
endif()

if(NOT netcdf_external)
  if(autobuild)
    find_package(NetCDF COMPONENTS Fortran)
  else()
    find_package(NetCDF COMPONENTS Fortran REQUIRED)
  endif()
endif()

if(NetCDF_FOUND)
  return()
endif()

set(netcdf_external true CACHE BOOL "autobuild NetCDF")

cmake_path(SET NetCDF_C_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)

if(WIN32)
  cmake_path(SET NetCDF_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
  cmake_path(SET NetCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_PREFIX}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
  if(MSVC)
    cmake_path(SET NetCDF_C_IMPLIB ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_STATIC_LIBRARY_SUFFIX})
    cmake_path(SET NetCDF_Fortran_IMPLIB ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_STATIC_LIBRARY_SUFFIX})
  else()
    cmake_path(SET NetCDF_C_IMPLIB ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
    cmake_path(SET NetCDF_Fortran_IMPLIB ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX})
  endif()
else()
  cmake_path(SET NetCDF_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
  cmake_path(SET NetCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()
# --- NetCDF-C

set(netcdf_c_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_MODULE_PATH:PATH=${CMAKE_MODULE_PATH}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_BUILD_TYPE:STRING=Release
-DBUILD_SHARED_LIBS:BOOL=ON
-DENABLE_PARALLEL4:BOOL=OFF
-DENABLE_PNETCDF:BOOL=OFF
-DBUILD_UTILITIES:BOOL=OFF
-DENABLE_TESTS:BOOL=off
-DBUILD_TESTING:BOOL=OFF
-DENABLE_HDF4:BOOL=OFF
-DUSE_DAP:BOOL=off
-DENABLE_DAP:BOOL=OFF
-DENABLE_DAP2:BOOL=OFF
-DENABLE_DAP4:BOOL=OFF
-DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
)

ExternalProject_Add(NETCDF_C
URL ${netcdfC_url}
URL_HASH SHA256=${netcdfC_sha256}
CONFIGURE_HANDLED_BY_BUILD TRUE
INACTIVITY_TIMEOUT 30
CMAKE_GENERATOR ${EXTPROJ_GENERATOR}
# Shared_libs=on for netcdf-fortran symbol finding bug
CMAKE_ARGS ${netcdf_c_cmake_args}
BUILD_BYPRODUCTS ${NetCDF_C_LIBRARIES} ${NetCDF_C_IMPLIB}
DEPENDS HDF5::HDF5
)

# --- imported target

file(MAKE_DIRECTORY ${NetCDF_C_INCLUDE_DIRS})
# avoid race condition

# this GLOBAL is required to be visible via other project's FetchContent
add_library(NetCDF::NetCDF_C SHARED IMPORTED GLOBAL)

set_target_properties(NetCDF::NetCDF_C PROPERTIES
INTERFACE_INCLUDE_DIRECTORIES ${NetCDF_C_INCLUDE_DIRS}
IMPORTED_LOCATION ${NetCDF_C_LIBRARIES}
)
if(WIN32)
  set_target_properties(NetCDF::NetCDF_C PROPERTIES IMPORTED_IMPLIB ${NetCDF_C_IMPLIB})
endif()

add_dependencies(NetCDF::NetCDF_C NETCDF_C)

# -- external deps
target_link_libraries(NetCDF::NetCDF_C INTERFACE HDF5::HDF5)

# --- NetCDF-Fortran

cmake_path(SET NetCDF_Fortran_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)

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
)

ExternalProject_Add(NETCDF_FORTRAN
URL ${netcdfFortran_url}
URL_HASH SHA256=${netcdfFortran_sha256}
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 30
CMAKE_GENERATOR ${EXTPROJ_GENERATOR}
# Shared_libs=on for netcdf-fortran symbol finding bug
# netCDEF_LIBRARIES and netCDF_INCLUDE_DIR from netcdf-fortran/CMakeLists.txt
CMAKE_ARGS ${netcdf_fortran_cmake_args}
BUILD_BYPRODUCTS ${NetCDF_Fortran_LIBRARIES} ${NetCDF_Fortran_IMPLIB}
DEPENDS NETCDF_C
)

# --- imported target

# this GLOBAL is required to be visible via other project's FetchContent
add_library(NetCDF::NetCDF_Fortran SHARED IMPORTED GLOBAL)

set_target_properties(NetCDF::NetCDF_Fortran PROPERTIES
INTERFACE_INCLUDE_DIRECTORIES ${NetCDF_Fortran_INCLUDE_DIRS}
IMPORTED_LOCATION ${NetCDF_Fortran_LIBRARIES}
)
if(WIN32)
  set_target_properties(NetCDF::NetCDF_Fortran PROPERTIES IMPORTED_IMPLIB ${NetCDF_Fortran_IMPLIB})
endif()

target_link_libraries(NetCDF::NetCDF_Fortran INTERFACE NetCDF::NetCDF_C)

add_dependencies(NetCDF::NetCDF_Fortran NETCDF_FORTRAN)

# --- dynamic shared library

if(UNIX)
  cmake_path(SET CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/lib)
  cmake_path(SET CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
endif()

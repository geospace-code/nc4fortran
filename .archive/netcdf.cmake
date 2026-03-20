include(ExternalProject)
include(GNUInstallDirs)

# need HDF5, netCDF-C and netCDF-Fortran
# due to limitations of netCDF-C 4.7.4 and netCDF-Fortran 4.5.3, as per their docs,
# we MUST use shared libraries or they don't archive/link properly.

find_package(HDF5 COMPONENTS C Fortran)
if(HDF5_FOUND)
  add_custom_target(HDF5)
else()
  include(${CMAKE_CURRENT_LIST_DIR}/hdf5.cmake)
endif()

cmake_path(SET netCDF_C_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)
file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include)

if(WIN32)
  cmake_path(SET netCDF_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
  cmake_path(SET netCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  cmake_path(SET netCDF_C_LIBRARIES ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
  cmake_path(SET netCDF_Fortran_LIBRARIES ${CMAKE_INSTALL_PREFIX}//${CMAKE_INSTALL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}netcdff${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()
# --- netCDF-C

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
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
)
# BUILD_SHARED_LIBS=on for netcdf-fortran symbol finding bug

string(JSON netcdfC_url GET ${json} netcdfC url)
string(JSON netcdfC_tag GET ${json} netcdfC tag)

ExternalProject_Add(NETCDF_C
GIT_REPOSITORY ${netcdfC_url}
GIT_TAG ${netcdfC_tag}
GIT_SHALLOW true
CONFIGURE_HANDLED_BY_BUILD TRUE
CMAKE_ARGS ${netcdf_c_cmake_args}
BUILD_BYPRODUCTS ${netCDF_C_LIBRARIES}
DEPENDS HDF5::HDF5
)

# --- imported target

file(MAKE_DIRECTORY ${netCDF_C_INCLUDE_DIRS})
# avoid race condition

add_library(netCDF::netcdf INTERFACE IMPORTED)
target_include_directories(netCDF::netcdf INTERFACE ${netCDF_C_INCLUDE_DIRS})
target_link_libraries(netCDF::netcdf INTERFACE ${netCDF_C_LIBRARIES})

add_dependencies(netCDF::netcdf NETCDF_C)

# -- external deps
target_link_libraries(netCDF::netcdf INTERFACE HDF5::HDF5)

# --- netCDF-Fortran

cmake_path(SET netCDF_Fortran_INCLUDE_DIRS ${CMAKE_INSTALL_FULL_INCLUDEDIR})

set(netcdf_fortran_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_MODULE_PATH:PATH=${CMAKE_MODULE_PATH}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DnetCDF_LIBRARIES:FILEPATH=${netCDF_C_LIBRARIES}
-DnetCDF_INCLUDE_DIR:PATH=${netCDF_C_INCLUDE_DIRS}
-DCMAKE_BUILD_TYPE:STRING=Release
-DBUILD_SHARED_LIBS:BOOL=ON
-DENABLE_TESTS:BOOL=OFF
-DBUILD_EXAMPLES:BOOL=OFF
-DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER}
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
)

string(JSON netcdfFortran_url GET ${json} netcdfFortran url)
string(JSON netcdfFortran_tag GET ${json} netcdfFortran tag)

ExternalProject_Add(NETCDF_FORTRAN
GIT_REPOSITORY ${netcdfFortran_url}
GIT_TAG ${netcdfFortran_tag}
GIT_SHALLOW true
CONFIGURE_HANDLED_BY_BUILD ON
CMAKE_ARGS ${netcdf_fortran_cmake_args}
BUILD_BYPRODUCTS ${netCDF_Fortran_LIBRARIES}
DEPENDS NETCDF_C
)
# BUILD_SHARED_LIBS=on for netcdf-fortran symbol finding bug
# netCDEF_LIBRARIES and netCDF_INCLUDE_DIR from netcdf-fortran/CMakeLists.txt

# --- imported target

add_library(netCDF::netcdff INTERFACE IMPORTED)
target_include_directories(netCDF::netcdff INTERFACE ${netCDF_Fortran_INCLUDE_DIRS})
target_link_libraries(netCDF::netcdff INTERFACE ${netCDF_Fortran_LIBRARIES} netCDF::netcdf)

add_dependencies(netCDF::netcdff NETCDF_FORTRAN)

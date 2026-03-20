message(STATUS "${PROJECT_NAME} ${PROJECT_VERSION} CMake ${CMAKE_VERSION} Toolchain ${CMAKE_TOOLCHAIN_FILE}")

option(nc4fortran_coverage "Code coverage tests")
option(nc4fortran_tidy "Run clang-tidy on the code")

option(nc4fortran_find_hdf5 "find HDF5 libraries" ON)
option(nc4fortran_find_netcdf "find NetCDF libraries" ON)

option(nc4fortran_BUILD_TESTING "Build tests" ${nc4fortran_IS_TOP_LEVEL})

option(nc4fortran_IGNORE_CONDA_LIBRARIES "Ignore libraries in CONDA_PREFIX when finding dependencies" ON)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

if(nc4fortran_IS_TOP_LEVEL AND CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set_property(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE "${PROJECT_BINARY_DIR}/local")
endif()

# builds HDF5 library from scratch

include(ExternalProject)

if(hdf5_parallel)
  find_package(MPI REQUIRED COMPONENTS C)
endif()

# pass MPI hints to HDF5
if(NOT MPI_ROOT AND DEFINED ENV{MPI_ROOT})
  set(MPI_ROOT $ENV{MPI_ROOT})
endif()

include(${CMAKE_CURRENT_LIST_DIR}/zlib.cmake)

# --- HDF5
# https://forum.hdfgroup.org/t/issues-when-using-hdf5-as-a-git-submodule-and-using-cmake-with-add-subdirectory/7189/2

set(hdf5_cmake_args
-DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON
-DZLIB_USE_EXTERNAL:BOOL=OFF
-DZLIB_LIBRARY:FILEPATH=${ZLIB_LIBRARIES}
-DZLIB_INCLUDE_DIR:PATH=${ZLIB_INCLUDE_DIRS}
-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
-DCMAKE_MODULE_PATH:PATH=${CMAKE_MODULE_PATH}
-DHDF5_GENERATE_HEADERS:BOOL=false
-DHDF5_DISABLE_COMPILER_WARNINGS:BOOL=true
-DBUILD_STATIC_LIBS:BOOL=$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
-DHDF5_BUILD_FORTRAN:BOOL=true
-DHDF5_BUILD_CPP_LIB:BOOL=false
-DBUILD_TESTING:BOOL=false
-DHDF5_BUILD_EXAMPLES:BOOL=false
-DUSE_LIBAEC:bool=true
-DHDF5_BUILD_TOOLS:BOOL=$<NOT:$<BOOL:${hdf5_parallel}>>
-DHDF5_ENABLE_PARALLEL:BOOL=$<BOOL:${hdf5_parallel}>
)
# https://github.com/HDFGroup/hdf5/issues/818  for broken ph5diff in HDF5_BUILD_TOOLS
if(MPI_ROOT)
  list(APPEND hdf5_cmake_args -DMPI_ROOT:PATH=${MPI_ROOT})
endif()

string(JSON hdf5_url GET ${json} hdf5 url)
if(NOT hdf5_tag)
  string(JSON hdf5_tag GET ${json} hdf5 tag)
endif()

ExternalProject_Add(HDF5
GIT_REPOSITORY ${hdf5_url}
GIT_TAG ${hdf5_tag}
GIT_SHALLOW true
CMAKE_ARGS ${hdf5_cmake_args}
DEPENDS ZLIB
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 60
)

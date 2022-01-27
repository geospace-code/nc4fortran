include(ExternalProject)

if(NOT nc4fortran_external)
  find_package(nc4fortran CONFIG)

  if(nc4fortran_FOUND)
    message(STATUS: "nc4fortran found: ${nc4fortran_DIR}")
    return()
  endif()
endif()

set(nc4fortran_external true CACHE BOOL "Build nc4fortran")

find_package(NetCDF REQUIRED COMPONENTS Fortran)

if(NOT nc4fortran_ROOT)
  set(nc4fortran_ROOT ${CMAKE_INSTALL_PREFIX})
endif()

set(nc4fortran_INCLUDE_DIRS ${nc4fortran_ROOT}/include)

if(BUILD_SHARED_LIBS)
  set(nc4fortran_LIBRARIES ${nc4fortran_ROOT}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}nc4fortran${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(nc4fortran_LIBRARIES ${nc4fortran_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}nc4fortran${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

set(nc4fortran_cmake_args
-DCMAKE_INSTALL_PREFIX=${nc4fortran_ROOT}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=Release
-DBUILD_TESTING:BOOL=false
-Dautobuild:BOOL=false
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
)

ExternalProject_Add(NC4FORTRAN
SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
CMAKE_ARGS ${nc4fortran_cmake_args}
CMAKE_GENERATOR ${EXTPROJ_GENERATOR}
BUILD_BYPRODUCTS ${nc4fortran_LIBRARIES}
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD ON
)

file(MAKE_DIRECTORY ${nc4fortran_INCLUDE_DIRS})

if(BUILD_SHARED_LIBS)
  add_library(nc4fortran::nc4fortran SHARED IMPORTED)
else()
  add_library(nc4fortran::nc4fortran STATIC IMPORTED)
endif()

set_target_properties(nc4fortran::nc4fortran PROPERTIES IMPORTED_LOCATION ${nc4fortran_LIBRARIES})
target_include_directories(nc4fortran::nc4fortran INTERFACE ${nc4fortran_INCLUDE_DIRS})
target_link_libraries(nc4fortran::nc4fortran INTERFACE NetCDF::NetCDF_Fortran)

# race condition for linking without this
add_dependencies(nc4fortran::nc4fortran NC4FORTRAN)

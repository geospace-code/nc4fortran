cmake_minimum_required(VERSION 3.3)
project(nc4fortran Fortran)
enable_testing()

if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-fimplicit-none)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  add_compile_options(-warn declarations)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  add_compile_options(-Mdclchk)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/netcdf.cmake)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR})

add_subdirectory(src)

# --- install

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  if(WIN32)
    set(HOME $ENV{USERPROFILE})
  else()
    set(HOME $ENV{HOME})
  endif()

  set(CMAKE_INSTALL_PREFIX "${HOME}/.local/nc4fortran" CACHE PATH "..." FORCE)
endif()

install(TARGETS nc4fortran
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES ${CMAKE_BINARY_DIR}/nc4fortran.mod DESTINATION ${CMAKE_INSTALL_PREFIX})
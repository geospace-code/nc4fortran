set(SRC_DIR ${netcdf_fortran_SOURCE_DIR})

set(_cmakelists "${SRC_DIR}/CMakeLists.txt")
if(NOT EXISTS "${_cmakelists}")
  message(FATAL_ERROR "Missing file: ${_cmakelists}")
endif()

file(READ "${_cmakelists}" _nc4f_cmake)

string(REPLACE "ENABLE_TESTING()" "" _nc4f_cmake "${_nc4f_cmake}")
string(REPLACE "INCLUDE(CTest)" "" _nc4f_cmake "${_nc4f_cmake}")

# netcdf-fortran 4.6.2 uses CHECK_LIBRARY_EXISTS(${NETCDF_C_LIBRARY} ...),
# but netcdf-c's CMake package exports netCDF::netcdf as a target string.
# CHECK_LIBRARY_EXISTS cannot resolve that imported target inside try_compile.
string(REPLACE
  "CHECK_LIBRARY_EXISTS(\${NETCDF_C_LIBRARY} nccreate \"\" USE_NETCDF_V2)"
  "set(USE_NETCDF_V2 ON)"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

string(REPLACE
  "CHECK_LIBRARY_EXISTS(\${NETCDF_C_LIBRARY} nc_set_log_level \"\" USE_LOGGING)"
  "set(USE_LOGGING OFF)"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

string(REPLACE
  "CHECK_LIBRARY_EXISTS(\${NETCDF_C_LIBRARY} oc_open \"\" BUILD_DAP)"
  "set(BUILD_DAP OFF)"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

string(REPLACE
  "CHECK_LIBRARY_EXISTS(\${NETCDF_C_LIBRARY} nc_def_var_szip \"\" HAVE_DEF_VAR_SZIP)"
  "set(HAVE_DEF_VAR_SZIP ON)"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

string(REPLACE
  "  LINK_LIBRARIES netCDF::netcdf\n"
  ""
  _nc4f_cmake
  "${_nc4f_cmake}"
)

# When netcdf-fortran is used as a FetchContent subproject, use local source
# and binary roots for generated helper scripts and templates.
string(REPLACE
  "\${CMAKE_SOURCE_DIR}"
  "\${CMAKE_CURRENT_SOURCE_DIR}"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

string(REPLACE
  "\${CMAKE_BINARY_DIR}"
  "\${CMAKE_CURRENT_BINARY_DIR}"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

string(REPLACE
  "ADD_SUBDIRECTORY(docs)"
  "# Disabled for FetchContent superbuild to avoid custom target name collisions\n# ADD_SUBDIRECTORY(docs)"
  _nc4f_cmake
  "${_nc4f_cmake}"
)

file(WRITE "${_cmakelists}" "${_nc4f_cmake}")

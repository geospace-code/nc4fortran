
option(netcdf_external "Build HDF5 library")
option(dev "developer mode")

set(CMAKE_EXPORT_COMPILE_COMMANDS true)

set(CMAKE_TLS_VERIFY true)

if(dev)

else()
  set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

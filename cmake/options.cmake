
option(netcdf_external "Build HDF5 library")
option(dev "developer mode")

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

if(NOT dev)
  set(EP_UPDATE_DISCONNECTED true)
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

message(STATUS "${PROJECT_NAME} ${PROJECT_VERSION} CMake ${CMAKE_VERSION} Toolchain ${CMAKE_TOOLCHAIN_FILE}")

option(ENABLE_COVERAGE "Code coverage tests")
option(tidy "Run clang-tidy on the code")
option(find "find NetCDF libraries" ON)


option(${PROJECT_NAME}_BUILD_TESTING "Build tests" ON)
option(CMAKE_TLS_VERIFY "Verify TLS certificates when downloading libraries" ON)


if(nc4fortran_IS_TOP_LEVEL AND CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  # will not take effect without FORCE
  # CMAKE_BINARY_DIR in case it's used from FetchContent
  set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/local CACHE PATH "Install top-level directory" FORCE)
endif()

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

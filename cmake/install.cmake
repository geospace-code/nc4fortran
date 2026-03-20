# --- BOILERPLATE: install / packaging

include(CMakePackageConfigHelpers)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/config.cmake.in
${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Config.cmake
INSTALL_DESTINATION cmake
)

write_basic_package_version_file(
${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}ConfigVersion.cmake
COMPATIBILITY SameMajorVersion
)

install(EXPORT ${PROJECT_NAME}-targets
NAMESPACE ${PROJECT_NAME}::
DESTINATION cmake
)

install(FILES
${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Config.cmake
${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}ConfigVersion.cmake
DESTINATION cmake
)

# don't do this, it makes error
# Target "nc4fortran" references imported target "netCDF::netcdff" which does not come from any known package
# have to figure out correct way to export netCDF targets, maybe with EXPORT_FIND_PACKAGE_NAME but that's experimental

# if(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3")
#   install(PACKAGE_INFO ${PROJECT_NAME} EXPORT ${PROJECT_NAME}-targets)
# endif()

# --- CPack

set(CPACK_GENERATOR "TBZ2")
set(CPACK_SOURCE_GENERATOR "TBZ2")
set(CPACK_PACKAGE_VENDOR "SciVision")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libnetcdff-dev")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")

# not .gitignore as its regex syntax is more advanced than CMake
set(CPACK_SOURCE_IGNORE_FILES .git/ .github/ .vscode/ .mypy_cache/ _CPack_Packages/
${CMAKE_BINARY_DIR}/ ${PROJECT_BINARY_DIR}/
archive/ concepts/
)

install(FILES ${CPACK_RESOURCE_FILE_README} ${CPACK_RESOURCE_FILE_LICENSE}
DESTINATION share/docs/${PROJECT_NAME}
)

include(CPack)

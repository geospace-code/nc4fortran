add_executable(test_errors test_errors.f90)
target_link_libraries(test_errors PRIVATE netcdf_interface)
add_test(NAME Errors COMMAND $<TARGET_FILE:test_errors> ${CMAKE_CURRENT_BINARY_DIR})
set_tests_properties(Errors PROPERTIES TIMEOUT 10 SKIP_RETURN_CODE 77)
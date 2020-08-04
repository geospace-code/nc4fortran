add_executable(test_array test_array.f90)
target_link_libraries(test_array nc4fortran::nc4fortran)
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  target_compile_options(test_array PRIVATE -Wno-compare-reals)
endif()
add_test(NAME nc4fortran:array COMMAND $<TARGET_FILE:test_array>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_attributes test_attributes.f90)
target_link_libraries(test_attributes nc4fortran::nc4fortran)
if(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  target_compile_options(test_attributes PRIVATE -Wno-compare-reals)
endif()
add_test(NAME nc4fortran:attributes COMMAND $<TARGET_FILE:test_attributes>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_error test_error.f90)
target_link_libraries(test_error nc4fortran::nc4fortran)
add_test(NAME nc4fortran:error COMMAND $<TARGET_FILE:test_error>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_exist test_exist.f90)
target_link_libraries(test_exist PRIVATE nc4fortran::nc4fortran)
add_test(NAME nc4fortran:test_exist COMMAND $<TARGET_FILE:test_exist>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_scalar test_scalar.f90)
target_link_libraries(test_scalar PRIVATE nc4fortran::nc4fortran)
add_test(NAME nc4fortran:test_scalar COMMAND $<TARGET_FILE:test_scalar>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_string test_string.f90)
target_link_libraries(test_string nc4fortran::nc4fortran)
add_test(NAME nc4fortran:test_string COMMAND $<TARGET_FILE:test_string>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_shape test_shape.f90)
target_link_libraries(test_shape PRIVATE nc4fortran::nc4fortran)
add_test(NAME nc4fortran:shape_check COMMAND $<TARGET_FILE:test_shape>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

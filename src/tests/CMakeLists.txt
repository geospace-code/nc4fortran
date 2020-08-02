set(tmpdir ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_io test_io.f90)
target_link_libraries(test_io nc4fortran::nc4fortran)
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  target_compile_options(test_io PRIVATE -Wno-compare-reals)
endif()
add_test(NAME nc4fortran:readwrite COMMAND $<TARGET_FILE:test_io> ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_attr test_attr.f90)
target_link_libraries(test_attr nc4fortran::nc4fortran)
add_test(NAME nc4fortran:attributes COMMAND $<TARGET_FILE:test_attr> ${CMAKE_CURRENT_BINARY_DIR})
if(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  target_compile_options(test_attr PRIVATE -Wno-compare-reals)
endif()

add_executable(test_errors test_errors.f90)
target_link_libraries(test_errors nc4fortran::nc4fortran)
add_test(NAME nc4fortran:errors COMMAND $<TARGET_FILE:test_errors> ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_exist test_exist.f90)
target_link_libraries(test_exist PRIVATE nc4fortran::nc4fortran)
add_test(NAME nc4fortran:test_exist COMMAND $<TARGET_FILE:test_exist> ${tmpdir})

add_executable(test_string test_string.f90)
target_link_libraries(test_string nc4fortran::nc4fortran)
add_test(NAME nc4fortran:test_string COMMAND $<TARGET_FILE:test_string> ${tmpdir})

add_executable(test_shape test_shape.f90)
target_link_libraries(test_shape PRIVATE nc4fortran::nc4fortran)
add_test(NAME nc4fortran:shape_check COMMAND $<TARGET_FILE:test_shape> ${tmpdir})

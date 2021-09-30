add_executable(test_minimal test_minimal.f90)
target_link_libraries(test_minimal PRIVATE nc4fortran::nc4fortran)
set_target_properties(test_minimal PROPERTIES LABELS unit)
add_test(NAME nc4fortran:minimal COMMAND $<TARGET_FILE:test_minimal>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
set_tests_properties(nc4fortran:minimal PROPERTIES
  FIXTURES_SETUP nclib
  LABELS core)

foreach(t array attributes deflate destructor error exist scalar shape string)
  add_executable(test_${t} test_${t}.f90)
  target_link_libraries(test_${t} PRIVATE nc4fortran::nc4fortran)
  set_target_properties(test_${t} PROPERTIES LABELS unit)
  target_compile_options(test_${t} PRIVATE "$<$<Fortran_COMPILER_ID:GNU>:-Wno-compare-reals>")

  add_test(NAME nc4fortran:${t} COMMAND $<TARGET_FILE:test_${t}> WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  set_tests_properties(nc4fortran:${t} PROPERTIES
    FIXTURES_REQUIRED nclib
    LABELS unit)
endforeach()

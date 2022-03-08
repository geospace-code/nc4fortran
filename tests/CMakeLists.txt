set_directory_properties(PROPERTIES LABELS nc4fortran)

add_executable(test_minimal test_minimal.f90)
target_link_libraries(test_minimal PRIVATE nc4fortran::nc4fortran)
set_target_properties(test_minimal PROPERTIES LABELS unit)
add_test(NAME minimal COMMAND $<TARGET_FILE:test_minimal>
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
set_tests_properties(minimal PROPERTIES
FIXTURES_SETUP nclib
LABELS core
)

foreach(t array attributes deflate destructor error exist scalar shape string version)
  add_executable(test_${t} test_${t}.f90)
  target_link_libraries(test_${t} PRIVATE nc4fortran::nc4fortran)
  set_target_properties(test_${t} PROPERTIES LABELS unit)
  target_compile_options(test_${t} PRIVATE "$<$<Fortran_COMPILER_ID:GNU>:-Wno-compare-reals>")

  if(${t} STREQUAL version)
    add_test(NAME ${t} COMMAND test_${t} ${NetCDF_VERSION})
  else()
    add_test(NAME ${t} COMMAND test_${t})
  endif()

  set_tests_properties(${t} PROPERTIES
  FIXTURES_REQUIRED nclib
  LABELS unit
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
endforeach()


if(ENABLE_COVERAGE)
setup_target_for_coverage_gcovr_html(
NAME coverage
EXECUTABLE ${CMAKE_CTEST_COMMAND}
)
endif()

# --- Windows shared DLLs
if(WIN32)
  add_custom_command(TARGET test_minimal POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:test_minimal> $<TARGET_FILE_DIR:test_minimal>
  COMMAND_EXPAND_LISTS
  )
endif()

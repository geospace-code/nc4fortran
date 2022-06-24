set_directory_properties(PROPERTIES LABELS nc4fortran)

add_executable(test_minimal test_minimal.f90)
target_link_libraries(test_minimal PRIVATE nc4fortran::nc4fortran)
set_target_properties(test_minimal PROPERTIES LABELS unit)
add_test(NAME minimal COMMAND test_minimal
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
set_tests_properties(minimal PROPERTIES
FIXTURES_SETUP nclib
LABELS core
)

set(test_names array attributes
deflate_write deflate_read deflate_props
destructor error exist fill scalar shape string version)
foreach(t IN LISTS test_names)
  add_executable(test_${t} test_${t}.f90)
  target_link_libraries(test_${t} PRIVATE nc4fortran::nc4fortran)
  set_target_properties(test_${t} PROPERTIES LABELS unit)
  target_compile_options(test_${t} PRIVATE "$<$<Fortran_COMPILER_ID:GNU>:-Wno-compare-reals>")

  if(${t} STREQUAL "version")
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

set_tests_properties(deflate_write PROPERTIES
FIXTURES_SETUP deflate_files
)

set_tests_properties(deflate_props deflate_read PROPERTIES
FIXTURES_REQUIRED deflate_files
REQUIRED_FILES ${CMAKE_CURRENT_BINARY_DIR}/deflate1.nc
)


if(ENABLE_COVERAGE)
setup_target_for_coverage_gcovr_html(
NAME coverage
EXECUTABLE ${CMAKE_CTEST_COMMAND}
)
endif()

# --- Windows shared DLLs
if(WIN32 AND CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
  set_tests_properties(minimal ${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION "PATH=path_list_append:${NetCDF_Fortran_INCLUDE_DIRS}/../bin"
  )
endif()

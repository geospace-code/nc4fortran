set_directory_properties(PROPERTIES LABELS nc4fortran)

# avoid nuisance test build warnings
add_compile_options("$<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wno-compare-reals;-Wno-maybe-uninitialized>")

add_executable(test_minimal test_minimal.f90)
target_link_libraries(test_minimal PRIVATE nc4fortran::nc4fortran)
add_test(NAME minimal COMMAND test_minimal
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


set(test_names array attributes
deflate_write deflate_read deflate_props
destructor error exist fill scalar shape string version)

foreach(t IN LISTS test_names)
  add_executable(test_${t} test_${t}.f90)
  target_link_libraries(test_${t} PRIVATE nc4fortran::nc4fortran)

  if(${t} STREQUAL "version")
    add_test(NAME ${t} COMMAND test_${t} ${NetCDF_VERSION})
  else()
    add_test(NAME ${t} COMMAND test_${t})
  endif()

endforeach()

set_property(TEST ${test_names} PROPERTY LABELS unit)
set_property(TEST ${test_names} PROPERTY WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

set_property(TEST deflate_write PROPERTY FIXTURES_SETUP deflate_files)

set_property(TEST deflate_props deflate_read PROPERTY FIXTURES_REQUIRED deflate_files)
set_property(TEST deflate_props deflate_read PROPERTY REQUIRED_FILES ${CMAKE_CURRENT_BINARY_DIR}/deflate1.nc)


if(${PROJECT_NAME}_COVERAGE)
setup_target_for_coverage_gcovr_html(
NAME coverage
EXECUTABLE ${CMAKE_CTEST_COMMAND}
)
endif()

# --- NetCDF shared lib paths needed
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
  if(WIN32)
    set_property(TEST minimal ${test_names} PROPERTY
    ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:${NetCDF_Fortran_INCLUDE_DIRS}/../bin"
    )
  elseif(APPLE)
    set_property(TEST minimal ${test_names} PROPERTY
    ENVIRONMENT_MODIFICATION "DYLD_LIBRARY_PATH=path_list_prepend:${NetCDF_Fortran_INCLUDE_DIRS}/../lib"
    )
  else()
    set_property(TEST minimal ${test_names} PROPERTY
    ENVIRONMENT_MODIFICATION "LD_LIBRARY_PATH=path_list_prepend:${NetCDF_Fortran_INCLUDE_DIRS}/../lib"
    )
  endif()
endif()

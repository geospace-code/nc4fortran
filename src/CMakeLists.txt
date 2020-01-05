add_library(nc4fortran netcdf4_interface.f90 read.f90 reader.f90 write.f90 writer.f90 string_utils.f90)
target_link_libraries(nc4fortran PRIVATE ${NetCDF_LIBRARIES})
target_include_directories(nc4fortran PRIVATE ${NetCDF_INCLUDE_DIRS})
set_target_properties(nc4fortran PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}
  ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_subdirectory(tests)

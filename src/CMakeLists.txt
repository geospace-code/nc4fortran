add_library(netcdf_interface netcdf4_interface.f90 read.f90 reader.f90 write.f90 writer.f90 string_utils.f90)
target_link_libraries(netcdf_interface PRIVATE ${NetCDF_LIBRARIES})
target_include_directories(netcdf_interface PRIVATE ${NetCDF_INCLUDE_DIRS})

add_subdirectory(tests)

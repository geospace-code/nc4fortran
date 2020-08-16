
set(is_windows .false.)
if(WIN32)
  set(is_windows .true.)
endif()
configure_file(pathlib.in.f90 pathlib.f90)

file(READ reader_template.in.f90 reader_template)
configure_file(reader.in.f90 reader.f90)

file(READ writer_template.in.f90 writer_template)
configure_file(writer.in.f90 writer.f90)

target_sources(nc4fortran PRIVATE
interface.f90 attributes.f90
read.f90 ${CMAKE_CURRENT_BINARY_DIR}/reader.f90
write.f90 ${CMAKE_CURRENT_BINARY_DIR}/writer.f90
${CMAKE_CURRENT_BINARY_DIR}/pathlib.f90)

file(READ reader_template.in.f90 reader_template)
configure_file(reader.in.f90 reader.f90 @ONLY)

file(READ writer_template_r32.in.f90 writer_template_r32)
file(READ writer_template_r64.in.f90 writer_template_r64)
file(READ writer_template_i32.in.f90 writer_template_i32)
file(READ writer_template_i64.in.f90 writer_template_i64)
configure_file(writer.in.f90 writer.f90 @ONLY)

set_directory_properties(PROPERTIES CMAKE_CONFIGURE_DEPENDS
"reader_template.in.f90;writer_template_r32.in.f90;writer_template_r64.in.f90;writer_template_i32.in.f90;writer_template_i64.in.f90")

target_sources(nc4fortran PRIVATE
interface.f90
read.f90 ${CMAKE_CURRENT_BINARY_DIR}/reader.f90
write.f90 ${CMAKE_CURRENT_BINARY_DIR}/writer.f90
attributes.f90
)

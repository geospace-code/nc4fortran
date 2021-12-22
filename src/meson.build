configure_file(
input : 'reader.in.f90',
output : 'reader.f90',
configuration : {'reader_template': fs.read('reader_template.f90')}
)

configure_file(
input : 'writer.in.f90',
output : 'writer.f90',
configuration : {
  'writer_template': fs.read('writer_template.f90')
}
)

nc4_src = files('interface.f90', 'attributes.f90',
'read.f90', meson.current_build_dir() / 'reader.f90',
'write.f90', meson.current_build_dir() / 'writer.f90'
)

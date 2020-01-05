netcdf_interface = library('netcdf_interface',
  sources: ['netcdf4_interface.f90', 'read.f90', 'reader.f90', 'write.f90', 'writer.f90', 'string_utils.f90'],
  dependencies: netcdf,
  install: true)

if not meson.is_subproject()
  subdir('tests')
endif

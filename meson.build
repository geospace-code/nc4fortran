project('nc4fortran', 'fortran',
  meson_version : '>=0.52.0',
  version: '1.1.3',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=3'])

subdir('meson')

subdir('src')

oonc = library('nc4fortran',
  sources: nc4_src,
  dependencies: netcdf,
  install: true)

netcdf_interface = declare_dependency(link_with: oonc, dependencies: netcdf)

# --- testing
if not meson.is_subproject()
  subdir('src/tests')
endif

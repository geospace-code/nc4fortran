project('nc4fortran', 'fortran',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=3'])

fc = meson.get_compiler('fortran')
os = host_machine.system()

# when using CMake, need to capitalize module name like in CMake
netcdf = [dependency('netcdf', language: 'fortran', required : false, disabler: true, cmake_module_path : 'cmake/Modules')]
if os == 'darwin'  # homebrew has broken PkgConfig for NetCDF, the test below is false OK without this
  netcdf += fc.find_library('netcdff', dirs: '/usr/local/opt/netcdf/lib', required : false, disabler: true)
endif

if not fc.links('use netcdf, only : nf90_inq_varid; end', name: 'NetCDF', dependencies : netcdf)
  netcdf = [disabler()]
endif

if not meson.is_subproject()
  assert(netcdf[0].found(), 'NetCDF Fortran is required')
endif

subdir('src')

netcdf_interface = library('netcdf_interface',
  sources: nc4_src,
  dependencies: netcdf,
  install: true)

if not meson.is_subproject()
  subdir('src/tests')
endif
project('nc4fortran', 'fortran',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=3'])

fc = meson.get_compiler('fortran')

# when using CMake, need to capitalize module name like in CMake
netcdf = dependency('netcdf', language: 'fortran', required : false, disabler: true, cmake_module_path : 'cmake/Modules')

if not fc.links('use netcdf; end', name: 'NetCDF', dependencies : netcdf)
  netcdf = disabler()
endif

if not meson.is_subproject()
  assert(netcdf.found(), 'NetCDF Fortran is required')
endif

subdir('src')
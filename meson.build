project('nc4fortran', 'fortran',
  meson_version : '>=0.57.0',
  version: files('VERSION'),
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=3'])

fs = import('fs')

# --- find netcdf
fc = meson.get_compiler('fortran')
os = host_machine.system()

quiet = fc.get_supported_arguments(['-w', '-Wno-compare-reals', '-Wno-maybe-uninitialized'])

# -- stub for future > 7-D
# f08rank15 = fc.links('real, dimension(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1) :: x; end', name: 'f2008 rank 15')

#== find NetCDF

netcdf = dependency('netcdf', language: 'fortran', required : false, disabler: true, cmake_module_path : 'cmake/Modules')

if not meson.is_subproject()
  assert(netcdf.found(), 'NetCDF Fortran is required')
endif

# ---

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

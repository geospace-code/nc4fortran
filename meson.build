project('nc4fortran', 'fortran',
  meson_version : '>=0.52.0',
  version: '1.2.0',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=3'])

# --- find netcdf
fc = meson.get_compiler('fortran')
os = host_machine.system()

quiet = fc.get_supported_arguments(['-w', '-Wno-compare-reals', '-Wno-maybe-uninitialized'])

# -- stub for future > 7-D
# f08rank15 = fc.links('real, dimension(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1) :: x; end', name: 'f2008 rank 15')

#== find NetCDF

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

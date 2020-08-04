test_io = executable('test_io', 'test_io.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('ReadWrite', test_io,  args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_attr = executable('test_attributes', 'test_attributes.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('attributes', test_attr, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_error = executable('test_error', 'test_error.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('errors', test_error, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_exist = executable('test_exist', 'test_exist.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('exist', test_exist, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_str = executable('test_string', 'test_string.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('string', test_str, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_shape = executable('test_shape', 'test_shape.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('shape', test_shape, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_array = executable('test_array', 'test_array.f90', dependencies: netcdf_interface)
test('array', test_array, suite: 'nc4basic', timeout: 10)

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

test_scalar = executable('test_scalar', 'test_scalar.f90', dependencies: netcdf_interface)
test('scalar', test_scalar, suite: 'nc4basic', timeout: 10)

test_shape = executable('test_shape', 'test_shape.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('shape', test_shape,
is_parallel : false,
timeout: 10, suite: 'nc4basic')

test_str = executable('test_string', 'test_string.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('string', test_str, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

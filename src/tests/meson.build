test_io = executable('test_io', 'test_io.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('ReadWrite', test_io,  args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_attr = executable('test_attr', 'test_attr.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('attributes', test_attr, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

test_errors = executable('test_errors', 'test_errors.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('errors', test_errors, args: meson.current_build_dir(), timeout: 10, suite: 'nc4basic')

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

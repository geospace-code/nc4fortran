test_io = executable('test_io', 'test_io.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('ReadWrite', test_io,
  args: meson.current_build_dir(),
  timeout: 10)

test_errors = executable('test_errors', 'test_errors.f90',
  fortran_args: quiet,
  dependencies: netcdf_interface)
test('Errors', test_errors,
  args: meson.current_build_dir(),
  timeout: 10)

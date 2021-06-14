test_minimal = executable('test_minimal', 'test_minimal.f90',
  dependencies: netcdf_interface)
test('minimal', test_minimal,
  args: meson.current_build_dir(),
  suite: 'nc4basic',
  priority: 100,
  timeout: 10)

foreach t : ['array', 'attributes', 'deflate', 'destructor', 'error', 'exist', 'scalar', 'shape', 'string']

  e = executable('test_'+t, 'test_' + t + '.f90', dependencies: netcdf_interface, fortran_args: quiet)
  if t == 'shape'
    par = false
    pri = 50
  else
    par = true
    pri = 0
  endif
  test(t, e, suite: 'h5basic', timeout: 10, is_parallel: par, priority: pri)
endforeach

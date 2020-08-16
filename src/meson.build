conf_data = configuration_data()

is_windows = os == 'windows' ? '.true.' : '.false.'

conf_data.set('is_windows', is_windows)
configure_file(
  input : 'pathlib.in.f90',
  output : 'pathlib.f90',
  configuration : conf_data)

python = find_program('python')

ret = run_command(python, '-c', 'print(open("' + meson.current_source_dir() / 'reader_template.in.f90' + '").read())')
reader_template = configuration_data()
reader_template.set('reader_template', ret.stdout())
configure_file(
  input : 'reader.in.f90',
  output : 'reader.f90',
  configuration : reader_template
)

ret = run_command(python, '-c', 'print(open("' + meson.current_source_dir() / 'writer_template.in.f90' + '").read())')
writer_template = configuration_data()
writer_template.set('writer_template', ret.stdout())
configure_file(
  input : 'writer.in.f90',
  output : 'writer.f90',
  configuration : writer_template
)

nc4_src = files('interface.f90', 'attributes.f90',
  'read.f90', meson.current_build_dir() / 'reader.f90',
  'write.f90', meson.current_build_dir() / 'writer.f90',
  meson.current_build_dir() / 'pathlib.f90')

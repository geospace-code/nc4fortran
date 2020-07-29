conf_data = configuration_data()

is_windows = os == 'windows' ? '.true.' : '.false.'

conf_data.set('is_windows', is_windows)
configure_file(
  input : 'pathlib.in.f90',
  output : 'pathlib.f90',
  configuration : conf_data)

reader_template = configuration_data()
reader_template.set('reader_template',
'''
integer :: varid, ier

if(.not.self%is_open) error stop 'ERROR:nc4fortran:reader file handle not open'

ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
'''
)
configure_file(
  input : 'reader.in.f90',
  output : 'reader.f90',
  configuration : reader_template
)

nc4_src = files('interface.f90',
  'read.f90', meson.current_build_dir() / 'reader.f90',
  'write.f90', 'writer.f90',
  'string_utils.f90', meson.current_build_dir() / 'pathlib.f90')

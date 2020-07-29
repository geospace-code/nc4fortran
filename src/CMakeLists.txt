
if(WIN32)
  set(is_windows .true.)
else()
  set(is_windows .false.)
endif()
configure_file(pathlib.in.f90 pathlib.f90)

set(reader_template "
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
")
configure_file(reader.in.f90 reader.f90)

set(writer_template "
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

select type (value)
type is (real(real64))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
class default
  ierr = NF90_EBADTYPE
end select

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
")
configure_file(writer.in.f90 writer.f90)

target_sources(nc4fortran PRIVATE
interface.f90
read.f90 ${CMAKE_CURRENT_BINARY_DIR}/reader.f90
write.f90 ${CMAKE_CURRENT_BINARY_DIR}/writer.f90
string_utils.f90 ${CMAKE_CURRENT_BINARY_DIR}/pathlib.f90)

submodule (netcdf_interface:write) writer

implicit none

contains

module procedure nc_write_scalar
integer :: varid

select type (value)
type is (character(*))
  ierr = nf90_def_var(self%ncid, dname, NF90_CHAR, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_enddef(self%ncid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_enddef(self%ncid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_enddef(self%ncid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_enddef(self%ncid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_enddef(self%ncid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (self%check_error(ierr, dname)) return

end procedure nc_write_scalar


end submodule writer
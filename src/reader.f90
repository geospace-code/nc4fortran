submodule (netcdf_interface:read) reader

implicit none

contains

module procedure nc_read_scalar
integer :: varid
ierr = nf90_inq_varid(self%ncid, dname, varid)
if (self%check_error(ierr, dname)) return

select type (value)
type is (character(*))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (self%check_error(ierr, dname)) return
end procedure nc_read_scalar

end submodule reader
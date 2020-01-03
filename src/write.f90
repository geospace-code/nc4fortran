submodule (netcdf_interface) write
use netcdf, only : nf90_def_dim, nf90_def_var, nf90_enddef, nf90_put_var, nf90_sync

implicit none

contains

module procedure def_dims
!! checks if dimension name exists. if not, create dimension
integer :: i

do i=1,size(dims)
  ierr = nf90_inq_dimid(self%ncid, dimnames(i), dimids(i))
  if(ierr==NF90_NOERR) cycle  !< dimension already exists
  !! create new dimension
  ierr = nf90_def_dim(self%ncid, dimnames(i), dims(i), dimids(i))
  if (self%check_error(ierr, dname)) return
end do

end procedure def_dims


end submodule write
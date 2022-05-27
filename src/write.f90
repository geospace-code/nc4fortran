submodule (nc4fortran) write

use netcdf, only : nf90_float, nf90_double, nf90_int, nf90_int64, nf90_enddef, NF90_CHAR

implicit none (type, external)

contains

module procedure def_dims
!! checks if dimension name exists. if not, create dimension
integer :: i, ierr
character(NF90_MAX_NAME) :: name

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open'

do i=1,size(dims)
  if (present(dimnames)) then
    ierr = nf90_inq_dimid(self%ncid, dimnames(i), dimids(i))
    if(ierr==NF90_NOERR) cycle
    !! dimension already exists
  endif
  !! create new dimension
  if(present(dimnames)) then
    ierr = nf90_def_dim(self%ncid, dimnames(i), dims(i), dimids(i))
  else
    write(name,'(A,A4,I1)') dname,"_dim",i
    ierr = nf90_def_dim(self%ncid, trim(name), dims(i), dimids(i))
    ! print *,trim(name)
  endif
  if (check_error(ierr, dname)) return
end do

end procedure def_dims


end submodule write

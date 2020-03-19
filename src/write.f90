submodule (nc4fortran) write
!! This submodule is for writing NetCDF data via child submodules
implicit none
contains

module procedure def_dims
!! checks if dimension name exists. if not, create dimension
integer :: i, L
character(NF90_MAX_NAME) :: name

do i=1,size(dims)
  if (present(dimnames)) then
    ierr = nf90_inq_dimid(self%ncid, dimnames(i), dimids(i))
  else  ! ensure the dimension exists despite unspecified name
    ierr = nf90_inquire_dimension(self%ncid, dimid=i, name=name, len=L)
  endif
  if(ierr==NF90_NOERR) cycle  !< dimension already exists
  !! create new dimension
  if(present(dimnames)) then
    ierr = nf90_def_dim(self%ncid, dimnames(i), dims(i), dimids(i))
  else
    write(name,'(A,I1)') "dim",i
    ierr = nf90_def_dim(self%ncid, trim(name), dims(i), dimids(i))
    ! print *,trim(name)
  endif
  if (check_error(ierr, dname)) return
end do

end procedure def_dims


module procedure write_attribute
integer :: varid, ier

ier = nf90_inq_varid(self%ncid, dname, varid)

if(ierr == nf90_noerr) ier = nf90_put_att(self%ncid, varid, attrname, value)

if (present(ierr)) ierr = ier
if (check_error(ierr, dname)) then
  if (present(ierr)) return
  error stop
endif

end procedure write_attribute


end submodule write

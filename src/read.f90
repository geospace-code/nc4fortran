submodule (nc4fortran) read
!! This submodule is for reading NetCDF via submodules

implicit none (type, external)

contains


module procedure get_ndims
integer :: varid, ierr

if(.not.self%is_open) error stop 'nc4fortran:read: file handle not open'

drank = -1

ierr = nf90_inq_varid(self%ncid, dname, varid)
if(ierr/=NF90_NOERR) error stop 'nc4fortran:get_ndims: could not get variable ID for ' // dname

ierr = nf90_inquire_variable(self%ncid, varid, ndims=drank)

end procedure get_ndims


module procedure get_shape

integer :: ier, varid, i, N
integer, allocatable :: dimids(:)
character(NF90_MAX_NAME), allocatable :: tempnames(:)

N = self%ndims(dname)
allocate(dimids(N), dims(N))

ier = nf90_inq_varid(self%ncid, dname, varid)
if(check_error(ier, dname)) error stop 'nc4fortran:get_shape: could not get variable ID for: ' // dname

ier = nf90_inquire_variable(self%ncid, varid, dimids = dimids)
if(check_error(ier, dname)) error stop 'nc4fortran:get_shape: could not get dimension IDs for: ' // dname

if (present(dimnames)) allocate(tempnames(N))

do i = 1,N
  if(present(dimnames)) then
    ier = nf90_inquire_dimension(self%ncid, dimid=dimids(i), name=tempnames(i), len=dims(i))
  else
    ier = nf90_inquire_dimension(self%ncid, dimid=dimids(i), len=dims(i))
  endif
  if(ier/=NF90_NOERR) error stop 'nc4fortran:get_shape: querying dimension size'
enddo

if (present(dimnames)) then
  allocate(dimnames(N))
  dimnames = tempnames
endif

end procedure get_shape


module procedure nc_check_exist
integer :: varid, ierr

exists = .false.

if(.not.self%is_open) error stop 'nc4fortran:exist: file handle not open '

ierr = nf90_inq_varid(self%ncid, dname, varid)

select case (ierr)
case (NF90_NOERR)
  exists = .true.
case (NF90_EBADID)
  write(stderr,*) 'check_exist: ERROR: is file initialized?  ', self%filename
case (NF90_ENOTVAR)
  if (self%verbose) write(stderr,*) dname, ' does not exist in ', self%filename
case default
  write(stderr,*) 'check_exist: ERROR unknown problem ', self%filename
end select

end procedure nc_check_exist


module procedure nc_exist

type(netcdf_file) :: h

call h%initialize(filename, status='old', action='r')
nc_exist = h%exist(dname)
call h%finalize()

end procedure nc_exist

end submodule read

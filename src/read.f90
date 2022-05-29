submodule (nc4fortran) read

use, intrinsic :: iso_c_binding, only : c_null_char

implicit none (type, external)

contains


module procedure get_chunk

logical :: contig
integer :: i, varid

chunk_size = -1

i = nf90_inq_varid(self%ncid, dname, varid)
if (i/=NF90_NOERR) error stop 'ERROR:nc4fortran:chunk: cannot find variable: ' // dname

i = nf90_inquire_variable(self%ncid, varid, contiguous=contig)
if (i/=NF90_NOERR) error stop 'ERROR:nc4fortran:chunk: cannot get variable properties' // dname

if(contig) return
i = nf90_inquire_variable(self%ncid, varid, chunksizes=chunk_size)
if (i/=NF90_NOERR) error stop 'ERROR:nc4fortran:chunk: cannot get variable properties' // dname

end procedure get_chunk


module procedure get_deflate

logical :: contig
integer :: i, varid, deflate_level

get_deflate = .false.

i = nf90_inq_varid(self%ncid, dname, varid)
if (i/=NF90_NOERR) error stop 'ERROR:nc4fortran:get_deflate: cannot find variable: ' // dname

i = nf90_inquire_variable(self%ncid, varid, contiguous=contig)
if (i/=NF90_NOERR) error stop 'ERROR:nc4fortran:get_deflate: cannot get variable properties' // dname

if(contig) return
i = nf90_inquire_variable(self%ncid, varid, deflate_level=deflate_level)
if (i/=NF90_NOERR) error stop 'ERROR:nc4fortran:get_deflate: cannot get variable properties' // dname

get_deflate = deflate_level /= 0

end procedure get_deflate


module procedure get_ndim
integer :: varid, ierr

if(.not.self%is_open) error stop 'ERROR:nc4fortran:read: file handle not open'

drank = -1

ierr = nf90_inq_varid(self%ncid, dname, varid)
if(ierr/=NF90_NOERR) error stop 'ERROR:nc4fortran:get_ndim: could not get variable ID for ' // dname

ierr = nf90_inquire_variable(self%ncid, varid, ndims=drank)
if(ierr/=NF90_NOERR) error stop 'ERROR:nc4fortran:get_ndim: could not get rank for ' // dname

end procedure get_ndim


module procedure get_shape

integer :: ier, varid, i, N
integer, allocatable :: dimids(:)
character(NF90_MAX_NAME), allocatable :: tempnames(:)

N = self%ndim(dname)

allocate(dimids(N), dims(N))

ier = nf90_inq_varid(self%ncid, dname, varid)
if(check_error(ier, dname)) error stop 'ERROR:nc4fortran:get_shape: could not get variable ID for: ' // dname

ier = nf90_inquire_variable(self%ncid, varid, dimids = dimids)
if(check_error(ier, dname)) error stop 'ERROR:nc4fortran:get_shape: could not get dimension IDs for: ' // dname

if (present(dimnames)) allocate(tempnames(N))

do i = 1,N
  if(present(dimnames)) then
    ier = nf90_inquire_dimension(self%ncid, dimid=dimids(i), name=tempnames(i), len=dims(i))
  else
    ier = nf90_inquire_dimension(self%ncid, dimid=dimids(i), len=dims(i))
  endif
  if(ier/=NF90_NOERR) error stop 'ERROR:nc4fortran:get_shape: querying dimension size'
enddo

if (present(dimnames)) then
  allocate(dimnames(N))
  dimnames = tempnames
endif

end procedure get_shape


module procedure nc_check_exist
integer :: varid, ierr

exists = .false.

if(.not.self%is_open) error stop 'ERROR:nc4fortran:exist: file handle not open '

ierr = nf90_inq_varid(self%ncid, dname, varid)

select case (ierr)
case (NF90_NOERR)
  exists = .true.
case (NF90_EBADID)
  write(stderr,*) 'ERROR:nc4fortran:exist: is file opened?  ', self%filename
case (NF90_ENOTVAR)
  if (self%verbose) write(stderr,*) dname, ' does not exist in ', self%filename
case default
  write(stderr,*) 'ERROR:nc4fortran:exist: unknown problem ', self%filename
end select

end procedure nc_check_exist


module procedure nc_exist

type(netcdf_file) :: h

call h%open(filename, action='r')
nc_exist = h%exist(dname)
call h%close()

end procedure nc_exist

end submodule read

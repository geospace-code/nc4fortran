submodule (nc4fortran) utils

use netcdf, only : NF90_STRERROR

implicit none (type, external)

contains


module procedure nc_open

character(:), allocatable :: laction
integer :: ier

if (self%is_open) then
  write(stderr,*) 'WARNING:nc4fortran:open file handle already open to: '// filename
  return
endif

self%filename = filename

if (present(comp_lvl)) self%comp_lvl = comp_lvl
if (present(verbose)) self%verbose = verbose
if (present(debug)) self%debug = debug

laction = 'rw'
if(present(action)) laction = action

select case(laction)
case('r')
  ier = nf90_open(self%filename, NF90_NOWRITE, self%file_id)
case('r+')
  ier = nf90_open(self%filename, NF90_WRITE, self%file_id)
case('rw', 'a')
  if(is_netcdf(filename)) then
    !! NF90_WRITE is necessary to be in true read/write mode
    ier = nf90_open(self%filename, ior(NF90_WRITE, NF90_NETCDF4), self%file_id)
  else
    ier = nf90_create(self%filename, ior(NF90_CLOBBER, NF90_NETCDF4), self%file_id)
  endif
case('w')
  ier = nf90_create(self%filename, ior(NF90_CLOBBER, NF90_NETCDF4), self%file_id)
case default
  error stop 'nc4fortran: Unsupported action -> ' // laction
end select


if (ier == NF90_NOERR) then
  self%is_open = .true.
  return
endif

error stop 'nc4fortran:ERROR: open ' // filename // ' could not be created'

end procedure nc_open


module procedure destructor
if (.not. self%is_open) return
print *, "auto-closing " // self%filename
call self%close()
end procedure destructor


module procedure nc_close
integer :: ier

if(.not. self%is_open) then
  write(stderr,*) 'WARNING:nc4fortran:close file handle is not open'
  return
endif

ier = nf90_close(self%file_id)
if (ier /= NF90_NOERR) error stop 'ERROR:close: ' // self%filename

self%is_open = .false.

end procedure nc_close


module procedure nc4version
nc4version = nf90_inq_libvers()
end procedure nc4version


module procedure is_contig
integer :: ier, varid

ier = nf90_inq_varid(self%file_id, dname, varid)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_contig: cannot find variable: ' // dname

ier = nf90_inquire_variable(self%file_id, varid, contiguous=is_contig)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_contig: cannot get variable properties' // dname

end procedure is_contig


module procedure is_chunked
integer :: ier, varid

ier = nf90_inq_varid(self%file_id, dname, varid)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_chunked: cannot find variable: ' // dname

ier = nf90_inquire_variable(self%file_id, varid, contiguous=is_chunked)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_chunked: cannot get variable properties' // dname

is_chunked = .not.is_chunked
end procedure is_chunked


module procedure is_netcdf
integer :: ierr, file_id

inquire(file=filename, exist=is_netcdf)
!! avoid warning/error messages
if (.not. is_netcdf) return

ierr = nf90_open(filename, NF90_NOWRITE, file_id)
is_netcdf = ierr == 0

ierr = nf90_close(file_id)

end procedure is_netcdf


module procedure check_error

check_error = code /= NF90_NOERR

if(check_error) write(stderr,'(/,A)') "ERROR:nc4fortran:" // NF90_STRERROR(code)

end procedure check_error


end submodule utils

submodule (nc4fortran) utils

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
  ier = nf90_open(self%filename, NF90_NOWRITE, self%ncid)
case('r+')
  ier = nf90_open(self%filename, NF90_NETCDF4, self%ncid)
case('rw', 'a')
  if(is_netcdf(filename)) then
    !! NF90_WRITE is necessary to be in true read/write mode
    ier = nf90_open(self%filename, ior(NF90_WRITE, NF90_NETCDF4), self%ncid)
  else
    ier = nf90_create(self%filename, ior(NF90_CLOBBER, NF90_NETCDF4), self%ncid)
  endif
case('w')
  ier = nf90_create(self%filename, ior(NF90_CLOBBER, NF90_NETCDF4), self%ncid)
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

ier = nf90_close(self%ncid)
if (ier /= NF90_NOERR) error stop 'ERROR:close: ' // self%filename

self%is_open = .false.

end procedure nc_close


module procedure nc4version
nc4version = nf90_inq_libvers()
end procedure nc4version


module procedure is_contig
integer :: ier, varid

ier = nf90_inq_varid(self%ncid, dname, varid)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_contig: cannot find variable: ' // dname

ier = nf90_inquire_variable(self%ncid, varid, contiguous=is_contig)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_contig: cannot get variable properties' // dname

end procedure is_contig


module procedure is_chunked
integer :: ier, varid

ier = nf90_inq_varid(self%ncid, dname, varid)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_chunked: cannot find variable: ' // dname

ier = nf90_inquire_variable(self%ncid, varid, contiguous=is_chunked)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_chunked: cannot get variable properties' // dname

is_chunked = .not.is_chunked
end procedure is_chunked


module procedure is_netcdf
integer :: ierr, ncid

inquire(file=filename, exist=is_netcdf)
!! avoid warning/error messages
if (.not. is_netcdf) return

ierr = nf90_open(filename, NF90_NOWRITE, ncid)
is_netcdf = ierr == 0

ierr = nf90_close(ncid)

end procedure is_netcdf


module procedure check_error
character(:), allocatable :: m

check_error = .true.

select case (code)
case (NF90_NOERR)
  check_error = .false.
case (NF90_EHDFERR)
  m = 'ERROR: ' // dname // ' an error was reported by the HDF5 layer.'
case (NF90_EBADNAME)
  m = 'ERROR: ' // dname // ' Name contains illegal characters.'
case (NF90_EBADTYPE)
  m = 'ERROR: ' // dname // ' specified type is not a valid netCDF type'
case (NF90_EDIMSIZE)
  m = 'ERROR: ' // dname // ' bad dimension size'
case (NF90_EBADDIM)
  m = 'ERROR: ' // dname // ' invalid dimension ID or Name'
case (NF90_EBADGRPID)
  m = 'ERROR: ' // dname // ' bad group ID in ncid'
case (NF90_EBADID)
  m = 'ERROR: ' // dname // ' Bad group id or ncid invalid'
case (NF90_ENOTVAR)
  m = 'ERROR: ' // dname // ' variable not found'
case (NF90_ENOTNC)
  m = 'ERROR: ' // dname // ' not a NetCDF file'
case (NF90_ENAMEINUSE)
  m = 'ERROR: ' // dname // ' That name is in use. Compound type names must be unique in the data file.'
case (NF90_ECHAR)
  m = 'ERROR: ' // dname // ' attempt to convert between text & numbers'
case (NF90_EEDGE)
  m = 'ERROR: ' // dname // ' edge + start exceeds dimension bound'
case (NF90_ESTRIDE)
  m = 'ERROR: ' // dname // ' illegal stride'
case (NF90_EINDEFINE)
  m = 'ERROR: ' // dname // ' operation not allowed in define mode'
case default
  write(stderr,'(/,A,I8)') 'ERROR: ' // dname // ' unknown error',code
  m = ''
end select

if(check_error) write(stderr,'(/,A)') m

end procedure check_error


end submodule utils

module nc4fortran
!! NetCDF4 object-oriented polymorphic interface
use, intrinsic :: iso_c_binding, only : c_ptr, c_loc
use, intrinsic :: iso_fortran_env, only : real32, real64, int32, int64, stderr=>error_unit

use netcdf, only : nf90_create, nf90_open, NF90_WRITE, NF90_CLOBBER, NF90_NETCDF4, NF90_MAX_NAME, &
  NF90_NOERR, NF90_EHDFERR, NF90_EBADNAME, NF90_EBADDIM, NF90_EBADTYPE, NF90_EBADGRPID, NF90_ENOTNC, NF90_ENOTVAR, &
  NF90_ECHAR, NF90_EEDGE, NF90_ENAMEINUSE, NF90_EBADID, NF90_EINDEFINE, NF90_NOWRITE, NF90_EDIMSIZE, &
  nf90_open, nf90_close, nf90_estride, nf90_inq_varid, nf90_inq_dimid, nf90_inquire_dimension, &
  nf90_def_dim, nf90_def_var, nf90_get_var, nf90_put_var, &
  nf90_inq_libvers, nf90_sync, nf90_inquire_variable

implicit none (type, external)
private
public :: netcdf_file, NF90_MAX_NAME, NF90_NOERR, check_error, is_netcdf, nc_exist

!! at this time, we assume up to 7 dimension NetCDF variable.
integer, parameter :: NC_MAXDIM = 7

!> main type
type :: netcdf_file

character(:), allocatable  :: filename
integer :: ncid   !< location identifier

integer :: comp_lvl = 0 !< compression level (1-9)  0: disable compression
logical :: verbose = .false.
logical :: debug = .false.
logical :: is_open = .false.
!! will be auto-deleted on close
character(80) :: libversion

contains

!> methods used directly without type/rank agnosticism
procedure, public :: initialize => nc_initialize, open => nc_initialize, &
  finalize => nc_finalize, close => nc_finalize, &
  shape => get_shape, ndims => get_ndims, write_attribute, read_attribute, flush=>nc_flush, &
  exist=>nc_check_exist, exists=>nc_check_exist, &
  is_chunked, is_contig, chunks=>get_chunk

!> generic procedures mapped over type / rank
generic, public :: write => &
  nc_write_scalar_r32, nc_write_scalar_r64, nc_write_scalar_i32, nc_write_scalar_i64, nc_write_scalar_char, &
  nc_write_1d_r32, nc_write_1d_r64, nc_write_1d_i32, nc_write_1d_i64, &
  nc_write_2d_r32, nc_write_2d_r64, nc_write_2d_i32, nc_write_2d_i64, &
  nc_write_3d_r32, nc_write_3d_r64, nc_write_3d_i32, nc_write_3d_i64, &
  nc_write_4d_r32, nc_write_4d_r64, nc_write_4d_i32, nc_write_4d_i64, &
  nc_write_5d_r32, nc_write_5d_r64, nc_write_5d_i32, nc_write_5d_i64, &
  nc_write_6d_r32, nc_write_6d_r64, nc_write_6d_i32, nc_write_6d_i64, &
  nc_write_7d_r32, nc_write_7d_r64, nc_write_7d_i32, nc_write_7d_i64

generic, public :: read => nc_read_scalar, nc_read_1d, nc_read_2d, nc_read_3d, nc_read_4d, nc_read_5d, nc_read_6d, nc_read_7d

procedure, private :: nc_write_scalar_r32, nc_write_scalar_r64, nc_write_scalar_i32, nc_write_scalar_i64, nc_write_scalar_char, &
  nc_write_1d_r32, nc_write_1d_r64, nc_write_1d_i32, nc_write_1d_i64, &
  nc_write_2d_r32, nc_write_2d_r64, nc_write_2d_i32, nc_write_2d_i64, &
  nc_write_3d_r32, nc_write_3d_r64, nc_write_3d_i32, nc_write_3d_i64, &
  nc_write_4d_r32, nc_write_4d_r64, nc_write_4d_i32, nc_write_4d_i64, &
  nc_write_5d_r32, nc_write_5d_r64, nc_write_5d_i32, nc_write_5d_i64, &
  nc_write_6d_r32, nc_write_6d_r64, nc_write_6d_i32, nc_write_6d_i64, &
  nc_write_7d_r32, nc_write_7d_r64, nc_write_7d_i32, nc_write_7d_i64, &
  nc_read_scalar, nc_read_1d, nc_read_2d, nc_read_3d, nc_read_4d, nc_read_5d, nc_read_6d, nc_read_7d, &
  def_dims

!> flush file to disk and close file if user forgets to do so.
final :: destructor

end type netcdf_file

!> Submodules

interface !< pathlib.f90
module logical function std_unlink(filename)
character(*), intent(in) :: filename
end function std_unlink

module logical function is_absolute_path(path)
character(*), intent(in) :: path
end function is_absolute_path

module function get_tempdir()
character(:), allocatable :: get_tempdir
end function

end interface

interface !< writer.f90
module subroutine nc_write_scalar_char(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
character(*), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine nc_write_scalar_char

module subroutine nc_write_scalar_r32(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine nc_write_scalar_r32

module subroutine nc_write_scalar_r64(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine nc_write_scalar_r64

module subroutine nc_write_scalar_i32(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine nc_write_scalar_i32

module subroutine nc_write_scalar_i64(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine nc_write_scalar_i64

module subroutine nc_write_1d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_1d_r32

module subroutine nc_write_1d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_1d_r64

module subroutine nc_write_1d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_1d_i32

module subroutine nc_write_1d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_1d_i64

module subroutine nc_write_2d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_2d_r32

module subroutine nc_write_2d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_2d_r64

module subroutine nc_write_2d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_2d_i32

module subroutine nc_write_2d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_2d_i64

module subroutine nc_write_3d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_3d_r32

module subroutine nc_write_3d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_3d_r64

module subroutine nc_write_3d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_3d_i32

module subroutine nc_write_3d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_3d_i64

module subroutine nc_write_4d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_4d_r32

module subroutine nc_write_4d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_4d_r64

module subroutine nc_write_4d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_4d_i32

module subroutine nc_write_4d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_4d_i64


module subroutine nc_write_5d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_5d_r32

module subroutine nc_write_5d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_5d_r64

module subroutine nc_write_5d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_5d_i32

module subroutine nc_write_5d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_5d_i64


module subroutine nc_write_6d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_6d_r32

module subroutine nc_write_6d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_6d_r64

module subroutine nc_write_6d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_6d_i32

module subroutine nc_write_6d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_6d_i64


module subroutine nc_write_7d_r32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real32), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_7d_r32

module subroutine nc_write_7d_r64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
real(real64), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_7d_r64

module subroutine nc_write_7d_i32(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int32), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_7d_i32

module subroutine nc_write_7d_i64(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer(int64), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_7d_i64

end interface


interface  !< read.f90

module integer function get_ndims(self, dname) result (drank)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function get_ndims

module subroutine get_shape(self, dname, dims, dimnames)
class(netcdf_file), intent(in)  :: self
character(*), intent(in)         :: dname
integer, intent(out), allocatable :: dims(:)
character(NF90_MAX_NAME), intent(out), allocatable, optional :: dimnames(:)
end subroutine get_shape

module logical function nc_check_exist(self, dname) result(exists)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function nc_check_exist

module logical function nc_exist(filename, dname)
character(*), intent(in) :: filename, dname
end function nc_exist
end interface

interface !< reader.f90
module subroutine nc_read_scalar(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value
!! inout for character
integer, intent(out), optional :: ierr
end subroutine nc_read_scalar

module subroutine nc_read_1d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:)
integer, intent(out), optional :: ierr
end subroutine nc_read_1d

module subroutine nc_read_2d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_2d

module subroutine nc_read_3d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_3d

module subroutine nc_read_4d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_4d

module subroutine nc_read_5d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_5d

module subroutine nc_read_6d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_6d

module subroutine nc_read_7d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_7d


module subroutine def_dims(self, dname, dimnames, dims, dimids, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
character(*), intent(in), optional :: dimnames(:)
integer, intent(in) :: dims(:)
integer, intent(out) :: dimids(size(dims)), ierr
end subroutine def_dims
end interface


interface !< attributes.f90
module subroutine write_attribute(self, dname, attrname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, attrname
class(*), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine write_attribute

module subroutine read_attribute(self, dname, attrname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, attrname
class(*), intent(inout) ::  value
!! inout for character
integer, intent(out), optional :: ierr
end subroutine read_attribute
end interface

contains

subroutine nc_initialize(self,filename,ierr, status,action,comp_lvl,verbose,debug)
!! Opens NetCDF file

class(netcdf_file), intent(inout) :: self
character(*), intent(in) :: filename
integer, intent(out), optional :: ierr
character(*), intent(in), optional :: status !< DEPRECATED
character(*), intent(in), optional :: action
integer, intent(in), optional :: comp_lvl
logical, intent(in), optional :: verbose, debug

character(:), allocatable :: laction
integer :: ier

if (self%is_open) then
  write(stderr,*) 'WARNING:nc4fortran:initialize file handle already open to: '// filename
  return
endif

self%filename = filename

if (present(comp_lvl)) self%comp_lvl = comp_lvl
if (present(verbose)) self%verbose = verbose
if (present(debug)) self%debug = debug

!> get library version
self%libversion = nf90_inq_libvers()

if(present(status)) write(stderr,*) 'nc4fortran:WARNING: status is deprecated. use action instead.'

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


if (present(ierr)) ierr = ier
if (ier == NF90_NOERR) then
  self%is_open = .true.
  return
endif

write(stderr,*) 'nc4fortran:ERROR: initialize ' // filename // ' could not be created'
if (present(ierr)) return
error stop

end subroutine nc_initialize


subroutine destructor(self)
!! Close file and handle if user forgets to do so

type(netcdf_file), intent(inout) :: self

if (.not. self%is_open) return

print *, "auto-closing " // self%filename

call self%close()

end subroutine destructor


subroutine nc_finalize(self, ierr)
class(netcdf_file), intent(inout) :: self
integer, intent(out), optional :: ierr

integer :: ier

if(.not. self%is_open) then
  write(stderr,*) 'WARNING:nc4fortran:finalize file handle is not open'
  return
endif

ier = nf90_close(self%ncid)
if (present(ierr)) ierr = ier
if (ier /= NF90_NOERR) then
  write(stderr,*) 'ERROR:finalize: ' // self%filename
  if (present(ierr)) return
  error stop
endif

self%is_open = .false.

end subroutine nc_finalize


subroutine nc_flush(self, ierr)

class(netcdf_file), intent(in) :: self
integer, intent(out), optional :: ierr
integer :: ier

ier = nf90_sync(self%ncid)

if (present(ierr)) ierr = ier
if (check_error(ier, "") .and. .not. present(ierr)) error stop

end subroutine nc_flush


logical function is_contig(self, dname)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer :: ier, varid

ier = nf90_inq_varid(self%ncid, dname, varid)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_contig: cannot find variable: ' // dname

ier = nf90_inquire_variable(self%ncid, varid, contiguous=is_contig)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_contig: cannot get variable properties' // dname

end function is_contig


logical function is_chunked(self, dname)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer :: ier, varid

ier = nf90_inq_varid(self%ncid, dname, varid)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_chunked: cannot find variable: ' // dname

ier = nf90_inquire_variable(self%ncid, varid, contiguous=is_chunked)
if (ier/=NF90_NOERR) error stop 'nc4fortran:is_chunked: cannot get variable properties' // dname

is_chunked = .not.is_chunked
end function is_chunked


subroutine get_chunk(self, dname, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer, intent(out) :: chunk_size(:)
logical :: contig
integer :: i, varid

chunk_size = -1

i = nf90_inq_varid(self%ncid, dname, varid)
if (i/=NF90_NOERR) error stop 'nc4fortran:chunk: cannot find variable: ' // dname

i = nf90_inquire_variable(self%ncid, varid, contiguous=contig)
if (i/=NF90_NOERR) error stop 'nc4fortran:chunk: cannot get variable properties' // dname

if(contig) return
i = nf90_inquire_variable(self%ncid, varid, chunksizes=chunk_size)
if (i/=NF90_NOERR) error stop 'nc4fortran:chunk: cannot get variable properties' // dname

end subroutine get_chunk


logical function is_netcdf(filename)
!! is this file NetCDF4?

character(*), intent(in) :: filename
integer :: ierr, ncid

inquire(file=filename, exist=is_netcdf)
!! avoid warning/error messages
if (.not. is_netcdf) return

ierr = nf90_open(filename, NF90_NOWRITE, ncid)
is_netcdf = ierr == 0

ierr = nf90_close(ncid)

end function is_netcdf


logical function check_error(code, dname)
integer, intent(in) :: code
character(*), intent(in) :: dname
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

end function check_error


end module nc4fortran

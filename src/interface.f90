module nc4fortran
!! NetCDF4 object-oriented polymorphic interface
use, intrinsic :: iso_c_binding, only : c_ptr, c_loc
use, intrinsic :: iso_fortran_env, only : real32, real64, int32, int64, stderr=>error_unit
use netcdf
use string_utils, only : toLower, strip_trailing_null, truncate_string_null

implicit none
private
public :: unlink, netcdf_file, NF90_MAX_NAME, NF90_NOERR, check_error

!! at this time, we assume up to 7 dimension NetCDF variable.
integer, parameter :: NC_MAXDIM = 7

!> main type
type :: netcdf_file

character(:), allocatable  :: filename
integer :: ncid   !< location identifier

integer :: comp_lvl = 0 !< compression level (1-9)  0: disable compression
logical :: verbose = .false.
logical :: debug = .false.

contains

!> initialize NetCDF file
procedure, public :: initialize => nc_initialize, finalize => nc_finalize, &
  shape => nc_get_shape, write_attribute, &
  exist=>nc_check_exist, exists=>nc_check_exist

!> write group or dataset integer/real
generic, public :: write => nc_write_scalar, nc_write_1d, nc_write_2d, nc_write_3d, &
  nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d

generic, public :: read => nc_read_scalar, nc_read_1d, nc_read_2d, nc_read_3d, nc_read_4d, nc_read_5d, nc_read_6d, nc_read_7d

procedure, private :: nc_write_scalar, nc_write_1d, nc_write_2d, nc_write_3d, nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d, &
  nc_read_scalar, nc_read_1d, nc_read_2d, nc_read_3d, nc_read_4d, nc_read_5d, nc_read_6d, nc_read_7d, &
  def_dims

end type netcdf_file

!! Submodules

interface
module subroutine nc_write_scalar(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value
integer, intent(out), optional :: ierr
end subroutine nc_write_scalar

module subroutine nc_write_1d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_1d

module subroutine nc_write_2d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_2d

module subroutine nc_write_3d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_3d

module subroutine nc_write_4d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_4d

module subroutine nc_write_5d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_5d

module subroutine nc_write_6d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_6d

module subroutine nc_write_7d(self, dname, value, dims, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
end subroutine nc_write_7d


module subroutine nc_get_shape(self, dname, dimnames, dims)
class(netcdf_file), intent(in)  :: self
character(*), intent(in)         :: dname
character(NF90_MAX_NAME), allocatable :: dimnames(:)
integer, intent(out), allocatable :: dims(:)
end subroutine nc_get_shape

module logical function nc_check_exist(self, dname) result(exists)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function nc_check_exist


module subroutine nc_read_scalar(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value
integer, intent(out), optional :: ierr
end subroutine nc_read_scalar

module subroutine nc_read_1d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:)
integer, intent(out), optional :: ierr
end subroutine nc_read_1d

module subroutine nc_read_2d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_2d

module subroutine nc_read_3d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_3d

module subroutine nc_read_4d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_4d

module subroutine nc_read_5d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_5d

module subroutine nc_read_6d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:,:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_6d

module subroutine nc_read_7d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:,:,:,:,:,:)
integer, intent(out), optional :: ierr
end subroutine nc_read_7d


module subroutine def_dims(self, dname, dimnames, dims, dimids, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
character(*), intent(in), optional :: dimnames(:)
integer, intent(in) :: dims(:)
integer, intent(out) :: dimids(size(dims)), ierr
end subroutine def_dims


module subroutine write_attribute(self, dname, attrname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, attrname, value
integer, intent(out), optional :: ierr
end subroutine write_attribute

end interface

contains

subroutine nc_initialize(self,filename,ierr, status,action,comp_lvl,verbose,debug)
!! Opens NetCDF file

class(netcdf_file), intent(inout) :: self
character(*), intent(in) :: filename
integer, intent(out), optional :: ierr
character(*), intent(in), optional :: status
character(*), intent(in), optional :: action
integer, intent(in), optional :: comp_lvl
logical, intent(in), optional      :: verbose, debug

character(:), allocatable :: lstatus, laction
integer :: ier

self%filename = filename

if (present(comp_lvl)) self%comp_lvl = comp_lvl
if (present(verbose)) self%verbose = verbose
if (present(debug)) self%debug = debug

lstatus = 'old'
if(present(status)) lstatus = toLower(status)

laction = 'rw'
if(present(action)) laction = toLower(action)

select case(lstatus)
case ('old', 'unknown')
  select case(laction)
    case('read','r')  !< Open an existing file.
      ier = nf90_open(self%filename, NF90_NOWRITE, self%ncid)
    case('write','readwrite','w','rw', 'r+', 'append', 'a')
      ier = nf90_open(self%filename, NF90_NETCDF4, self%ncid)
    case default
      write(stderr,*) 'ERROR:initialize: Unsupported action -> ' // laction
      ier = 128
    end select
case('new','replace')
  ier = unlink(filename)
  ier = nf90_create(self%filename, NF90_NETCDF4, self%ncid)
case default
  write(stderr,*) 'ERROR:initialize: Unsupported status -> '// lstatus
  ier = 128
end select

if (present(ierr)) ierr = ier
if (ier /= NF90_NOERR) then
  write(stderr,*) 'ERROR:initialize ' // filename // ' could not be created'
  if (present(ierr)) return
  error stop
endif

end subroutine nc_initialize


subroutine nc_finalize(self, ierr)
class(netcdf_file), intent(in) :: self
integer, intent(out), optional :: ierr

integer :: ier

ier = nf90_close(self%ncid)
if (present(ierr)) ierr = ier
if (ier /= NF90_NOERR) then
  write(stderr,*) 'ERROR:finalize: ' // self%filename
  if (present(ierr)) return
  error stop
endif
end subroutine nc_finalize


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


integer function unlink(path) result (ierr)
!! the non-standard unlink present in some compilers can be unstable
!! in particular ifort can hang, but not with this standard method
character(*), intent(in) :: path
logical :: exists
integer :: u

ierr = 0

inquire(file=path, exist=exists)
if(.not.exists) return

open(newunit=u, file=path, status='old', iostat=ierr)
if(ierr/=0) return
close(u, status='delete', iostat=ierr)

end function unlink


end module nc4fortran

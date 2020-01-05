module nc4fortran
!! NetCDF4 object-oriented polymorphic interface
use, intrinsic :: iso_c_binding, only : c_ptr, c_loc
use, intrinsic :: iso_fortran_env, only : real32, real64, int32, int64, stderr=>error_unit
use netcdf
use string_utils, only : toLower, strip_trailing_null, truncate_string_null

implicit none

!! at this time, we assume up to 7 dimension NetCDF variable.
integer, parameter :: NC_MAXDIM = 7

!> main type
type :: netcdf_file

character(:), allocatable  :: filename
integer :: ncid   !< location identifier

integer :: comp_lvl = 0 !< compression level (1-9)  0: disable compression

contains

!> initialize NetCDF file
procedure, public :: initialize => nc_initialize, finalize => nc_finalize, &
  shape => nc_get_shape, write_attribute
!  open => nc_open_group, close => nc_close_group

!> write group or dataset integer/real
generic, public :: write => nc_write_scalar, nc_write_1d, nc_write_2d, nc_write_3d, &
  nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d
  !, nc_write_group

generic, public :: read => nc_read_scalar, nc_read_1d, nc_read_2d

procedure, private :: nc_write_scalar, nc_write_1d, nc_write_2d, nc_write_3d, nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d, &
  nc_read_scalar, nc_read_1d, nc_read_2d, &
  def_dims

end type netcdf_file

!! Submodules

interface
module subroutine nc_write_scalar(self, dname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value
integer, intent(out) :: ierr
end subroutine nc_write_scalar

module subroutine nc_write_1d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_1d

module subroutine nc_write_2d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_2d

module subroutine nc_write_3d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_3d

module subroutine nc_write_4d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_4d

module subroutine nc_write_5d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_5d

module subroutine nc_write_6d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_6d

module subroutine nc_write_7d(self, dname, value, dimnames, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in) :: dimnames(:)
integer, intent(out) :: ierr
end subroutine nc_write_7d


module subroutine nc_get_shape(self, dname, dimnames, dims, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
character(NF90_MAX_NAME), allocatable :: dimnames(:)
integer, intent(out), allocatable :: dims(:)
integer, intent(out) :: ierr
end subroutine nc_get_shape


module subroutine nc_read_scalar(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value
integer, intent(out) :: ierr
end subroutine nc_read_scalar

module subroutine nc_read_1d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:)
integer, intent(out) :: ierr
end subroutine nc_read_1d

module subroutine nc_read_2d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out) :: ierr
end subroutine nc_read_2d

module subroutine nc_read_3d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out) :: ierr
end subroutine nc_read_3d

module subroutine nc_read_4d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out) :: ierr
end subroutine nc_read_4d

module subroutine nc_read_5d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out) :: ierr
end subroutine nc_read_5d

module subroutine nc_read_6d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out) :: ierr
end subroutine nc_read_6d

module subroutine nc_read_7d(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(out)      :: value(:,:)
integer, intent(out) :: ierr
end subroutine nc_read_7d


module subroutine def_dims(self, dname, dimnames, dims, dimids, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, dimnames(:)
integer, intent(in) :: dims(:)
integer, intent(out) :: dimids(size(dims)), ierr
end subroutine def_dims


module subroutine write_attribute(self, dname, attrname, value, ierr)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, attrname, value
integer, intent(out) :: ierr
end subroutine write_attribute

end interface

integer, parameter :: ENOENT = 2, EIO = 5

contains

subroutine nc_initialize(self,filename,ierr, status,action,comp_lvl)
!! Opens NetCDF file

class(netcdf_file), intent(inout)  :: self
character(*), intent(in)           :: filename
integer, intent(out)               :: ierr
character(*), intent(in), optional :: status
character(*), intent(in), optional :: action
integer, intent(in), optional      :: comp_lvl

character(:), allocatable :: lstatus, laction
logical :: exists

self%filename = filename

if (present(comp_lvl)) self%comp_lvl = comp_lvl

lstatus = 'old'
if(present(status)) lstatus = toLower(status)

laction = 'rw'
if(present(action)) laction = toLower(action)

select case(lstatus)
case ('old', 'unknown')
  select case(laction)
    case('read','r')  !< Open an existing file.
      inquire(file=filename, exist=exists)
      if (.not.exists) then
        write(stderr,*) 'ERROR: ' // filename // ' does not exist.'
        ierr = ENOENT
        return
      endif
      ierr = nf90_open(self%filename, NF90_NOWRITE, self%ncid)
    case('write','readwrite','w','rw', 'r+', 'append', 'a')
      ierr = nf90_open(self%filename, NF90_NETCDF4, self%ncid)
      if (ierr /= NF90_NOERR) then
        write(stderr,*) 'ERROR: ' // filename // ' could not be opened'
        ierr = EIO
        return
      endif
    case default
      write(stderr,*) 'Unsupported action -> ' // laction
      ierr = 128
      return
    endselect
case('new','replace')
  inquire(file=filename, exist=exists)
  if (exists) call unlink(filename)
  ierr = nf90_create(self%filename, NF90_NETCDF4, self%ncid)
  if (ierr /= NF90_NOERR) then
    write(stderr,*) 'ERROR: ' // filename // ' could not be created'
    ierr = EIO
    return
  endif
case default
  write(stderr,*) 'Unsupported status -> '// lstatus
  ierr = 128
  return
endselect
end subroutine nc_initialize


subroutine nc_finalize(self, ierr)
class(netcdf_file), intent(in) :: self
integer, intent(out) :: ierr

ierr = nf90_close(self%ncid)
if (ierr /= 0) write(stderr,*) 'ERROR: file close: ' // self%filename
end subroutine nc_finalize


logical function check_error(code, dname)
integer, intent(in) :: code
character(*), intent(in) :: dname

check_error = .true.

select case (code)
case (NF90_NOERR)
  check_error = .false.
case (NF90_EBADNAME)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' is the name of another existing variable'
case (NF90_EBADTYPE)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' specified type is not a valid netCDF type'
case (NF90_EBADDIM)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' invalid dimension ID or Name'
case (NF90_EBADGRPID)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' bad group ID in ncid'
case (NF90_EBADID)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' type ID not found'
case (NF90_ENOTVAR)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' variable not found'
case (NF90_ENOTNC)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' not a NetCDF file'
case (NF90_ENAMEINUSE)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' string match to name in use'
case (NF90_ECHAR)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' attempt to convert between text & numbers'
case (NF90_EEDGE)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' edge + start exceeds dimension bound'
case (NF90_ESTRIDE)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' illegal stride'
case (NF90_EINDEFINE)
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' operation not allowed in define mode'
case default
  write(stderr,'(/,A)') 'ERROR: ' // dname // ' unknown error',code
end select
end function check_error


end module nc4fortran

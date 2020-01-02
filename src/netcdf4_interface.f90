module netcdf4_interface
!! NetCDF4 object-oriented polymorphic interface
use, intrinsic :: iso_c_binding, only : c_ptr, c_loc
use, intrinsic :: iso_fortran_env, only : real32, real64, int32, int64, stderr=>error_unit
use netcdf, only : NF90_NOCLOBBER, NF90_CLOBBER, NF90_NOERR, nf90_open, NF90_NOWRITE, nf90_create
use string_utils, only : toLower, strip_trailing_null, truncate_string_null

implicit none

!> main type
type :: netcdf_file

character(:), allocatable  :: filename
integer :: ncid   !< location identifier

contains

!> initialize NetCDF file
procedure, public :: initialize => nc_initialize!, finalize => nc_finalize, writeattr, &
!  open => nc_open_group, close => nc_close_group, shape => nc_get_shape

!> write group or dataset integer/real
generic, public :: write => nc_write_scalar !, nc_write_1d, nc_write_2d, nc_write_3d, &
!nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d, nc_write_group

generic, public :: read => nc_read_scalar

procedure, private :: nc_write_scalar, nc_read_scalar

end type netcdf_file

!! Submodules

interface
module subroutine nc_write_scalar(self, dname, value, ierr)
class(netcdf_file), intent(inout) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value
integer, intent(out) :: ierr
end subroutine nc_write_scalar


module subroutine nc_read_scalar(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value
integer, intent(out) :: ierr
end subroutine nc_read_scalar
end interface

integer, parameter :: ENOENT = 2, EIO = 5

contains

subroutine nc_initialize(self,filename,ierr, status,action)
!! Opens NetCDF file

class(netcdf_file), intent(inout)  :: self
character(*), intent(in)           :: filename
integer, intent(out)               :: ierr
character(*), intent(in), optional :: status
character(*), intent(in), optional :: action

character(:), allocatable :: lstatus, laction
logical :: exists

self%filename = filename

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
      ierr = nf90_open(self%filename, NF90_NOCLOBBER, self%ncid)
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
  ierr = nf90_create(self%filename, NF90_CLOBBER, self%ncid)
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


end module netcdf4_interface
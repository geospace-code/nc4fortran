module netcdf_interface
!! NetCDF4 object-oriented polymorphic interface
use, intrinsic :: iso_c_binding, only : c_ptr, c_loc
use, intrinsic :: iso_fortran_env, only : real32, real64, int32, int64, stderr=>error_unit
use netcdf, only : NF90_NOCLOBBER, NF90_CLOBBER, NF90_NOERR, NF90_NOWRITE, NF90_EBADTYPE, &
  NF90_EBADNAME, NF90_NETCDF4, NF90_EBADGRPID, NF90_EBADID, &
  NF90_CHAR, NF90_DOUBLE, NF90_FLOAT, NF90_INT, NF90_INT64, &
  nf90_open, nf90_close, nf90_create
use string_utils, only : toLower, strip_trailing_null, truncate_string_null

implicit none

!> main type
type :: netcdf_file

character(:), allocatable  :: filename
integer :: ncid   !< location identifier

contains

!> initialize NetCDF file
procedure, public :: initialize => nc_initialize, finalize => nc_finalize, &
  check_error!, writeattr, &
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


logical function check_error(self, code, dname)
class(netcdf_file), intent(in) :: self
integer, intent(in) :: code
character(*), intent(in) :: dname

check_error = .true.

select case (code)
case (NF90_NOERR)
  check_error = .false.
case (NF90_EBADNAME)
  write(stderr,*) dname, ' is the name of another existing variable'
case (NF90_EBADTYPE)
  write(stderr,*) dname, ' specified type is not a valid netCDF type'
case (NF90_EBADGRPID)
  write(stderr,*) dname, ' bad group ID in ncid'
case (NF90_EBADID)
  write(stderr,*) dname, ' type ID not found'
case default
  write(stderr,*) dname, ' unknown error'
end select
end function check_error


end module netcdf_interface

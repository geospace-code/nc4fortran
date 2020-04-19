program test_errors
use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use nc4fortran, only: netcdf_file, NF90_NOERR

implicit none (type, external)

character(:), allocatable :: path
character(256) :: argv
integer :: i,l

call get_command_argument(1, argv, length=l, status=i)
if (i /= 0 .or. l == 0) then
  write(stderr,*) 'please specify test directory e.g. /tmp'
  error stop 77
endif

path = trim(argv)

print *, 'test path: ', path

call test_nonexist_old_file(path)
print *, 'OK: non-existing old file'
call test_nonexist_unknown_file(path)
print *, 'OK: non-existing unknown file'
call test_nonnetcdf_file(path)
print *, 'OK: non-NetCDF file'
call test_nonexist_variable(path)
print *, 'OK: non-existing variable'
call test_wrong_type(path)
print *, "OK: wrong type read"
call test_unknown_write(path)
print *, 'OK: unknown write'
call test_unknown_read(path)
print *, 'OK: unknown read'

contains


subroutine test_nonexist_old_file(path)
character(*), intent(in) :: path
integer :: ierr
type(netcdf_file) :: ncf

call ncf%initialize(path//'/not-exist', ierr, status='old', action='read')
if (ierr==NF90_NOERR) error stop 'should have had ierr/=0 on non-existing old file'
end subroutine test_nonexist_old_file


subroutine test_nonexist_unknown_file(path)
character(*), intent(in) :: path
integer :: ierr
type(netcdf_file) :: ncf

call ncf%initialize(path//'/not-exist', ierr, status='unknown', action='read')
if (ierr==NF90_NOERR) error stop 'should have had ierr/=0 on non-existing unknown read file'
end subroutine test_nonexist_unknown_file


subroutine test_nonnetcdf_file(path)
character(*), intent(in) :: path
integer :: u,ierr
type(netcdf_file) :: ncf
character(:), allocatable :: filename

filename = path // '/junk.nc'

! create or replace zero-length file, could be any size, just not a valid NetCDF file
open(newunit=u, file=filename, status='replace', iostat=ierr, action='write')
close(u)

call ncf%initialize(filename, ierr, status='old', action='read')
if (ierr==NF90_NOERR) error stop 'should have had ierr/=0 on invalid NetCDF file'
end subroutine test_nonnetcdf_file


subroutine test_nonexist_variable(path)
character(*), intent(in) :: path
integer :: u,ierr
type(netcdf_file) :: ncf
character(:), allocatable :: filename

filename = path // '/junk.nc'
call ncf%initialize(filename, ierr, status='replace', action='readwrite')
if(ierr/=NF90_NOERR) error stop 'test_nonexist_variable: opening file'
call ncf%read('/not-exist', u, ierr)
if(ierr==NF90_NOERR) error stop 'test_nonexist_variable: should have ierr/=0 on non-exist variable'
call ncf%finalize(ierr)
if (ierr/=NF90_NOERR) error stop 'test_nonexist_variable: finalizing'
end subroutine test_nonexist_variable


subroutine test_wrong_type(path)
character(*), intent(in) :: path
integer :: u,ierr
type(netcdf_file) :: ncf
character(:), allocatable :: filename
real :: x


filename = path // '/junk.nc'
call ncf%initialize(filename, ierr, status='replace', action='write')
if(ierr/=NF90_NOERR) error stop 'test_wrong_type: creating file'
call ncf%write('real32', 42., ierr)
if(ierr/=NF90_NOERR) error stop 'test_wrong_type: writing test variable'
call ncf%finalize(ierr)
if (ierr/=NF90_NOERR) error stop 'test_nonexist_variable: finalizing'

call ncf%initialize(filename, ierr, status='old', action='read')
if(ierr/=NF90_NOERR) error stop 'test_wrong_type: opening file'
call ncf%read('real32', u, ierr)
if(ierr/=NF90_NOERR) then
  write(stderr,*) 'read value real32: ', u
  error stop 'test_wrong_type: read mismatched variable type'
endif
if (u /= 42) then
  write(stderr,*) 'test_wrong_type: did not coerce real to integer',x
  error stop
endif
call ncf%finalize(ierr)
if (ierr/=NF90_NOERR) error stop 'test_nonexist_variable: finalizing'
end subroutine test_wrong_type


subroutine test_unknown_write(path)
character(*), intent(in) :: path
integer :: ierr
type(netcdf_file) :: ncf
character(:), allocatable :: filename
complex :: x

x = (1, -1)

filename = path // '/junk.nc'
call ncf%initialize(filename, ierr, status='replace', action='write')
if(ierr/=NF90_NOERR) error stop 'test_unknown_write: creating file'
call ncf%write('/complex', x, ierr)
if(ierr==NF90_NOERR) error stop 'test_unknown_write: writing unknown type variable'
end subroutine test_unknown_write


subroutine test_unknown_read(path)
character(*), intent(in) :: path
integer :: ierr
type(netcdf_file) :: ncf
character(:), allocatable :: filename
complex :: x

x = (1, -1)

filename = path // '/junk.nc'
call ncf%initialize(filename, ierr, status='unknown', action='readwrite')
if(ierr/=NF90_NOERR) error stop 'test_unknown_read: opening file'
call ncf%read('/complex', x, ierr)
if(ierr==NF90_NOERR) error stop 'test_unknown_read: reading unknown type variable'
end subroutine test_unknown_read

end program
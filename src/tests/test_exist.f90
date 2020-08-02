program test_exist
!! test "exist" variable
use, intrinsic :: iso_fortran_env, only : stderr=>error_unit
use nc4fortran, only : netcdf_file, is_netcdf, nc_exist

implicit none (type, external)

character(1024) :: argv
character(:), allocatable :: path

if(command_argument_count() /= 1) error stop 'input temp path'
call get_command_argument(1, argv)
path = trim(argv)

call test_is_netcdf(argv)
print *, 'OK: is_netcdf'

call test_exists(argv)
print *, 'OK: exist'

call test_scratch(argv)
print *, 'OK: scratch'

call test_multifiles()
print *, 'OK: multiple files open at once'


contains

subroutine test_is_netcdf(path)

character(*), intent(in) :: path
character(:), allocatable :: fn
integer :: i

if(is_netcdf(trim(path) // '/apidfjpj-8j9ejfpq984jfp89q39SHf.nc')) error stop 'test_exist: non-existant file declared netcdf'
fn = trim(path) // '/not_netcdf.nc'
open(newunit=i, file=fn, action='write', status='replace')
write(i,*) 'I am not an netcdf file.'
close(i)

if(is_netcdf(fn)) error stop 'text files are not netcdf'

end subroutine test_is_netcdf


subroutine test_exists(path)

character(*), intent(in) :: path
type(netcdf_file) :: h
character(:), allocatable :: fn

fn = trim(path) // '/test_exist.nc'

call h%initialize(fn, status='replace')
call h%write('x', 42)
call h%finalize()
if(.not.is_netcdf(fn)) error stop 'file does not exist'

call h%initialize(fn)
if (.not.h%is_open) error stop 'file is open'
if (.not. h%exist('x')) error stop 'x exists'

if (h%exist('foo')) then
  write(stderr,*) 'variable foo not exist in ', h%filename
  error stop
endif

call h%finalize()

if(h%is_open) error stop 'file is closed'

if (.not. nc_exist(fn, 'x')) error stop 'x exists'
if (nc_exist(fn, 'foo')) error stop 'foo not exist'

end subroutine test_exists


subroutine test_scratch(path)
character(*), intent(in) :: path
logical :: e
type(netcdf_file) :: h

call h%initialize(trim(path) // '/scratch.nc', status='scratch')
call h%write('here', 12)
call h%finalize()

inquire(file=h%filename, exist=e)
if(e) error stop 'scratch file was not auto-deletect'

end subroutine test_scratch


subroutine test_multifiles()

type(netcdf_file) :: f,g,h
integer :: ierr

call f%initialize(filename='A.nc', status='scratch')
call g%initialize(filename='B.nc', status='scratch')
if (h%is_open) error stop 'is_open not isolated at constructor'
call h%initialize(filename='C.nc', status='scratch')

call f%flush()

call f%finalize(ierr)
if (ierr/=0) error stop 'close a.nc'
if (.not.g%is_open .or. .not. h%is_open) error stop 'is_open not isolated at destructor'
call g%finalize(ierr)
if (ierr/=0) error stop 'close b.nc'
call h%finalize(ierr)
if (ierr/=0) error stop 'close c.nc'

end subroutine test_multifiles

end program

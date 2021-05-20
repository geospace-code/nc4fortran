program exist_tests
!! test "exist" variable
use, intrinsic :: iso_fortran_env, only : stderr=>error_unit
use nc4fortran, only : netcdf_file, is_netcdf, nc_exist

implicit none (type, external)

call test_is_netcdf()
print *, 'OK: is_netcdf'

call test_exist()
print *, 'OK: exist'

call test_scratch()
print *, 'OK: scratch'

call test_multifiles()
print *, 'OK: multiple files open at once'

contains

subroutine test_is_netcdf()
integer :: i

if(is_netcdf('apidfjpj-8j9ejfpq984jfp89q39SHf.nc')) error stop 'test_exist: non-existent file declared netcdf'

open(newunit=i, file='not_netcdf.nc', action='write', status='replace')
write(i,*) 'I am not a NetCDF4 file.'
close(i)

if(is_netcdf('not.nc')) error stop 'text files are not NetCDF4'

end subroutine test_is_netcdf


subroutine test_exist()
type(netcdf_file) :: h
character(*), parameter :: fn = 'exist.nc'

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

end subroutine test_exist


subroutine test_scratch()
logical :: e
type(netcdf_file) :: h

call h%initialize('scratch.nc', status='scratch')
call h%write('here', 12)
call h%finalize()

inquire(file=h%filename, exist=e)
if(e) error stop 'scratch file not autodeleted'

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

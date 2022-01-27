program exist_tests
!! test "exist" variable
use, intrinsic :: iso_fortran_env, only : stderr=>error_unit
use nc4fortran, only : netcdf_file, is_netcdf, nc_exist

implicit none (type, external)

call test_is_netcdf()
print *, 'OK: is_netcdf'

call test_exist()
print *, 'OK: exist'

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

call h%open(fn, action='w')
call h%write('x', 42)
call h%close()
if(.not.is_netcdf(fn)) error stop 'file does not exist'

call h%open(fn, "r")
if (.not.h%is_open) error stop 'file is open'
if (.not. h%exist('x')) error stop 'x exists'

if (h%exist('foo')) then
  write(stderr,*) 'variable foo not exist in ', h%filename
  error stop
endif

call h%close()

if(h%is_open) error stop 'file is closed'

if (.not. nc_exist(fn, 'x')) error stop 'x exists'
if (nc_exist(fn, 'foo')) error stop 'foo not exist'

end subroutine test_exist


subroutine test_multifiles()

type(netcdf_file) :: f,g,h

call f%open(filename='A.nc', action='w')
call g%open(filename='B.nc', action='w')
if (h%is_open) error stop 'is_open not isolated at constructor'
call h%open(filename='C.nc', action='w')

call f%flush()

call f%close()
if (.not.g%is_open .or. .not. h%is_open) error stop 'is_open not isolated at destructor'
call g%close()
call h%close()

end subroutine test_multifiles

end program

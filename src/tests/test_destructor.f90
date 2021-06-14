program test_destruct
!! test netcdf_file destructor, that should auto-flush and close file
!! if user forgets to %close() file

use, intrinsic :: iso_fortran_env, only : stderr=>error_unit
use nc4fortran, only: netcdf_file
implicit none (type, external)

call test_destructor()
print *, 'OK: destructor'

contains


subroutine test_destructor()
type(netcdf_file) :: h
character(*), parameter :: fn = 'destructor.nc'
integer :: i

block
  type(netcdf_file) :: h
  !! we use block to test destructor is invoked
  call h%open(fn, action="write", status="replace")
  call h%write('x', 42)
end block

if(h%is_open) error stop "destructor did not close " // fn

call h%open(fn, action="read", status="old")
call h%read("x", i)
if(i/=42) error stop "destructor did not flush " // fn

end subroutine test_destructor

end program

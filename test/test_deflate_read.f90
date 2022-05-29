program test_deflate_read

use, intrinsic:: iso_fortran_env, only: int32, int64, real32, real64, stderr=>error_unit

use nc4fortran, only : netcdf_file

implicit none (type, external)

character(*), parameter :: fn1='deflate1.nc'
integer, parameter :: N(2) = [50, 1000]


call test_read_deflate(fn1, N)
print *,'OK: read deflate'

contains

subroutine test_read_deflate(fn, N)

character(*), intent(in) :: fn
integer, intent(in) :: N(2)

type(netcdf_file) :: h
real(real32), allocatable :: A(:,:)

allocate(A(N(1), N(2)))

call h%open(fn, action='r')
call h%read('A', A)
call h%read('noMPI', A)
call h%close()

end subroutine test_read_deflate

end program

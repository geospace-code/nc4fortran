program test_deflate
!! unit tests and registration tests of deflate compression write

use, intrinsic:: iso_fortran_env, only: int32, real32, real64, stderr=>error_unit

use nc4fortran, only: netcdf_file

implicit none (type, external)

character(*), parameter :: fn1='deflate1.nc', fn2='deflate2.nc', fn3='deflate3.nc'
integer, parameter :: N(2) = [50, 1000], &
MIN_COMP = 2  !< lots of CPUs, smaller arrays => poorer compression
!! don't use too big otherwise platform/version dependent autochunk fouls up test ~ 4MB

call test_write_deflate(fn1, N)
print *,'OK: write deflate'

call test_deflate_whole(fn2, N)
print *,'OK: compress whole'

contains

subroutine test_write_deflate(fn, N)

character(*), intent(in) :: fn
integer, intent(in) :: N(2)

type(netcdf_file) :: h
real(real32), allocatable :: A(:,:)

allocate(A(N(1), N(2)))

A = 0  !< simplest data

call h%open(fn, action='w', comp_lvl=1)
call h%write('A', A, dims=['x','y'], chunk_size=[5, 50])
call h%close()

deallocate(A)

allocate(A(N(1), N(2)))
A = 1  !< simplest data

!! write with compression
call h%open(fn, action='a', comp_lvl=1)

call h%write('small', A(:4,:4))
!! not compressed because too small

call h%write('noMPI', A)
!! write without MPI, with compression

call h%close()

end subroutine test_write_deflate


subroutine test_deflate_whole(fn, N)

character(*), intent(in) :: fn
integer, intent(in) :: N(2)

type(netcdf_file) :: h
real, allocatable :: A(:,:,:)
integer :: chunks(3)
real :: crat
integer :: fsize

allocate(A(N(1), N(2), 4))

call h%open(fn, action='w', comp_lvl=3)

call h%write('A', A, chunk_size=[4, 20, 1])
call h%chunks('A', chunks)
if(chunks(1) /= 4 .or. chunks(3) /= 1)  then
  write(stderr, '(a,3I5)') "expected chunks: 4,*,1 but got chunks ", chunks
  error stop '#2 manual chunk unexpected chunk size'
endif

call h%write('A_autochunk', A)
call h%chunks('A_autochunk', chunks)
if(any(chunks < 1)) error stop '#2 auto chunk unexpected chunk size'
call h%close()

inquire(file=fn, size=fsize)
crat = (2 * N(1) * N(2) * 4 * storage_size(A) / 8) / real(fsize)
!! 2* since two datasets same size

print '(A,F6.2,A,f7.1)','#2 filesize (Mbytes): ', real(fsize) / 1e6, '   compression ratio:', crat

if(crat < MIN_COMP) error stop fn // ' low compression'

end subroutine test_deflate_whole


end program

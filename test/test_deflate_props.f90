program test_deflate_props

use, intrinsic :: iso_fortran_env, only : int64, stderr=>output_unit

use nc4fortran, only : netcdf_file

implicit none (type, external)

character(*), parameter :: fn1='deflate1.nc'
integer, parameter :: N(2) = [50, 1000], &
MIN_COMP = 2  !< lots of CPUs, smaller arrays => poorer compression

call test_read_deflate_props(fn1, N)
print *,'OK: HDF5 read deflate properties'

call test_get_deflate(fn1)
print *, 'OK: get deflate'

contains


subroutine test_read_deflate_props(fn, N)

character(*), intent(in) :: fn
integer, intent(in) :: N(2)

type(netcdf_file) :: h

real :: crat
integer :: fsize
integer :: chunks(2)

inquire(file=fn, size=fsize)

crat = (N(1) * N(2) * 32 / 8) / fsize
print '(A,F6.2,A,f7.1)','#1 filesize (Mbytes): ',fsize/1e6, '  compression ratio:',crat
if(crat < MIN_COMP) error stop '2D low compression'

call h%open(fn1, action='r')

if(.not.h%is_chunked('A')) error stop '#1 not chunked layout: ' // fn

call h%chunks('A', chunks)
if(chunks(1) /= 5) then
  write(stderr, '(a,2I5)') "expected chunks(1) = 5 but got chunks ", chunks
  error stop '#1 A get_chunk mismatch'
endif

!if(.not.h%is_contig('small')) error stop '#1 not contig layout'
call h%chunks('small', chunks)
if(any(chunks(:2) /= 4)) then
  write(stderr, '(a,2I5)') "expected chunks(1) = 4 but got chunks ", chunks
  error stop 'small get_chunk mismatch'
endif

call h%close()

end subroutine test_read_deflate_props


subroutine test_get_deflate(fn)

character(*), intent(in) :: fn

type(netcdf_file) :: h

call h%open(fn, action='r')

if (.not. h%deflate("A")) error stop "test_get_deflate: expected deflate"

call h%close()

end subroutine test_get_deflate

end program

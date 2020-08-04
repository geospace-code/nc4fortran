program deflate_test
!! unit tests and registration tests of HDF5 deflate compression write
use, intrinsic:: iso_fortran_env, only: int32, real32, real64, stderr=>error_unit

use nc4fortran, only: netcdf_file, toLower, strip_trailing_null, truncate_string_null

implicit none (type, external)

type(netcdf_file) :: h
integer, parameter :: N=1000
integer :: crat, chunks(3)
integer ::  fsize

integer, allocatable :: ibig2(:,:), ibig3(:,:,:)
real(real32), allocatable :: big2(:,:), big3(:,:,:)
character(*), parameter :: fn1='deflate1.nc', fn2='deflate2.nc', fn3='deflate3.nc', fn4='deflate4.nc'

allocate(ibig2(N,N), ibig3(N,N,4), big2(N,N), big3(N,N,4))

ibig2 = 0
ibig3 = 0
big2 = 0
big3 = 0

call h%initialize(fn1, status='replace', comp_lvl=1, debug=.true.)
call h%write('big2', big2, dims=['x','y'])
call h%flush()
!> turn compression off for following variables (must flush first)
h%comp_lvl = 0
call h%write('small_contig', big2(:5,:5), dims=['q','r'])
call h%finalize()

inquire(file=fn1, size=fsize)
crat = (N*N*storage_size(big2)/8) / fsize
print '(A,F6.2,A,I6)','#1 filesize (Mbytes): ',fsize/1e6, '   2D compression ratio:',crat
if (crat < 10) error stop '#1 2D low compression'

call h%initialize(fn1, status='old', action='r', debug=.false.)

if(.not. h%is_chunked('big2')) error stop '#1 not chunked layout'

call h%chunks('big2', chunks(:2))
if(any(chunks(:2) /= [1000, 1000])) error stop '#1 get_chunk mismatch'

if(.not.h%is_contig('small_contig')) error stop '#1 not contig layout'
call h%chunks('small_contig', chunks(:2))
if(any(chunks(:2) /= -1)) error stop '#1 get_chunk mismatch'

call h%finalize()

! ======================================

call h%initialize(fn2, status='replace',comp_lvl=1, debug=.true.)
call h%write('big3', big3)

call h%write('big3_autochunk', big3)
call h%chunks('big3_autochunk', chunks)
if(any(chunks /= [500,500,2])) then
  write(stderr,*) '#2 chunk size', chunks
  error stop '#2 auto chunk unexpected chunk size'
endif
call h%finalize()

inquire(file=fn2, size=fsize)
crat = (2*N*N*storage_size(big3)/8) / fsize
print '(A,F6.2,A,I6)','#2 filesize (Mbytes): ',fsize/1e6, '   3D compression ratio:',crat
if (h%comp_lvl > 0 .and. crat < 10) error stop '#2 3D low compression'

! ======================================

call h%initialize(fn3, status='replace',comp_lvl=1, debug=.true.)

call h%write('ibig3', ibig3(:N-10,:N-20,:))
call h%chunks('ibig3', chunks)
if(any(chunks /= [495,490,2]))  then
  write(stderr,*) '#3 chunk size', chunks
  error stop '#3 auto chunk unexpected chunk size'
endif
call h%finalize()

inquire(file=fn3, size=fsize)
crat = (N*N*storage_size(ibig3)/8) / fsize
print '(A,F6.2,A,I6)','#3 filesize (Mbytes): ',fsize/1e6, '   3D compression ratio:',crat
if (h%comp_lvl > 0 .and. crat < 10) error stop '#3 3D low compression'
! !======================================

call h%initialize(fn4, status='replace', comp_lvl=1, debug=.true.)
call h%write('ibig2', ibig2)
call h%finalize()

inquire(file=fn4, size=fsize)
crat = (N*N*storage_size(ibig2)/8) / fsize
print '(A,F6.2,A,I6)','#4 filesize (Mbytes): ',fsize/1e6, '   3D compression ratio:',crat
if (h%comp_lvl > 0 .and. crat < 10) error stop '#4 3D low compression'

end program

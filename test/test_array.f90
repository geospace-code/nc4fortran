program array_test

use, intrinsic:: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit

use nc4fortran, only : netcdf_file
use netcdf, only : NF90_INT

implicit none (type, external)

real(real32) :: nan

call test_basic_array('test_array.nc')
print *,'PASSED: array write'
call test_read_slice('test_array.nc')
print *, 'PASSED: slice read'
call test_write_slice('test_array.nc')
print *, 'PASSED: slice write'

contains

subroutine test_basic_array(filename)

character(*), intent(in) :: filename

type(netcdf_file) :: h
integer, allocatable :: dims(:)

integer(int32), dimension(4) :: i1, i1t
integer(int32), dimension(4,4) :: i2, i2t
integer(int64), dimension(4,4) :: i2t64
real(real32), allocatable :: rr2(:,:)
real(real32)  ::  nant, r1(4), r2(4,4), B(6,6)
integer :: i
integer(int32) :: i2_8(8,8)

nan = ieee_value(1.0, ieee_quiet_nan)

do i = 1,size(i1)
  i1(i) = i
enddo

i2(1,:) = i1
do i = 1,size(i2,2)
  i2(i,:) = i2(1,:) * i
enddo

r1 = i1
r2 = i2

call h%open(filename, action='w', comp_lvl=1)

call h%write('int32-1d', i1)
call h%write('int32-2d', i2, ['x', 'y'])
call h%write('int64-2d', int(i2, int64))
call h%write('real32-2d', r2)
call h%write('nan', nan)

call h%close()

!! read
call h%open(filename, action='r')

!> int32
call h%read('int32-1d', i1t)
if (.not.all(i1==i1t)) error stop 'read 1-d int32: does not match write'

call h%read('int32-2d',i2t)
if (.not.all(i2==i2t)) error stop 'read 2-D: int32 does not match write'

call h%read('int64-2d',i2t64)
if (.not.all(i2==i2t64)) error stop 'read 2-D: int64 does not match write'

!> verify reading into larger array
i2_8 = 0
call h%read('int32-2d', i2_8(2:5,3:6))
if (.not.all(i2_8(2:5,3:6) == i2)) error stop 'read into larger array fail'

!> real
call h%shape('real32-2d',dims)
allocate(rr2(dims(1), dims(2)))
call h%read('real32-2d',rr2)
if (.not.all(r2 == rr2)) error stop 'real 2-D: read does not match write'

! check read into a variable slice
call h%read('real32-2d', B(2:5,3:6))
if(.not.all(B(2:5,3:6) == r2)) error stop 'real 2D: reading into variable slice'

call h%read('nan',nant)
if (.not.ieee_is_nan(nant)) error stop 'failed storing or reading NaN'

call h%close()

end subroutine test_basic_array


subroutine test_read_slice(filename)

character(*), intent(in) :: filename

type(netcdf_file) :: h
integer :: i
integer(int32), dimension(4) :: i1, i1t
integer(int32), dimension(4,4) :: i2, i2t

do i = 1,size(i1)
  i1(i) = i
enddo

i2(1,:) = i1
do i = 1,size(i2,2)
  i2(i,:) = i2(1,:) * i
enddo

call h%open(filename, 'r')

i1t = 0
call h%read('int32-1d', i1t(:2), istart=[2], iend=[3], stride=[1])
if (any(i1t(:2) /= [2,3])) then
  write(stderr, *) 'read 1D slice does not match. expected [2,3] but got ',i1t(:2)
  error stop
endif

i1t = 0
call h%read('int32-1d', i1t(:2), istart=[2], iend=[3])
if (any(i1t(:2) /= [2,3])) then
  write(stderr, *) 'read 1D slice does not match. expected [2,3] but got ',i1t(:2)
  error stop
endif

i2t = 0
call h%read('int32-2d', i2t(:2,:3), istart=[2,1], iend=[3,3], stride=[1,1])
if (any(i2t(:2,:3) /= i2(2:3,1:3))) then
  write(stderr, *) 'read 2D slice does not match. expected:',i2(2:3,1:3),' but got ',i2t(:2,:3)
  error stop
endif

call h%close()

end subroutine test_read_slice


subroutine test_write_slice(filename)

character(*), intent(in) :: filename

type(netcdf_file) :: h
integer(int32), dimension(4) :: i1t
integer(int32), dimension(4,4) :: i2t


call h%open(filename, action='r+')

call h%create('int32a-1d', dtype=NF90_INT, dims=[3])
call h%write('int32a-1d', [1,3], istart=[1], iend=[2])
print *, 'PASSED: create dataset and write slice 1D'

call h%write('int32-1d', [35, 70], istart=[2], iend=[3], stride=[1])

call h%read('int32-1d', i1t)
if (.not.all(i1t==[1,35,70,4])) then
  write(stderr, *) 'write 1D slice does not match. got ',i1t
  error stop
endif
print *, 'PASSED: overwrite slice 1d, stride=1'

call h%write('int32-1d', [23,34,45], istart=[2], iend=[4])
call h%read('int32-1d', i1t)
if (.not.all(i1t==[1,23,34,45])) then
  write(stderr, *) 'read 1D slice does not match.got ',i1t
  error stop
endif
print *, 'PASSED: overwrite slice 1d, no stride'


call h%create('int32a-2d', dtype=NF90_INT, dims=[4,4])
print *, 'create and write slice 2d, stride=1'
call h%write('int32a-2d', reshape([76,65,54,43], [2,2]), istart=[2,1], iend=[3,2])
call h%read('int32a-2d', i2t)

call h%close()


end subroutine test_write_slice



end program

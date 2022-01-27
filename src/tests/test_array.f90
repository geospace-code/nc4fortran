program array_test

use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use, intrinsic:: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
use nc4fortran, only : netcdf_file

implicit none (type, external)

real(real32) :: nan

call test_basic_array()
print *,'PASSED: array write'

contains

subroutine test_basic_array()

type(netcdf_file) :: h
integer, allocatable :: dims(:)
character(*), parameter :: filename = 'test_array.nc'

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
print *,'read large'
! check read into a variable slice
call h%read('real32-2d', B(2:5,3:6))
if(.not.all(B(2:5,3:6) == r2)) error stop 'real 2D: reading into variable slice'

call h%read('nan',nant)
if (.not.ieee_is_nan(nant)) error stop 'failed storing or reading NaN'

call h%close()

end subroutine test_basic_array


end program

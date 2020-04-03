program test_netcdf

use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use, intrinsic:: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
use nc4fortran, only : netcdf_file, NF90_MAX_NAME

implicit none (external)

character(:), allocatable :: path
character(256) :: argv
integer :: i,l

call get_command_argument(1, argv, length=l, status=i)
if (i /= 0 .or. l == 0) then
  write(stderr,*) 'please specify test directory e.g. /tmp'
  error stop 77
endif

path = trim(argv)

print *, 'test path: ', path

call test_exist(path)
print *, 'OK: exist check'

call test_scalar(path)
print *, 'OK: scalar'

call test_array(path)
print *,'OK: array'

contains


subroutine test_exist(path)
character(*), intent(in) :: path
type(netcdf_file) :: hf

if (hf%exist('foovar')) error stop 'variable and file not exists and not opened'

call hf%initialize(path // '/scalar.nc', status='replace', action='w')
call hf%write('here', 12)
if(.not. hf%exist('here')) error stop 'variable exists'
if(hf%exist('nothere')) error stop 'variable does not actually exist'

end subroutine test_exist


subroutine test_scalar(path)

character(*), intent(in) :: path
type(netcdf_file) :: hf

integer :: i
real(real32) :: nan,r

nan = ieee_value(1.0, ieee_quiet_nan)

!! write

call hf%initialize(path // '/scalar.nc', status='replace', action='rw')
call hf%write('nan', nan)
call hf%write('scalar_real', 42.)
call hf%write('scalar_int', 42)
call hf%finalize()

!! read

call hf%initialize(path // '/scalar.nc',status='old',action='r')

call hf%read('nan', r)
if (.not.ieee_is_nan(r)) error stop 'failed storing or reading NaN'

call hf%read('scalar_real', r)
if (r/=42.) error stop 'scalar real'

call hf%read('scalar_int', i)
if (i/=42) error stop 'scalar int'

call hf%finalize()

end subroutine test_scalar


subroutine test_array(path)

character(*), intent(in) :: path
type(netcdf_file) :: hf
integer, allocatable :: dims(:)
character(NF90_MAX_NAME), allocatable :: dimnames(:)

integer :: i1(4)
real(real32)    :: r1(4), r2(4,4), B(6,6), r4(1,2,3,4)
integer(int32), dimension(4,4) :: i2, i2t
integer(int64), dimension(4,4) :: i2t64
real(real32), allocatable :: rr2(:,:)

!! test values
do i = 1,size(i1)
  i1(i) = i
enddo

r1 = i1

i2(1,:) = i1
do i = 1,size(i2,2)
  i2(i,:) = i2(1,:) * i
enddo

r2 = i2

!! write

call hf%initialize(path // '/array.nc', status='replace', action='rw', comp_lvl=1)

call hf%write('real32-2d', r2, ['x', 'y'])

call hf%write('real64-2d', real(r2, real64))

call hf%write('int32-2d', i2, ['x', 'y'])

call hf%write('int64-2d', int(i2, int64))

call hf%write('real32-4d', r4, ['a','b','c','d'])

call hf%finalize()
print *, 'array: wrote all values'

!! read

call hf%initialize(path // '/array.nc',status='old',action='r')

call hf%read('int32-2d',i2t)
if (.not.all(i2==i2t)) error stop 'read 2-D: int32 does not match write'
print *, 'array: read int32-2d'

call hf%read('int64-2d',i2t64)
if (.not.all(i2==i2t64)) error stop 'read 2-D: int64 does not match write'

call hf%shape('real32-2d', dimnames, dims)
print *, 'array: got shape real32-2d', dims

allocate(rr2(dims(1), dims(2)))
call hf%read('real32-2d',rr2)
if (.not.all(r2 == rr2)) error stop 'real 2-D: read does not match write'

! check read into a variable slice
call hf%read('real32-2d', B(2:5,3:6))
if(.not.all(B(2:5,3:6) == r2)) error stop 'real 2D: reading into variable slice'

call hf%finalize()

end subroutine test_array


end program
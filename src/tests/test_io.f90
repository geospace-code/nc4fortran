program test_netcdf
use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use, intrinsic:: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
use nc4fortran, only : netcdf_file, NF90_MAX_NAME
implicit none

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

call test_real_int(path)
print *, 'OK:, real32/64, int32/64'

contains

subroutine test_real_int(path)

character(*), intent(in) :: path
type(netcdf_file) :: hf

integer :: i1(4), ierr
real(real32)    :: nan, r1(4), r2(4,4), B(6,6)
integer(int32), dimension(4,4) :: i2, i2t
integer(int64), dimension(4,4) :: i2t64
real(real32), allocatable :: rr2(:,:)
real(real32)  ::  nant

integer, allocatable :: dims(:)
character(NF90_MAX_NAME), allocatable :: dimnames(:)

nan = ieee_value(1.0, ieee_quiet_nan)

do i = 1,size(i1)
  i1(i) = i
enddo

r1 = i1

i2(1,:) = i1
do i = 1,size(i2,2)
  i2(i,:) = i2(1,:) * i
enddo

r2 = i2

call hf%initialize(path // '/io_test.nc', ierr, status='replace', action='rw', comp_lvl=1)
if(ierr/=0) error stop 'initialize'

call hf%write('nan', nan, ierr)
if(ierr/=0) error stop 'write 0-D: real32 NaN'

call hf%write('real32-2d', r2, ierr, ['x', 'y'])
if(ierr/=0) error stop 'write 2-D: real32'

call hf%write('real64-2d', real(r2, real64), ierr)
if(ierr/=0) error stop 'write 2-D: real64'

call hf%write('int32-2d', i2, ierr, ['x', 'y'])
if(ierr/=0) error stop 'write 2-D: int32'

call hf%write('int64-2d', int(i2, int64), ierr)
if(ierr/=0) error stop 'write 2-D: int64'

call hf%finalize(ierr)
if (ierr /= 0) error stop 'write finalize'

!-----------------

call hf%initialize(path // '/io_test.nc', ierr,status='old',action='r')

call hf%read('int32-2d',i2t, ierr)
if (.not.all(i2==i2t)) error stop 'read 2-D: int32 does not match write'

call hf%read('int64-2d',i2t64, ierr)
if (.not.all(i2==i2t64)) error stop 'read 2-D: int64 does not match write'

call hf%shape('real32-2d', dimnames, dims, ierr)
allocate(rr2(dims(1), dims(2)))
call hf%read('real32-2d',rr2, ierr)
if (.not.all(r2 == rr2)) error stop 'real 2-D: read does not match write'

! check read into a variable slice
call hf%read('real32-2d', B(2:5,3:6), ierr)
if(.not.all(B(2:5,3:6) == r2)) error stop 'real 2D: reading into variable slice'

call hf%read('nan',nant, ierr)
if (.not.ieee_is_nan(nant)) error stop 'failed storing or reading NaN'
call hf%finalize(ierr)
if (ierr /= 0) error stop 'read finalize'

end subroutine test_real_int


end program
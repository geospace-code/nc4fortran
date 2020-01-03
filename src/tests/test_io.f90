program test_netcdf
use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use, intrinsic:: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
use netcdf_interface, only : netcdf_file
implicit none

integer :: i1(4), ierr
real(real32)    :: nan, r1(4), r2(4,4)

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

nan = ieee_value(1.0, ieee_quiet_nan)

do i = 1,size(i1)
  i1(i) = i
enddo

r1 = i1

call test_write(path)

contains

subroutine test_write(path)

character(*), intent(in) :: path
type(netcdf_file) :: ncf
integer(int32), dimension(4,4) :: i2, i2t
integer(int64), dimension(4,4) :: i2t64
integer, allocatable :: dims(:)
real(real32), allocatable :: rr2(:,:)
real(real32)  ::  nant


i2(1,:) = i1
do i = 1,size(i2,2)
  i2(i,:) = i2(1,:) * i
enddo

r2 = i2

call ncf%initialize(path // '/io_test.nc', ierr, status='replace', action='rw', comp_lvl=1)
if(ierr/=0) error stop 'initialize'

call ncf%write('nan', nan, ierr)
if(ierr/=0) error stop 'write 0-D: real32 NaN'

call ncf%write('real32-2d', r2, ['x', 'y'], ierr)
if(ierr/=0) error stop 'write 2-D: real32'

call ncf%write('real64-2d', real(r2, real64), ['x', 'y'], ierr)
if(ierr/=0) error stop 'write 2-D: real64'

call ncf%write('ai2', i2, ['x', 'y'], ierr)
if(ierr/=0) error stop 'write 2-D: int32'

call ncf%write('ai2_64', int(i2, int64), ['x', 'y'], ierr)
if(ierr/=0) error stop 'write 2-D: int64'

call ncf%finalize(ierr)
if (ierr /= 0) error stop 'write finalize'

! call ncf%initialize(path // '/io_test.nc', ierr,status='old',action='r')

! call ncf%read('/test/group2/ai2',i2t, ierr)
! if (.not.all(i2==i2t)) error stop 'read 2-D: int32 does not match write'

! call ncf%read('/test/group2/ai2_64',i2t64, ierr)
! if (.not.all(i2==i2t64)) error stop 'read 2-D: int64 does not match write'

! call ncf%shape('/test/real2',dims, ierr)
! allocate(rr2(dims(1), dims(2)))
! call ncf%read('/test/real2',rr2, ierr)
! if (.not.all(r2 == rr2)) error stop 'real 2-D: read does not match write'

! call ncf%read('/nan',nant, ierr)
! if (.not.ieee_is_nan(nant)) error stop 'failed storing or reading NaN'
! call ncf%finalize(ierr)
! if (ierr /= 0) error stop 'write finalize'

end subroutine test_write

end program
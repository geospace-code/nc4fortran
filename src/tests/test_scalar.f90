program scalar_test

use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use nc4fortran, only : netcdf_file

implicit none (type, external)

type(netcdf_file) :: h
real(real32), allocatable :: rr1(:)
real(real32) :: rt, r1(4)
integer(int32) :: it, i1(4)
integer(int32), allocatable :: i1t(:)
integer, allocatable :: dims(:)
integer :: i
character(*), parameter :: fn = 'test_scalar.nc'

do i = 1,size(i1)
  i1(i) = i
enddo

r1 = i1

!> write
call h%open(fn, action='w')
!> scalar tests
call h%write('scalar_int32', 42_int32)

call h%write('scalar_real32', -1._real32)
call h%write('scalar_real32', 42._real32)

!> vector
call h%write('vector_scalar_real', [37.])
call h%write('1d_real', r1)

call h%write('1d_int32', i1)

!> create then write: not an nc4fortran feature yet

print *, 'PASSED: vector write'
!> test rewrite
call h%write('scalar_real32', 42.)
call h%write('scalar_int32', 42_int32)
call h%close()

!> read

call h%open(fn, action='r')

call h%read('scalar_int32', it)
call h%read('scalar_real32', rt)

if (.not.(rt==it .and. it==42)) then
  write(stderr,*) it,'/=',rt
  error stop 'scalar real / int: not equal 42'
endif
print *, 'PASSED: scalar read/write'

!> read casting -- real to int and int to real
call h%read('scalar_real32', it)
if(it/=42) error stop 'scalar cast real => int'
call h%read('scalar_int32', rt)
if(rt/=42) error stop 'scalar cast int32 => real'
print *, 'PASSED: scalar cast on read'

!> read vector length 1 as scalar
call h%shape('vector_scalar_real', dims)
if (any(dims /= [1])) then
  write(stderr,*) "expected dims 1, got dims:", dims, "rank:", rank(dims)
  error stop "vector_scalar: expected vector length 1"
endif

call h%read('vector_scalar_real', rt)
if(rt/=37) error stop 'vector_scalar: 1d length 1 => scalar'

call h%shape('1d_real', dims)
allocate(rr1(dims(1)))
print *, "OK: 1d shape read real32"
call h%read('1d_real', rr1)
if (.not.all(r1 == rr1)) error stop 'real 1-D: read does not match write'
print *, "OK: 1d read real32"

call h%shape('1d_int32',dims)
allocate(i1t(dims(1)))
call h%read('1d_int32',i1t)
if (.not.all(i1==i1t)) error stop 'int32 1-D: read does not match write'

!> check filename property
if (.not. h%filename == fn) error stop h%filename // ' mismatch filename'


call h%close()

end program

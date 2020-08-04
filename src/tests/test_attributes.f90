program test_attr

use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use nc4fortran, only : netcdf_file

implicit none (type, external)

character(*), parameter :: filename = 'test_attr.h5'

call test_write_attributes(filename)
print *,'PASSED: write attributes'

call test_read_attributes(filename)
print *,'PASSED: read attributes'

contains

subroutine test_write_attributes(path)

type(netcdf_file) :: h
character(*), intent(in) :: path

call h%initialize(path, status='replace')

call h%write('x', 1)

call h%write_attribute('x', 'note','this is just a little number')
call h%write_attribute('x', 'hello', 'hi')
call h%write_attribute('x', 'life', 42)
call h%write_attribute('x', 'life_float', 42._real32)
call h%write_attribute('x', 'life_double', 42._real64)

call h%finalize()

end subroutine test_write_attributes


subroutine test_read_attributes(path)

type(netcdf_file) :: h
character(*), intent(in) :: path
character(1024) :: attr_str
integer :: attr_int
real(real32) :: attr32
real(real64) :: attr64

integer :: x

call h%initialize(path, status='old', action='r')

call h%read('x', x)
if (x/=1) error stop 'read_attribute: unexpected value'

call h%read_attribute('x', 'note', attr_str)
if (attr_str /= 'this is just a little number') error stop 'read_attribute value note'

call h%read_attribute('x', 'life', attr_int)
if (attr_int /= 42) error stop 'read_attribute: int'

call h%read_attribute('x', 'life_float', attr32)
if (attr32 /= 42._real32) error stop 'read_attribute: real32'

call h%read_attribute('x', 'life_double', attr64)
if (attr64 /= 42._real64) error stop 'read_attribute: real64'

call h%finalize()

end subroutine test_read_attributes

end program

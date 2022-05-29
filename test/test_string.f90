program test_string

use, intrinsic:: iso_fortran_env, only:  stderr=>error_unit
use, intrinsic:: iso_c_binding, only: c_null_char

use nc4fortran, only : netcdf_file

implicit none (type, external)

character(*), parameter :: fn='test_string.nc'

call test_write(fn)
print *, "OK: HDF5 string write"

call test_read(fn)
print *,'OK: HDF5 string read'

call test_overwrite(fn)
print *, "OK: string overwrite"

print *,'PASSED: HDF5 string write/read'

contains


subroutine test_write(fn)

character(*), intent(in) :: fn

type(netcdf_file) :: h

call h%open(fn, action='w')

call h%write('little', '42')
call h%write('MySentence', 'this is a little sentence.')

call h%close()

end subroutine test_write


subroutine test_read(fn)

character(*), intent(in) :: fn

type(netcdf_file) :: h
character(2) :: value
character(1024) :: val1k

call h%open(fn, action='r')
call h%read('little', value)

if(len_trim(value) /= 2) then
  write(stderr,'(a,i0,a)') "test_string: read length ", len_trim(value), " /= 2"
  error stop
endif
if (value /= '42') error stop 'test_string:  read/write verification failure. Value: '// value

!> longer character than data
call h%read('little', val1k)

if (len_trim(val1k) /= 2) then
  write(stderr, '(a,i0,/,a)') 'expected character len_trim 2 but got len_trim() = ', len_trim(val1k), val1k
  error stop
endif

call h%close()

end subroutine test_read


subroutine test_overwrite(fn)

character(*), intent(in) :: fn

type(netcdf_file) :: h
character(2) :: v

call h%open(fn, action='rw')
call h%write('little', '73')
call h%close()

call h%open(fn, action='r')
call h%read('little', v)
call h%close()

if (v /= '73') error stop 'test_string:  overwrite string failure. Value: '// v // " /= 73"

end subroutine test_overwrite

end program

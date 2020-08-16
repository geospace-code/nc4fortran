program test_string

use, intrinsic:: iso_fortran_env, only:  stderr=>error_unit
use, intrinsic:: iso_c_binding, only: c_null_char

use nc4fortran, only : netcdf_file

implicit none (type, external)


type(netcdf_file) :: h

character(2) :: value
character(1024) :: val1k
character(:), allocatable :: final
integer :: i
character(*), parameter :: path='test_string.nc'

call h%initialize(path, status='replace')

call h%write('little', '42')
call h%write('MySentence', 'this is a little sentence.')

call h%finalize()

call h%initialize(path, status='old', action='r')
call h%read('little', value)

if (value /= '42') then
  write(stderr,*) 'test_string:  read/write verification failure. Value: '// value
  error stop
endif

print *,'test_string_rw: reading too much data'
!! try reading too much data, then truncating to first C_NULL
call h%read('little', val1k)
i = index(val1k, c_null_char)
final = val1k(:i-1)

if (len(final) /= 2) then
  write(stderr, *) 'trimming str to c_null did not work, got len() = ', len(final)
  write(stderr, *) iachar(final(3:3))
  error stop
endif

call h%finalize()

end program

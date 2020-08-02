program test_string

use, intrinsic:: iso_fortran_env, only:  stderr=>error_unit
use, intrinsic:: iso_c_binding, only: c_null_char

use nc4fortran, only : toLower, netcdf_file, strip_trailing_null, truncate_string_null

implicit none (type, external)

character(:), allocatable :: path
character(256) :: argv

if(command_argument_count() /= 1) error stop 'input temporary path'
call get_command_argument(1, argv)
path = trim(argv)

call test_string_rw(path)
print *,'PASSED: HDF5 string write/read'

call test_lowercase()
print *,'PASSED: HDF5 character'
call test_strip_null()
print *,'PASSED: null strip'

contains

subroutine test_lowercase()

character(*), parameter :: hello = 'HeLl0 Th3rE !>? '
  !! Fortran 2003 allocatable string

if (.not.(toLower(hello)=='hell0 th3re !>? ')) error stop 'error: lowercase conversion'

if (.not.(trim(toLower(hello))=='hell0 th3re !>?')) error stop 'Allocatable lowercase conversion error'

end subroutine test_lowercase


subroutine test_strip_null()
character(*), parameter :: hello = 'HeLl0 Th3rE !>? '

if (.not.strip_trailing_null(hello // c_null_char) == hello) error stop 'problem stripping trailing null'

end subroutine test_strip_null


subroutine test_string_rw(path)

type(netcdf_file) :: h

character(*), intent(in) :: path
character(2) :: value
character(1024) :: val1k
character(:), allocatable :: final

call h%initialize(path//'/test_string.nc', status='replace')

call h%write('little', '42')
call h%write('MySentence', 'this is a little sentence.')

call h%finalize()

call h%initialize(path//'/test_string.nc', status='old', action='r')
call h%read('little', value)

if (value /= '42') then
  write(stderr,*) 'test_string:  read/write verification failure. Value: '// value
  error stop
endif

print *,'test_string_rw: reading too much data'
!! try reading too much data, then truncating to first C_NULL
call h%read('little', val1k)
final = truncate_string_null(val1k)
print *,'TRACE:',final, len(final)

if (len(final) /= 2) then
  write(stderr, *) 'trimming str to c_null did not work, got len() = ', len(final)
  write(stderr, *) iachar(final(3:3))
  error stop
endif

call h%finalize()

end subroutine test_string_rw

end program

program test_errors
use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use nc4fortran, only: netcdf_file, NF90_NOERR

implicit none (type, external)

call test_wrong_type()
print *, "OK: wrong type read"

contains


subroutine test_wrong_type()
integer :: u
type(netcdf_file) :: h
character(*), parameter :: filename = 'bad.nc'

call h%open(filename, action='w')
call h%write('real32', 42.)
call h%close()

call h%open(filename, action='r')
call h%read('real32', u)
if (u /= 42) error stop 'test_wrong_type: did not coerce real to integer'
call h%close()

end subroutine test_wrong_type


end program

program example2

use nc4fortran, only : netcdf_file
implicit none (type, external)

character(:), allocatable :: filename
integer :: i32

type(netcdf_file) :: h

filename = 'nc4fortran_example2.nc'

call h%open(filename, status='replace')
call h%write('x', 123)
call h%close()

call h%open(filename, status='old', action='r')
call h%read('x', i32)
if (i32 /= 123) error stop 'incorrect value read'

print *, 'OK: example 2'

end program

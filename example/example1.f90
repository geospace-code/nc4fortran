program example1

use nc4fortran, only : netcdf_file
implicit none (type, external)

type(netcdf_file) :: h
character(:), allocatable :: filename
integer :: i32

filename = 'nc4fortran_example1.nc'

call h%open(filename, action='w')

call h%write('x', 123)

call h%read('x', i32)
call h%close()

if (i32 /= 123) error stop 'incorrect value read'

print *, 'OK: example 1'

end program

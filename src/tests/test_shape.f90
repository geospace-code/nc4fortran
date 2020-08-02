program test_shape
!! This program shows how netcdf dimension orders are distinct in different langauges
use nc4fortran, only: netcdf_file, is_netcdf, NF90_MAX_NAME
use, intrinsic:: iso_fortran_env, only: real64, stdout=>output_unit, stderr=>error_unit

implicit none (type, external)

type(netcdf_file) :: h
character(1024) :: argv
integer :: i
character(:), allocatable :: path
integer, allocatable :: dims2(:), dims7(:)
character(NF90_MAX_NAME), allocatable :: dimnames(:)

integer :: d2(3,4), d7(5,6,7,9,12,11,8)

if(command_argument_count() /= 1) error stop 'input temp path'
call get_command_argument(1, argv)
path = trim(argv) // '/test_shape.nc'


call h%initialize(path, status='scratch')
!! just used scratch to save disk space.
call h%write('d2', d2)
call h%write('d7', d7, dims=['x','y','z', 'p','q','r','s'])
call h%flush()

call h%shape('d2', dims2)
if (h%ndims('d2') /= size(dims2)) then
  write(stderr,*) 'ERROR: ndims(d2) ', h%ndims('d2'), ' /= ', size(dims2), '.  dims: ',dims2
  error stop
endif
if (any(dims2 /= shape(d2))) error stop '2-D: file shape not match variable shape'

call h%shape('d7', dims7, dimnames)
if (h%ndims('d7') /= size(dims7)) then
  write(stderr,*) 'ERROR: ndims(d7) ', h%ndims('d7'), ' /= ', size(dims7), '.  dims: ',dims7, dimnames
  error stop
endif
if (any(dims7 /= shape(d7))) then
  write(stderr,*) 'ERROR: dims(d7) ', dims7, ' /= ', shape(d7)
  do i = 1,size(dimnames)
    print *,trim(dimnames(i))
  enddo
  error stop
endif

call h%finalize()

end program

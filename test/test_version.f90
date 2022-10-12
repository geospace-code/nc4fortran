program test_version
!! tests that NetCDF4 library version is available

use nc4fortran, only : nc4version

implicit none (type, external)

character(24) :: vstr
character(:), allocatable :: v
character(:), allocatable :: libver, compver
integer :: i

v = nc4version()

print '(A)', v

if(command_argument_count() < 1) stop

call get_command_argument(1, vstr, status=i)
if (i/=0) error stop "input version string to compare"

compver = get_version_mmr(vstr)
libver = get_version_mmr(v)
if (compver /= libver) error stop "version mismatch: " // compver // " /= " // libver

contains

pure function get_version_mmr(v)
!! get the major.minor.release part of a version string
!! cuts off further patch and arbitrary text
character(:), allocatable :: get_version_mmr
character(*), intent(in) :: v

integer :: i, j, k, e

k = index(v, '.')
j = index(v(k+1:), '.')
i = scan(v(k+j+1:), '.-_ ')
if (i == 0) then
  e = len_trim(v)
else
  e = k + j + i - 1
end if

get_version_mmr = v(:e)

end function get_version_mmr


end program

submodule (nc4fortran) read
use netcdf, only : nf90_inq_varid, nf90_get_var

implicit none

contains

module procedure nc_get_shape

integer :: i, tempdims(NC_MAXDIM), N
character(NF90_MAX_NAME) :: tempnames(NC_MAXDIM)

N = 0
do i = 1,NC_MAXDIM
  ierr = nf90_inquire_dimension(self%ncid, dimid=i, name=tempnames(i), len=tempdims(i))
  if(ierr/=NF90_NOERR) exit
  N = i
enddo
if(N==0) return  !< no good dims at all

allocate(dims(N), dimnames(N))
dims = tempdims(:N)
dimnames = tempnames(:N)

end procedure nc_get_shape


end submodule read
module nc4fortran
!! NetCDF4 object-oriented polymorphic interface
use, intrinsic :: iso_c_binding, only : c_ptr, c_loc
use, intrinsic :: iso_fortran_env, only : real32, real64, int32, int64, stderr=>error_unit

use netcdf, only : nf90_create, nf90_open, NF90_WRITE, NF90_CLOBBER, NF90_NETCDF4, NF90_MAX_NAME, &
  NF90_NOERR, NF90_EHDFERR, NF90_EBADNAME, NF90_EBADDIM, NF90_EBADTYPE, NF90_EBADGRPID, NF90_ENOTNC, NF90_ENOTVAR, &
  NF90_ECHAR, NF90_EEDGE, NF90_ENAMEINUSE, NF90_EBADID, NF90_EINDEFINE, NF90_NOWRITE, NF90_EDIMSIZE, &
  nf90_open, nf90_close, nf90_estride, nf90_inq_varid, nf90_inq_dimid, nf90_inquire_dimension, &
  nf90_def_dim, nf90_def_var, nf90_get_var, nf90_put_var, &
  nf90_inq_libvers, nf90_sync, nf90_inquire_variable

implicit none (type, external)
private
public :: netcdf_file, NF90_MAX_NAME, NF90_NOERR, check_error, is_netcdf, nc_exist, nc4version

!! at this time, we assume up to 7 dimension NetCDF variable.
integer, parameter :: NC_MAXDIM = 7

!> main type
type :: netcdf_file

character(:), allocatable  :: filename
integer :: file_id   !< location identifier

integer :: comp_lvl = 0 !< compression level (1-9)  0: disable compression
logical :: verbose = .false.
logical :: debug = .false.
logical :: is_open = .false.
!! will be auto-deleted on close

contains

!> methods used directly without type/rank agnosticism
procedure, public :: open => nc_open
procedure, public :: close => nc_close
procedure, public :: create => nc_create
procedure, public :: shape => get_shape
procedure, public :: ndim => get_ndim
procedure, public :: ndims => get_ndim
procedure, public :: write_attribute
procedure, public :: read_attribute
procedure, public :: flush=>nc_flush
procedure, public :: deflate => get_deflate
procedure, public :: exist=>nc_check_exist
procedure, public :: exists=>nc_check_exist
procedure, public :: is_chunked
procedure, public :: is_contig
procedure, public :: chunks=>get_chunk

!> generic procedures mapped over type / rank
generic, public :: write => &
  nc_write_scalar, nc_write_1d, nc_write_2d, nc_write_3d, nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d

generic, public :: read => nc_read_scalar, nc_read_1d, nc_read_2d, nc_read_3d, nc_read_4d, nc_read_5d, nc_read_6d, nc_read_7d

procedure, private :: nc_write_scalar, nc_write_1d, nc_write_2d, nc_write_3d, nc_write_4d, nc_write_5d, nc_write_6d, nc_write_7d, &
  nc_read_scalar, nc_read_1d, nc_read_2d, nc_read_3d, nc_read_4d, nc_read_5d, nc_read_6d, nc_read_7d, &
  def_dims

!> flush file to disk and close file if user forgets to do so.
final :: destructor

end type netcdf_file

!> Submodules

interface !< write.f90

module subroutine nc_create(self, dset_name, dtype, dims, dim_names, chunk_size, fill_value, varid)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dset_name
integer, intent(in) :: dtype
integer, intent(in) :: dims(:)
character(*), intent(in), optional :: dim_names(:)
integer, intent(in), optional :: chunk_size(:)
class(*), intent(in), optional :: fill_value
integer, intent(out), optional :: varid
end subroutine

module subroutine def_dims(self, dname, dimnames, dims, dimids)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
character(*), intent(in), optional :: dimnames(:)
integer, intent(in) :: dims(:)
integer, intent(out) :: dimids(size(dims))
end subroutine

module subroutine nc_flush(self)
class(netcdf_file), intent(in) :: self
end subroutine

end interface


interface !< writer.f90
module subroutine nc_write_scalar(self, dname, value)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value
end subroutine

module subroutine nc_write_1d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:)
character(*), intent(in), optional :: dims(1)
integer, intent(in), dimension(1), optional :: istart, iend
integer, intent(in), dimension(1), optional :: chunk_size
end subroutine

module subroutine nc_write_2d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:)
character(*), intent(in), optional :: dims(2)
integer, intent(in), dimension(2), optional :: istart, iend
integer, intent(in), dimension(2), optional :: chunk_size
end subroutine

module subroutine nc_write_3d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:)
character(*), intent(in), optional :: dims(3)
integer, intent(in), dimension(3), optional :: istart, iend
integer, intent(in), dimension(3), optional :: chunk_size
end subroutine

module subroutine nc_write_4d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:)
character(*), intent(in), optional :: dims(4)
integer, intent(in), dimension(4), optional :: istart, iend
integer, intent(in), dimension(4), optional :: chunk_size
end subroutine

module subroutine nc_write_5d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:)
character(*), intent(in), optional :: dims(5)
integer, intent(in), dimension(5), optional :: istart, iend
integer, intent(in), dimension(5), optional :: chunk_size
end subroutine

module subroutine nc_write_6d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:,:)
character(*), intent(in), optional :: dims(6)
integer, intent(in), dimension(6), optional :: istart, iend
integer, intent(in), dimension(6), optional :: chunk_size
end subroutine

module subroutine nc_write_7d(self, dname, value, dims, istart, iend, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
class(*), intent(in) :: value(:,:,:,:,:,:,:)
character(*), intent(in), optional :: dims(7)
integer, intent(in), dimension(7), optional :: istart, iend
integer, intent(in), dimension(7), optional :: chunk_size
end subroutine

end interface


interface  !< read.f90

module subroutine get_chunk(self, dname, chunk_size)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
integer, intent(out) :: chunk_size(:)
end subroutine
module integer function get_ndim(self, dname) result (drank)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function get_ndim

module subroutine get_shape(self, dname, dims, dimnames)
class(netcdf_file), intent(in)  :: self
character(*), intent(in)         :: dname
integer, intent(out), allocatable :: dims(:)
character(NF90_MAX_NAME), intent(out), allocatable, optional :: dimnames(:)
end subroutine

module logical function get_deflate(self, dname)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function

module logical function nc_check_exist(self, dname) result(exists)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function nc_check_exist

module logical function nc_exist(filename, dname)
character(*), intent(in) :: filename, dname
end function nc_exist
end interface

interface !< reader.f90
module subroutine nc_read_scalar(self, dname, value)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value
!! inout for character
end subroutine

module subroutine nc_read_1d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:)
integer, intent(in), dimension(1), optional :: istart, iend
end subroutine

module subroutine nc_read_2d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:)
integer, intent(in), dimension(2), optional :: istart, iend
end subroutine

module subroutine nc_read_3d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:)
integer, intent(in), dimension(3), optional :: istart, iend
end subroutine

module subroutine nc_read_4d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:)
integer, intent(in), dimension(4), optional :: istart, iend
end subroutine

module subroutine nc_read_5d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:,:)
integer, intent(in), dimension(5), optional :: istart, iend
end subroutine

module subroutine nc_read_6d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:,:,:)
integer, intent(in), dimension(6), optional :: istart, iend
end subroutine

module subroutine nc_read_7d(self, dname, value, istart, iend)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(:,:,:,:,:,:,:)
integer, intent(in), dimension(7), optional :: istart, iend
end subroutine

end interface


interface !< attributes.f90
module subroutine write_attribute(self, dname, attrname, value)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, attrname
class(*), intent(in) :: value
end subroutine

module subroutine read_attribute(self, dname, attrname, value)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname, attrname
class(*), intent(inout) ::  value
!! inout for character
end subroutine

end interface


interface !< utils.f90

module subroutine nc_open(self, filename, action, comp_lvl, verbose, debug)
!! Opens NetCDF file

class(netcdf_file), intent(inout) :: self
character(*), intent(in) :: filename
character(*), intent(in), optional :: action
integer, intent(in), optional :: comp_lvl
logical, intent(in), optional :: verbose, debug
end subroutine

module subroutine destructor(self)
!! Close file and handle if user forgets to do so
type(netcdf_file), intent(inout) :: self
end subroutine

module subroutine nc_close(self)
class(netcdf_file), intent(inout) :: self
end subroutine

module function nc4version()
!! get NetCDF4 library version
character(:), allocatable :: nc4version
end function

module logical function is_chunked(self, dname)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function

module logical function is_contig(self, dname)
class(netcdf_file), intent(in) :: self
character(*), intent(in) :: dname
end function

module logical function is_netcdf(filename)
!! is this file NetCDF4?
character(*), intent(in) :: filename
end function

module logical function check_error(code, dname)
integer, intent(in) :: code
character(*), intent(in) :: dname
end function

end interface


end module nc4fortran

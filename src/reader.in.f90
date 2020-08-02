submodule (nc4fortran:read) reader
!! This submodule is for reading 0-D..7-D data

implicit none (type, external)

contains

module procedure nc_read_scalar
integer :: varid, ier

if(.not.self%is_open) error stop 'ERROR:nc4fortran:reader file handle not open'

ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (character(*))
  !! NetCDF4 requires knowing the exact character length as if it were an array without fill values
  !! HDF5 is not this strict; having a longer string variable than disk variable is OK in HDF5, but not NetCDF4
  charshape : block
    integer, allocatable :: dims(:)
    call self%shape(dname, dims)
    charbuf : block
      character(len=dims(1)) :: buf
      ier = nf90_get_var(self%ncid, varid, buf)
      value = buf
    end block charbuf
  end block charshape
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_scalar


module procedure nc_read_1d
@reader_template@
end procedure nc_read_1d


module procedure nc_read_2d
@reader_template@
end procedure nc_read_2d


module procedure nc_read_3d
@reader_template@
end procedure nc_read_3d


module procedure nc_read_4d
@reader_template@
end procedure nc_read_4d


module procedure nc_read_5d
@reader_template@
end procedure nc_read_5d


module procedure nc_read_6d
@reader_template@
end procedure nc_read_6d


module procedure nc_read_7d
@reader_template@
end procedure nc_read_7d


end submodule reader

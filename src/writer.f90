submodule (nc4fortran:write) writer
!! This submodule is for writing 0-D..7-D data
!! Note: for HDF5-based NetCDF4 file, nf90_enddef is implicit by nf90_put_var

use netcdf, only : nf90_float, nf90_double, nf90_int, nf90_int64, nf90_char, nf90_enddef
implicit none (type, external)

contains


module procedure nc_write_scalar
integer :: varid, ier, lenid

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open for ' // dname // ' in ' // self%filename

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%ncid, dname, varid)
else
  select type (value)
  type is (real(real32))
    ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
  type is (real(real64))
    ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
  type is (integer(int32))
    ier = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
  type is (integer(int64))
    ier = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
  type is (character(*))
    !! string prefill method
    !! https://www.unidata.ucar.edu/software/netcdf/docs-fortran/f90-variables.html#f90-reading-and-writing-character-string-values
    ier = nf90_def_dim(self%ncid, dname // "StrLen", len(value) + 1, lenid)
    if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_CHAR, dimids=lenid, varid=varid)
    if(ier == NF90_NOERR) ier = nf90_enddef(self%ncid)  !< prefill
  class default
    error stop "unkown type for " // dname // " in " // self%filename
  end select
endif
if (check_error(ier, dname)) error stop 'nc4fortran:write: setup write ' // dname // ' in ' // self%filename

select type (value)
type is (real(real32))
  ier = nf90_put_var(self%ncid, varid, value)
type is (real(real64))
  ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_put_var(self%ncid, varid, value)
type is (character(*))
  ier = nf90_put_var(self%ncid, varid, value)
class default
  error stop "unkown type for " // dname // " in " // self%filename
end select

if (check_error(ier, dname)) error stop 'nc4fortran:write: write ' // dname // ' in ' // self%filename

end procedure nc_write_scalar

module procedure nc_write_1d
include "writer_template.inc"
end procedure nc_write_1d

module procedure nc_write_2d
include "writer_template.inc"
end procedure nc_write_2d

module procedure nc_write_3d
include "writer_template.inc"
end procedure nc_write_3d

module procedure nc_write_4d
include "writer_template.inc"
end procedure nc_write_4d

module procedure nc_write_5d
include "writer_template.inc"
end procedure nc_write_5d

module procedure nc_write_6d
include "writer_template.inc"
end procedure nc_write_6d

module procedure nc_write_7d
include "writer_template.inc"
end procedure nc_write_7d


end submodule writer
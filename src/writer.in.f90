submodule (nc4fortran:write) writer
!! This submodule is for writing 0-D..7-D data
!! Note: for HDF5-based NetCDF4 file, nf90_enddef is implicit by nf90_put_var

use netcdf, only : nf90_float, nf90_double, nf90_int, nf90_int64, nf90_char, nf90_enddef
implicit none (type, external)

contains

module procedure nc_write_scalar_char
integer :: varid, ier, lenid

if(.not.self%is_open) error stop 'ERROR:nc4fortran:writer: file handle not open'

!! uses string prefill method
!! https://www.unidata.ucar.edu/software/netcdf/docs-fortran/f90-variables.html#f90-reading-and-writing-character-string-values

ier = nf90_def_dim(self%ncid, dname // "StrLen", len(value) + 1, lenid)
if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_CHAR, dimids=lenid, varid=varid)

if(ier == NF90_NOERR) ier = nf90_enddef(self%ncid)  !< prefill
if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:write could not write ' // dname

end procedure nc_write_scalar_char

module procedure nc_write_scalar_r32
integer :: varid, ier

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open for ' // dname

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%ncid, dname, varid)
else
  ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
endif

if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:write: could not write ' // dname

end procedure nc_write_scalar_r32

module procedure nc_write_scalar_r64
integer :: varid, ier

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open for ' // dname

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%ncid, dname, varid)
else
  ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
endif

if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:write: could not write ' // dname

end procedure nc_write_scalar_r64


module procedure nc_write_scalar_i32
integer :: varid, ier

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open for ' // dname

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%ncid, dname, varid)
else
  ier = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
endif

if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:write: could not write ' // dname

end procedure nc_write_scalar_i32


module procedure nc_write_scalar_i64
integer :: varid, ier

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open for ' // dname

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%ncid, dname, varid)
else
  ier = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
endif

if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:write: could not write ' // dname

end procedure nc_write_scalar_i64


module procedure nc_write_1d
@writer_template@
end procedure nc_write_1d


module procedure nc_write_2d
@writer_template@
end procedure nc_write_2d


module procedure nc_write_3d
@writer_template@
end procedure nc_write_3d


module procedure nc_write_4d
@writer_template@
end procedure nc_write_4d


module procedure nc_write_5d
@writer_template@
end procedure nc_write_5d


module procedure nc_write_6d
@writer_template@
end procedure nc_write_6d


module procedure nc_write_7d
@writer_template@
end procedure nc_write_7d


end submodule writer

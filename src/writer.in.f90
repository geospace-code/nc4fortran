submodule (nc4fortran:write) writer
!! This submodule is for writing 0-D..7-D data
!! Note: for HDF5-based NetCDF4 file, nf90_enddef is implicit by nf90_put_var

use netcdf, only : nf90_float, nf90_double, nf90_int, nf90_int64, nf90_char, nf90_enddef
implicit none (type, external)

contains

module procedure nc_write_scalar
integer :: varid, ier

if(.not.self%is_open) error stop 'ERROR:nc4fortran:writer: file handle not open'

ier = NF90_NOERR

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%ncid, dname, varid)
else
  select type (value)
  type is (real(real64))
    ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
  type is (real(real32))
    ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
  type is (integer(int32))
    ier = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
  type is (integer(int64))
    ier = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
  end select
endif

if(ier/=NF90_NOERR) write(stderr,*) 'ERROR:nc4fortran:writer:scalar: problem getting varid'

if(ier == NF90_NOERR) then
  select type (value)
  type is (character(*))
    !! uses string prefill method
    !! https://www.unidata.ucar.edu/software/netcdf/docs-fortran/f90-variables.html#f90-reading-and-writing-character-string-values
    block
      integer :: lenid
      ier = nf90_def_dim(self%ncid, dname // "StrLen", len(value) + 1, lenid)
      if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_CHAR, dimids=lenid, varid=varid)
    end block
    if(ier == NF90_NOERR) ier = nf90_enddef(self%ncid)  !< prefill
    if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
  type is (real(real64))
    ier = nf90_put_var(self%ncid, varid, value)
  type is (real(real32))
    ier = nf90_put_var(self%ncid, varid, value)
  type is (integer(int32))
    ier = nf90_put_var(self%ncid, varid, value)
  type is (integer(int64))
    ier = nf90_put_var(self%ncid, varid, value)
  class default
    ier = NF90_EBADTYPE
  end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

end procedure nc_write_scalar


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

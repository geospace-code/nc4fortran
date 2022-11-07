submodule (nc4fortran:write) writer_scalar

implicit none (type, external)

contains

module procedure nc_write_scalar
integer :: varid, ier, lenid

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%file_id, dname, varid)
else
  select type (A)
  type is (real(real32))
    ier = nf90_def_var(self%file_id, dname, NF90_FLOAT, varid=varid)
  type is (real(real64))
    ier = nf90_def_var(self%file_id, dname, NF90_DOUBLE, varid=varid)
  type is (integer(int32))
    ier = nf90_def_var(self%file_id, dname, NF90_INT, varid=varid)
  type is (integer(int64))
    ier = nf90_def_var(self%file_id, dname, NF90_INT64, varid=varid)
  type is (character(*))
    !! string prefill method
    !! https://www.unidata.ucar.edu/software/netcdf/docs-fortran/f90-variables.html#f90-reading-and-writing-character-string-values
    ier = nf90_def_dim(self%file_id, dname // "StrLen", len(A) + 1, lenid)
    if(ier == NF90_NOERR) ier = nf90_def_var(self%file_id, dname, NF90_CHAR, dimids=lenid, varid=varid)
    if(ier == NF90_NOERR) ier = nf90_enddef(self%file_id)  !< prefill
  class default
    error stop "ERROR:nc4fortran:write: unknown type for " // dname // " in " // self%filename
  end select
endif
if (check_error(ier, dname)) error stop 'nc4fortran:write: setup write ' // dname // ' in ' // self%filename

select type (A)
type is (real(real32))
  ier = nf90_put_var(self%file_id, varid, A)
type is (real(real64))
  ier = nf90_put_var(self%file_id, varid, A)
type is (integer(int32))
  ier = nf90_put_var(self%file_id, varid, A)
type is (integer(int64))
  ier = nf90_put_var(self%file_id, varid, A)
type is (character(*))
  ier = nf90_put_var(self%file_id, varid, A)
class default
  ier = NF90_EBADTYPE
end select

if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:write:  ' // dname // ' in ' // self%filename

end procedure nc_write_scalar

end submodule writer_scalar

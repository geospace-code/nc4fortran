integer :: varid, dimids(rank(value)), ier, dtype

call self%def_dims(dname, dimnames=dims, dims=shape(value), dimids=dimids)

select type (value)
type is (real(real32))
  dtype = NF90_FLOAT
type is (real(real64))
  dtype = NF90_DOUBLE
type is (integer(int32))
  dtype = NF90_INT
type is (integer(int64))
  dtype = NF90_INT64
class default
  error stop "unsupported type for variable: " // dname
end select

if(self%comp_lvl >= 1 .and. self%comp_lvl <= 9) then
  ier = nf90_def_var(self%ncid, dname, dtype, dimids=dimids, varid=varid, &
    shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
else
  ier = nf90_def_var(self%ncid, dname, dtype, dimids=dimids, varid=varid)
end if
if (check_error(ier, dname)) error stop 'nc4fortran:write def ' // dname // ' in ' // self%filename

select type (value)
type is (real(real32))
  ier = nf90_put_var(self%ncid, varid, value)
type is (real(real64))
  ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_put_var(self%ncid, varid, value)
class default
  ier = NF90_EBADTYPE
end select

if (check_error(ier, dname)) error stop 'nc4fortran:write write ' // dname // ' in ' // self%filename

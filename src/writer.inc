integer :: varid, ier, dtype

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
  error stop "ERROR:nc4fortran:write: unsupported type for variable: " // dname
end select

call nc_create(self, dname, dtype, dims=shape(value), dim_names=dims, varid=varid)

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

if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:write:  ' // dname // ' in ' // self%filename

integer :: varid, ier, dtype
integer, dimension(rank(value)) :: i0, i1

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%file_id, dname, varid)
else
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
    ier = NF90_EBADTYPE
  end select

  call nc_create(self, dname, dtype, dims=shape(value), dim_names=dims, chunk_size=chunk_size, varid=varid)
endif

i0 = 1
if(present(istart)) i0 = istart

i1 = shape(value)
if(present(iend)) i1 = iend

select type (value)
type is (real(real32))
  ier = nf90_put_var(self%file_id, varid, value, start=istart)
type is (real(real64))
  ier = nf90_put_var(self%file_id, varid, value, start=istart)
type is (integer(int32))
  ier = nf90_put_var(self%file_id, varid, value, start=istart)
type is (integer(int64))
  ier = nf90_put_var(self%file_id, varid, value, start=istart)
class default
  ier = NF90_EBADTYPE
end select

if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:write:  ' // dname // ' in ' // self%filename

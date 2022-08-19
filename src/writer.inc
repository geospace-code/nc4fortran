integer :: varid, ier, dtype
integer, dimension(rank(A)) :: i

if (self%exist(dname)) then
  ier = nf90_inq_varid(self%file_id, dname, varid)
else
  select type (A)
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

  call nc_create(self, dname, dtype, dims=shape(A), dim_names=dims, chunk_size=chunk_size, varid=varid)
endif

if(present(istart) .and. present(iend)) then
  i = iend - istart + 1
else
  i = shape(A)
endif

select type (A)
type is (real(real32))
  ier = nf90_put_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
type is (real(real64))
  ier = nf90_put_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
type is (integer(int32))
  ier = nf90_put_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
type is (integer(int64))
  ier = nf90_put_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
class default
  ier = NF90_EBADTYPE
end select

if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:write:  ' // dname // ' in ' // self%filename

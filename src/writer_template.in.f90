integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dimnames=dims, dims=shape(value), dimids=dimids, ierr=ier)

select type (value)
type is (real(real64))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  if(ier == NF90_NOERR) ier = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
class default
  ierr = NF90_EBADTYPE
end select

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

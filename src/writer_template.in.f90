integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dimnames=dims, dims=shape(value), dimids=dimids, ierr=ier)

if(ier == NF90_NOERR) then
if(self%comp_lvl >= 1 .and. self%comp_lvl <= 9) then
  select type (value)
  type is (real(real64))
    ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid, &
      shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
  type is (real(real32))
    ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid, &
      shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
  type is (integer(int64))
    ier = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid, &
      shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
  type is (integer(int32))
    ier = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid, &
      shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
  class default
    ierr = NF90_EBADTYPE
  end select
else
  select type (value)
  type is (real(real64))
    ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  type is (real(real32))
    ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  type is (integer(int64))
    ier = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  type is (integer(int32))
    ier = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  class default
    ierr = NF90_EBADTYPE
  end select
endif
endif

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_put_var(self%ncid, varid, value)
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

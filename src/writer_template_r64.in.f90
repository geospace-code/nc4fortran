integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dimnames=dims, dims=shape(value), dimids=dimids, ierr=ier)

if(ier == NF90_NOERR) then
if(self%comp_lvl >= 1 .and. self%comp_lvl <= 9) then
  ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid, &
    shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
else
  ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
endif
endif

if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:write could not write ' // dname


submodule (nc4fortran:write) writer
!! This submodule is for writing 0-D..7-D data

implicit none (type, external)

contains

module procedure nc_write_scalar
integer :: varid, ier

if(.not.self%is_open) error stop 'ERROR:nc4fortran:writer: file handle not open'

select type (value)
type is (real(real64))
  ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
class default
  ier = NF90_EBADTYPE
end select

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

end procedure nc_write_scalar


module procedure nc_write_1d
integer :: varid, dimids(rank(value)),ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_1d


module procedure nc_write_2d
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_2d


module procedure nc_write_3d
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_3d


module procedure nc_write_4d
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_4d


module procedure nc_write_5d
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_5d


module procedure nc_write_6d
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_6d


module procedure nc_write_7d
integer :: varid, dimids(rank(value)), ier

call self%def_dims(dname, dims, shape(value), dimids, ier)

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

end procedure nc_write_7d


end submodule writer

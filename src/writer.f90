submodule (netcdf_interface:write) writer

implicit none

contains

module procedure nc_write_scalar
integer :: varid

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_scalar


module procedure nc_write_1d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_1d


module procedure nc_write_2d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_2d


module procedure nc_write_3d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_3d


module procedure nc_write_4d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_4d


module procedure nc_write_5d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_5d


module procedure nc_write_6d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_6d


module procedure nc_write_7d
integer :: varid, dimids(rank(value))

call self%def_dims(dname, dimnames, shape(value), dimids, ierr)
if (ierr/=NF90_NOERR) return

select type (value)
type is (real(real64))
  ierr = nf90_def_var(self%ncid, dname, NF90_DOUBLE, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_def_var(self%ncid, dname, NF90_FLOAT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT64, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_def_var(self%ncid, dname, NF90_INT, dimids=dimids, varid=varid)
  if (self%check_error(ierr, dname)) return
  ierr = nf90_put_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select
if (self%check_error(ierr, dname)) return

end procedure nc_write_7d


end submodule writer
submodule (nc4fortran:read) reader
!! This submodule is for reading 0-D..7-D data

implicit none (type, external)

contains

module procedure nc_read_scalar
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

end procedure nc_read_scalar


module procedure nc_read_1d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

end procedure nc_read_1d


module procedure nc_read_2d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_2d


module procedure nc_read_3d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_3d


module procedure nc_read_4d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_4d


module procedure nc_read_5d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_5d


module procedure nc_read_6d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_6d


module procedure nc_read_7d
integer :: varid, ier
ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
select type (value)
type is (real(real64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif
end procedure nc_read_7d


end submodule reader

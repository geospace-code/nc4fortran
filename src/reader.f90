submodule (nc4fortran:read) reader

implicit none

contains

module procedure nc_read_scalar
integer :: varid


ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_scalar


module procedure nc_read_1d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_1d


module procedure nc_read_2d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_2d


module procedure nc_read_3d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_3d


module procedure nc_read_4d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_4d


module procedure nc_read_5d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_5d


module procedure nc_read_6d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_6d


module procedure nc_read_7d
integer :: varid

ierr = nf90_inq_varid(self%ncid, dname, varid)
if (check_error(ierr, dname)) return

select type (value)
type is (real(real64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (real(real32))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int64))
  ierr = nf90_get_var(self%ncid, varid, value)
type is (integer(int32))
  ierr = nf90_get_var(self%ncid, varid, value)
class default
  write(stderr,*) 'ERROR: ' // dname // ' datatype is not handled yet by nc4fortran.'
  ierr = NF90_EBADTYPE
end select

if (check_error(ierr, dname)) return
end procedure nc_read_7d


end submodule reader
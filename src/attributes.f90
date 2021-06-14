submodule (nc4fortran) attributes

use netcdf, only : nf90_put_att, nf90_get_att
implicit none (type, external)


contains

module procedure write_attribute
integer :: varid, ier

if(.not.self%is_open) error stop 'nc4fortran:write_attribute: file handle not open'

ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == nf90_noerr) then
select type(value)
type is (character(*))
   ier = nf90_put_att(self%ncid, varid, attrname, value)
type is (real(real32))
  ier = nf90_put_att(self%ncid, varid, attrname, value)
type is (real(real64))
  ier = nf90_put_att(self%ncid, varid, attrname, value)
type is (integer(int32))
  ier = nf90_put_att(self%ncid, varid, attrname, value)
class default
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:attributes: failed to write' // attrname

end procedure write_attribute


module procedure read_attribute
integer :: varid, ier

if(.not.self%is_open) error stop 'nc4fortran:read_attribute: file handle not open'

ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == nf90_noerr) then
select type (value)
type is (character(*))
  ier = nf90_get_att(self%ncid, varid, attrname, value)
type is (real(real32))
  ier = nf90_get_att(self%ncid, varid, attrname, value)
type is (real(real64))
  ier = nf90_get_att(self%ncid, varid, attrname, value)
type is (integer(int32))
  ier = nf90_get_att(self%ncid, varid, attrname, value)
class default
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname) .and. .not. present(ierr)) error stop 'nc4fortran:attributes: failed to read' // attrname

end procedure read_attribute


end submodule attributes

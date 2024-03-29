submodule (nc4fortran) attributes

use netcdf, only : nf90_put_att, nf90_get_att
implicit none (type, external)


contains

module procedure write_attribute
integer :: varid, ier

ier = nf90_inq_varid(self%file_id, dname, varid)

if(ier == nf90_noerr) then
select type(A)
type is (character(*))
   ier = nf90_put_att(self%file_id, varid, attrname, A)
type is (real(real32))
  ier = nf90_put_att(self%file_id, varid, attrname, A)
type is (real(real64))
  ier = nf90_put_att(self%file_id, varid, attrname, A)
type is (integer(int32))
  ier = nf90_put_att(self%file_id, varid, attrname, A)
class default
  ier = NF90_EBADTYPE
end select
endif

if (check_error(ier, dname)) error stop 'nc4fortran:attributes: failed to write' // attrname

end procedure write_attribute


module procedure read_attribute
integer :: varid, ier

ier = nf90_inq_varid(self%file_id, dname, varid)

if(ier == nf90_noerr) then
select type (A)
type is (character(*))
  ier = nf90_get_att(self%file_id, varid, attrname, A)
type is (real(real32))
  ier = nf90_get_att(self%file_id, varid, attrname, A)
type is (real(real64))
  ier = nf90_get_att(self%file_id, varid, attrname, A)
type is (integer(int32))
  ier = nf90_get_att(self%file_id, varid, attrname, A)
class default
  ier = NF90_EBADTYPE
end select
endif

if (check_error(ier, dname)) error stop 'nc4fortran:attributes: failed to read' // attrname

end procedure read_attribute


end submodule attributes

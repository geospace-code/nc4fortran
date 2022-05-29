integer :: varid, ier, drank, i(rank(value))

if(.not.self%is_open) error stop 'nc4fortran:reader file handle not open'

ier = nf90_inq_varid(self%file_id, dname, varid)
if (check_error(ier, dname)) error stop 'nc4fortran:read inquire_id ' // dname // ' in ' // self%filename

ier = nf90_inquire_variable(self%file_id, varid, ndims=drank)
if (check_error(ier, dname)) error stop 'nc4fortran:read inquire ' // dname // ' in ' // self%filename
if(drank /= rank(value)) then
  write(stderr,*) 'ERROR:nc4fortran:read ' // dname // ' rank ', drank, ' /= variable rank ',rank(value)
  error stop
endif

if(present(istart) .and. present(iend)) then
  i = iend - istart + 1
else
  i = shape(value)
endif

select type (value)
type is (real(real64))
  ier = nf90_get_var(self%file_id, varid, value, start=istart, count=i)
type is (real(real32))
  ier = nf90_get_var(self%file_id, varid, value, start=istart, count=i)
type is (integer(int64))
  ier = nf90_get_var(self%file_id, varid, value, start=istart, count=i)
type is (integer(int32))
  ier = nf90_get_var(self%file_id, varid, value, start=istart, count=i)
class default
  ier = NF90_EBADTYPE
end select


if (check_error(ier, dname)) error stop 'nc4fortran:read read ' // dname // ' in ' // self%filename

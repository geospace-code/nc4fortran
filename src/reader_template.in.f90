integer :: varid, ier, drank


if(.not.self%is_open) error stop 'ERROR:nc4fortran:reader file handle not open'

ier = nf90_inq_varid(self%ncid, dname, varid)

if(ier == NF90_NOERR) then
  ier = nf90_inquire_variable(self%ncid, varid, ndims=drank)
  if(drank /= rank(value)) then
    ier = NF90_EDIMSIZE
    write(stderr,*) 'ERROR: ' // dname // ' rank ', drank, ' /= variable rank ',rank(value)
    return
  endif
endif

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
  ier = NF90_EBADTYPE
end select
endif

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

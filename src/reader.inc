integer :: varid, ier, drank, i(rank(A))

if(.not.self%is_open) error stop 'ERROR:nc4fortran:reader file handle not open'

ier = nf90_inq_varid(self%file_id, dname, varid)
if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:read inquire_id ' // dname // ' in ' // self%filename

ier = nf90_inquire_variable(self%file_id, varid, ndims=drank)
if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:read inquire ' // dname // ' in ' // self%filename
if(drank /= rank(A)) then
  write(stderr,'(a,i0,a,i0)') 'ERROR:nc4fortran:read ' // dname // ' rank ', drank, ' /= variable rank ', rank(A)
  error stop
endif

if(present(istart) .and. present(iend)) then
  i = iend - istart + 1
else
  i = shape(A)
endif

select type (A)
type is (real(real64))
  ier = nf90_get_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
type is (real(real32))
  ier = nf90_get_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
type is (integer(int64))
  ier = nf90_get_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
type is (integer(int32))
  ier = nf90_get_var(self%file_id, varid, A, start=istart, count=i, stride=stride)
class default
  ier = NF90_EBADTYPE
end select


if (check_error(ier, dname)) error stop 'ERROR:nc4fortran:read read ' // dname // ' in ' // self%filename

submodule (nc4fortran) write

use netcdf, only : nf90_float, nf90_double, nf90_int, nf90_int64, nf90_enddef, NF90_CHAR, nf90_def_var_fill

implicit none (type, external)

contains


module procedure nc_create

integer :: var_id, dimids(size(dims)), ier

call def_dims(self, dset_name, dimnames=dim_names, dims=dims, dimids=dimids)

if(present(chunk_size)) then
  ier = nf90_def_var(self%file_id, dset_name, dtype, dimids=dimids, varid=var_id, &
    shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl, chunksizes=chunk_size)
else
  ier = nf90_def_var(self%file_id, dset_name, dtype, dimids=dimids, varid=var_id, &
    shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
endif
if (check_error(ier, dset_name)) error stop 'ERROR:nc4fortran:write def ' // dset_name // ' in ' // self%filename

if(present(fill_value)) call filler(self%file_id, var_id, dtype, fill_value)

ier = nf90_enddef(self%file_id)
if (check_error(ier, dset_name)) error stop 'ERROR:nc4fortran:write end_def ' // dset_name // ' in ' // self%filename

if(present(varid)) varid = var_id

end procedure nc_create


subroutine filler(file_id, var_id, dtype, fill_value)

integer, intent(in) :: file_id, var_id, dtype
class(*), intent(in) :: fill_value

character(NF90_MAX_NAME) :: dset_name
integer :: ier

ier = nf90_inquire_variable(file_id, var_id, dset_name)

select type(fill_value)
!! type_id MUST equal the fill_value type or "transfer()" like bit pattern unexpected data will result
type is (real(real32))
  if(dtype == NF90_FLOAT) then
    ier = nf90_def_var_fill(file_id, var_id, 0, fill_value)
  elseif(dtype == NF90_DOUBLE) then
    ier = nf90_def_var_fill(file_id, var_id, 0, real(fill_value, real64))
  else
    error stop 'ERROR:nc4fortran:write def fill datatype does not match ' // trim(dset_name)
  endif
type is (real(real64))
  if(dtype == NF90_FLOAT) then
    ier = nf90_def_var_fill(file_id, var_id, 0, real(fill_value, real32))
  elseif(dtype == NF90_DOUBLE) then
    ier = nf90_def_var_fill(file_id, var_id, 0, fill_value)
  else
    error stop 'ERROR:nc4fortran:write def fill datatype does not match ' // trim(dset_name)
  endif
type is (integer(int32))
  if(dtype == NF90_INT) then
    ier = nf90_def_var_fill(file_id, var_id, 0, fill_value)
  elseif(dtype == NF90_INT64) then
    ier = nf90_def_var_fill(file_id, var_id, 0, int(fill_value, int32))
  else
    error stop 'ERROR:nc4fortran:write def fill datatype does not match ' // trim(dset_name)
  endif
type is (integer(int64))
  if(dtype == NF90_INT) then
    ier = nf90_def_var_fill(file_id, var_id, 0, int(fill_value, int64))
  elseif(dtype == NF90_INT64) then
    ier = nf90_def_var_fill(file_id, var_id, 0, fill_value)
  else
    error stop 'ERROR:nc4fortran:write def fill datatype does not match ' // trim(dset_name)
  endif
type is (character(*))
  error stop "ERROR:nc4fortran:write def " // trim(dset_name) // ": NetCDF4 character variables cannot have fill values"
class default
  error stop "ERROR:nc4fortran:write def " // trim(dset_name) // ": NetCDF4 datatype not supported"
end select
if (check_error(ier, "")) error stop 'ERROR:nc4fortran:write fill_value ' // trim(dset_name)

end subroutine filler


module procedure nc_flush
integer :: ier

ier = nf90_sync(self%file_id)
if (check_error(ier, "")) error stop
end procedure nc_flush


module procedure def_dims
!! checks if dimension name exists. if not, create dimension
integer :: i, ierr
character(NF90_MAX_NAME) :: name

if(.not.self%is_open) error stop 'ERROR:nc4fortran:write:def_dims: file handle not open'

do i=1,size(dims)
  if (present(dimnames)) then
    ierr = nf90_inq_dimid(self%file_id, dimnames(i), dimids(i))
    if(ierr==NF90_NOERR) cycle
    !! dimension already exists
  endif
  !! create new dimension
  if(present(dimnames)) then
    ierr = nf90_def_dim(self%file_id, dimnames(i), dims(i), dimids(i))
  else
    write(name,'(A,A4,I1)') dname,"_dim",i
    ierr = nf90_def_dim(self%file_id, trim(name), dims(i), dimids(i))
    ! print *,trim(name)
  endif
  if (check_error(ierr, dname)) error stop "ERROR:nc4fortran:write def_dim " // dname // " in " // self%filename
end do

end procedure def_dims


end submodule write

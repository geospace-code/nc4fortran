submodule (nc4fortran) write

use netcdf, only : nf90_float, nf90_double, nf90_int, nf90_int64, nf90_enddef, NF90_CHAR, nf90_def_var_fill

implicit none (type, external)

contains


module procedure nc_create

integer :: var_id, dimids(size(dims)), ier

call self%def_dims(dset_name, dimnames=dim_names, dims=dims, dimids=dimids)

if(self%comp_lvl >= 1 .and. self%comp_lvl <= 9) then
  ier = nf90_def_var(self%ncid, dset_name, dtype, dimids=dimids, varid=var_id, &
    shuffle=.true., fletcher32=.true., deflate_level=self%comp_lvl)
else
  ier = nf90_def_var(self%ncid, dset_name, dtype, dimids=dimids, varid=var_id)
end if
if (check_error(ier, dset_name)) error stop 'ERROR:nc4fortran:write def ' // dset_name // ' in ' // self%filename

if(present(fill_value)) then
  select type(fill_value)
  type is (real(real32))
    ier = nf90_def_var_fill(self%ncid, var_id, 0, fill_value)
  type is (real(real64))
    ier = nf90_def_var_fill(self%ncid, var_id, 0, fill_value)
  type is (integer(int32))
    ier = nf90_def_var_fill(self%ncid, var_id, 0, fill_value)
  type is (integer(int64))
    ier = nf90_def_var_fill(self%ncid, var_id, 0, fill_value)
  end select
  if (check_error(ier, dset_name)) error stop 'ERROR:nc4fortran:write fill_value ' // dset_name // ' in ' // self%filename
endif

ier = nf90_enddef(self%ncid)
if (check_error(ier, dset_name)) error stop 'ERROR:nc4fortran:write end_def ' // dset_name // ' in ' // self%filename

if(present(varid)) varid = var_id

end procedure nc_create


module procedure nc_flush
integer :: ier

ier = nf90_sync(self%ncid)
if (check_error(ier, "")) error stop
end procedure nc_flush


module procedure def_dims
!! checks if dimension name exists. if not, create dimension
integer :: i, ierr
character(NF90_MAX_NAME) :: name

if(.not.self%is_open) error stop 'nc4fortran:write: file handle not open'

do i=1,size(dims)
  if (present(dimnames)) then
    ierr = nf90_inq_dimid(self%ncid, dimnames(i), dimids(i))
    if(ierr==NF90_NOERR) cycle
    !! dimension already exists
  endif
  !! create new dimension
  if(present(dimnames)) then
    ierr = nf90_def_dim(self%ncid, dimnames(i), dims(i), dimids(i))
  else
    write(name,'(A,A4,I1)') dname,"_dim",i
    ierr = nf90_def_dim(self%ncid, trim(name), dims(i), dimids(i))
    ! print *,trim(name)
  endif
  if (check_error(ierr, dname)) return
end do

end procedure def_dims


end submodule write

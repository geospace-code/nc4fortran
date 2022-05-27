program test_fill

use, intrinsic:: iso_fortran_env, only : real32, real64, int32, int64
use, intrinsic:: ieee_arithmetic, only : ieee_value, ieee_quiet_nan

use nc4fortran, only : netcdf_file
use netcdf, only : NF90_FLOAT, NF90_DOUBLE, NF90_INT, NF90_INT64, NF90_CHAR

implicit none (type, external)

type(netcdf_file) :: nc

real(real32) :: Nan_r32, r32
real(real64) :: Nan_r64, r64
integer(int32) :: i32
integer(int64) :: i64

call nc%open("test_fill.nc", "w")

call nc%create("real32", NF90_FLOAT, [1], fill_value=NaN_r32)
call nc%create("real64", NF90_FLOAT, [1,1], fill_value=NaN_r64)
call nc%create("int32", NF90_INT, [1], fill_value=-1)
call nc%create("int64", NF90_INT64, [1], fill_value=-1)

call nc%close()

call nc%open("test_fill.nc", "r")

call nc%read("real32", r32)
call nc%read("real64", r64)
call nc%read("int32", i32)
call nc%read("int64", i64)

print *, r32, r64, i32, i64

call nc%close()

end program

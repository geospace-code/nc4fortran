program test_fill

use, intrinsic:: iso_fortran_env, only : real32, real64, int32, int64
use, intrinsic:: ieee_arithmetic, only : ieee_value, ieee_quiet_nan, ieee_is_finite

use nc4fortran, only : netcdf_file
use netcdf, only : NF90_FLOAT, NF90_DOUBLE, NF90_INT, NF90_INT64, NF90_CHAR

implicit none (type, external)

type(netcdf_file) :: nc

real(real32) :: Nan32, r32
real(real64) :: Nan64, r64
integer(int32) :: i32
integer(int64) :: i64

NaN32 = ieee_value(0., ieee_quiet_nan)
NaN64 = ieee_value(0._real64, ieee_quiet_nan)

call nc%open("test_fill.nc", "w")

call nc%create("real32", NF90_FLOAT, [1], fill_value=NaN32)
call nc%create("real64>32", NF90_FLOAT, [1], fill_value=NaN64)

call nc%create("real32>64", NF90_DOUBLE, [1,1], fill_value=NaN32)
call nc%create("real64", NF90_DOUBLE, [1,1], fill_value=NaN64)

call nc%create("int32", NF90_INT, [1], fill_value=-1)
call nc%create("int64>32", NF90_INT64, [1], fill_value=int(-1, int64))

call nc%create("int64", NF90_INT64, [1], fill_value=int(-1, int64))

call nc%close()

call nc%open("test_fill.nc", "r")

call nc%read("real32", r32)
call nc%read("real64", r64)
call nc%read("int32", i32)
call nc%read("int64", i64)

if (ieee_is_finite(r32)) error stop "fill cast float32"
if (ieee_is_finite(r64)) error stop "fill cast float64"
if (i32 /= -1 .or. i64 /= -1) error stop "fill cast int"

call nc%close()

end program

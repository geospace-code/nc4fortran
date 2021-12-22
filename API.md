# nc4fortran Usage

All examples assume:

```fortran
use nc4fortran, only: netcdf_file
type(netcdf_file) :: hf
```

* gzip compression may be applied for rank &ge; 2 arrays by setting `comp_lvl` to a value between 1 and 9.
  Shuffle filter is automatically applied for better compression
* string attributes may be applied to any variable at time of writing or later.

Check NetCDF4 library version:

```fortran
use nc4fortran, only: nc4version
print *, nc4version()
```

Create new NetCDF file, with variable "value1"

```fortran
call hf%open('test.nc', action='w')

call hf%write('value1', 123.)

call hf%close()
```

Check if variable exists

```fortran
logical :: exists

exists = hf%exist('fooname')
```

Add/append variable "value1" to existing NetCDF file "test.nc"

* if file `test.nc` exists, add a variable to it
* if file `test.nc` does not exist, create it and add a variable to it.

```fortran
call hf%open('test.nc', action='rw')

call hf%write('value1', 123.)

call hf%close()
```

Read scalar, 3-D array of unknown size

```fortran
call ncf%open('test.nc', action='r')

integer, allocatable :: dims(:)
real, allocatable :: A(:,:,:)

call ncf%shape('foo', dims)
allocate(A(dims(1), dims(2), dims(3)))
call ncf%read('foo', A)

call ncf%close()
```

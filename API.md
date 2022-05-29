# nc4fortran API

This document provides a listing of nc4fortran `public` scoped user-facing procedures and methods with a summary of their parameters.

All examples assume:

```fortran
use nc4fortran, only: netcdf_file

type(netcdf_file) :: h
```

Query NetCDF4 library version:

```fortran
use nc4fortran, only : nc4version
print *, nc4version()
```

## Open NetCDF4 file reference

More than one NetCDF4 file can be open in a program, by declaring unique file handle (variable) like:

```fortran
type(netcdf_file) :: h1, h2, h3
```

```fortran
call h%open(filename, action, comp_lvl)
!! Opens hdf5 file

character(*), intent(in) :: filename
character(*), intent(in), optional :: action  !< r, w, rw
integer, intent(in), optional      :: comp_lvl  !< 0: no compression. 1-9: ZLIB compression, higher is more compressior
```

## Close NetCDF4 file reference

```fortran
call h%close()
!! This must be called on each open file to flush buffers to disk
!! data loss can occur if program terminates before this procedure
```

To avoid memory leaks or corrupted files, always "close" files before STOPping the Fortran program.

## Flush data to disk while file is open

```fortran
call h%flush()
```

## Disk variable (dataset) inquiry

To allocate variables before reading data, inquire about dataset characteristics with these procedures.

```fortran
rank = h%ndim(dataset_name)

character(*), intent(in) :: dataset_name
```

Get disk dataset shape (1D vector)

```fortran
call h%shape(dataset_name, dims)

character(*), intent(in) :: dataset_name
integer(HSIZE_T), intent(out), allocatable :: dims(:)
```

Does dataset "dname" exist in this HDF5 file?

```fortran
tf = h%exist(dname)

character(*), intent(in) :: dname
```

Is dataset "dname" contiguous on disk?

```fortran
tf = h%is_contig(dname)

character(*), intent(in) :: dname
```

These are more advanced inquiries into the memory layout of the dataset, for advanced users:

```fortran
call h%chunks(dname, chunk_size)

character(*), intent(in) :: dname
integer, intent(out) :: chunk_size(:)
```

## file write operations

```fortran
call h%write(dname,value, istart, iend, stride, chunk_size)
!! write 0d..7d dataset
character(*), intent(in) :: dname
class(*), intent(in) :: value(:)  !< array to write
integer, intent(in), optional :: chunk_size(rank(value))
integer, intent(in), optional, dimension(:) :: istart, iend, stride  !< array slicing
```

Write dataset attribute (e.g. units or instrument)

```fortran
call h%writeattr(dname, attr, attrval)

character(*), intent(in) :: dname, attr  !< dataset name, attribute name
class(*), intent(in) :: attrval(:)  !< character, real, integer
```

## file read operations

Read data from disk to memory

```fortran
call h%read(dname, value, istart, iend, stride)
character(*), intent(in)         :: dname
class(*), intent(out) :: value(:)  !< read array to this ALLOCATED variable
integer, intent(in), optional, dimension(:) :: istart, iend, stride !< array slicing
```

Read dataset attribute into memory

```fortran
call h%readattr(dname, attr, attrval)
character(*), intent(in) :: dname, attr  !< dataset name, attribute name
class(*), intent(out) :: attrval(:)  !< character, real, integer
```

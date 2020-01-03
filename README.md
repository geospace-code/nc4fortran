# NetCDF

[![Actions Status](https://github.com/scivision/nc4fortran/workflows/ci_cmake/badge.svg)](https://github.com/scivision/nc4fortran/actions)
[![Actions Status](https://github.com/scivision/nc4fortran/workflows/ci_meson/badge.svg)](https://github.com/scivision/nc4fortran/actions)

Straightforward single-module access to NetCDF4.
Designed for easy use as a Meson "subproject" or CMake "ExternalProject" using **static** or **shared** linking.
Uses Fortran 2008 `submodule` and `error stop` for clean template structure.
This easy-to-use, thin object-oriented modern Fortran library abstracts away the messy parts of NetCDF4 so that you can read/write various types/ranks of data with a single command.

Polymorphic API with read/write for types int32, int64, real32, real64 with rank:

* scalar (0-D)
* 1-D .. 7-D

Mismatched datatypes are coerced as per standard Fortran rules.
For example, reading a float HDF5 variable into an integer Fortran variable:  42.3 => 42

Tested on systems with NetCDF4 including:

* MacOS (homebrew)
* Ubuntu 16.04 / 18.04 (gfortran 6 or newer)
* Windows Subsystem for Linux

Currently, Cygwin and MSYS2 do not have *Fortran* NetCDF4 libraries.

## Not yet handled

It's possible to do these things, if there is user need.

* character variables
* arrays of rank > 7
* complex64 / complex128

## Build

Requirements:

* modern Fortran compiler (this project uses `submodule` and `error stop`). For example, Gfortran &ge; 6.
* NetCDF4 Fortran library
  * Mac / Homebrew: `brew install gcc netcdf`
  * Linux: `apt install gfortran libnetcdf-dev libnetcdff-dev`
  * Windows Subsystem for Linux: `apt install gfortran libnetcdf-dev libnetcdff-dev`

Note that some precompiled NetCDF4 libraries include C / C++ without Fortran.
Platforms that currently do **not** have Fortran NetCDF4 libraries, and thus will **not** work with nc4fortran unless you compile NetCDF library for Fortran include:

* Cygwin
* Conda
* MSYS2

Build this NetCDF OO Fortran interface with Meson or CMake.
The library `libnetcdf_interface.a` is built, link it into your program as usual.

### Meson

```sh
meson build

meson test -C build
```

Meson &ge; 0.53.0 has enhanced NetCDF dependency finding and is recommended.
To include nc4fotran as a Meson subproject, in the master project meson.build (that uses nc4fortran) have like:

```meson
hdf5_proj = subproject('nc4fortran')
hdf5_interface = hdf5_proj.get_variable('hdf5_interface')

my_exe = exectuable('myexe', 'main.f90', dependencies: hdf5_interface)
```

and have a file in the master project `subprojects/nc4fortran.wrap` containing:

```ini
[wrap-git]
directory = nc4fortran
url = https://github.com/scivision/nc4fortran.git
revision = head
```

### CMake

```sh
cmake -B build

cmake --build build --parallel
```

Optionally run self-tests:

```sh
cd build

ctest -V
```

To specify a particular HDF5 library, use

```sh
cmake -DHDF5_ROOT=/path/to/hdf5lib -B build
```

or set environment variable `HDF5_ROOT=/path/to/hdf5lib`

To use nc4fortran as a CMake ExternalProject do like:

```cmake
include(ExternalProject)

ExternalProject_Add(nc4fortran
  GIT_REPOSITORY https://github.com/scivision/nc4fortran.git
  GIT_TAG master  # it's better to use a specific Git tag for reproducibility
  INSTALL_COMMAND ""  # disables the install step for the external project
)

ExternalProject_Get_Property(nc4fortran BINARY_DIR)
set(nc4fortran_BINARY_DIR BINARY_DIR)  # just to avoid accidentally reusing the variable name.

# your code "myio"
add_executable(myio myio.f90)
add_dependencies(myio nc4fortran)
target_link_directories(myio PRIVATE ${nc4fortran_BINARY_DIR})
target_link_libraries(myio PRIVATE nc4fortran)
target_include_directories(myio PRIVATE ${nc4fortran_BINARY_DIR})
```

## Usage

All examples assume:

```fortran
use hdf5_interface, only: hdf5_file
type(hdf5_file) :: h5f
```

* gzip compression may be applied for rank &ge; 2 arrays by setting `comp_lvl` to a value betwen 1 and 9.
  Shuffle filter is automatically applied for better compression
* string attributes may be applied to any variable at time of writing or later.
* `chunk_size` option may be set for better compression

`integer, intent(out) :: ierr` is a mandatory parameter. It will be non-zero if error detected.
This value should be checked, particularly for write operations to avoid missing error conditions.
The design choice to keep `error stop` out of nc4fortran was in line with the HDF5 library itself.
Major Fortran libraries like MPI also make this design choice, perhaps since Fortran doesn't currently
have exception handling.

### Create new HDF5 file, with variable "value1"

```fortran
call h5f%initialize('test.h5', ierr, status='new',action='w')

call h5f%write('/value1', 123., ierr)

call h5f%finalize(ierr)
```

### Add/append variable "value1" to existing HDF5 file "test.h5"

* if file `test.h5` exists, add a variable to it
* if file `test.h5` does not exist, create it and add a variable to it.

```fortran
call h5f%initialize('test.h5', ierr, status='unknown',action='rw')

call h5f%write('/value1', 123., ierr)

call h5f%finalize(ierr)
```

### Add gzip compressed 3-D array "value2" to existing HDF5 file "test.h5"

```fortran
real :: val2(1000,1000,3) = 0.

call h5f%initialize('test.h5', ierr, comp_lvl=1)

call h5f%write('/value2', val2, ierr)

call h5f%finalize(ierr)
```

chunk_size may optionally be set in the `%write()` method.

### Read scalar, 3-D array of unknown size

```fortran
call h5f%initialize('test.h5', ierr, status='old',action='r')

integer(hsize_t), allocatable :: dims(:)
real, allocatable :: A(:,:,:)

call h5f%shape('/foo',dims, ierr)
allocate(A(dims(1), dims(2), dims(3)))
call h5f%read('/foo', A)

call h5f%finalize(ierr)
```

### Create group "scope"

```fortran
real :: val2(1000,1000,3) = 0.

call h5f%initialize('test.h5', ierr)

call h5f%write('/scope/', ierr)

call h5f%finalize(ierr)
```

## Permissive syntax

We make the hdf5%open(..., status=...) like Fortran open()

* overwrite (truncate) existing file: open with `status='new'` or `status='replace'`
* append to existing file or create file: `status='old'` or `status='unknown'`

Note the trailing `/` on `/scope/`, that tells the API you are creating a group instead of a variable.

## Notes

* The first character of the filename should be a character, NOT whitespace to avoid file open/creation errors.
* Using compilers like PGI or Flang may require first compiling the HDF5 library yourself.
* Intel compiler HDF5 [compile notes](https://www.hdfgroup.org/downloads/hdf5/source-code/)
* Polymorphic array rank is implemented by explicit code internally. We could have used pointers, but the code is simple enough to avoid the risk associated with explicit array pointers. Also, `select rank` support requires Gfortran-10 or Intel Fortran 2020, so we didn't want to make too-new compiler restriction.

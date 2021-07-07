# Object-oriented Fortran 2008 NetCDF4 interface

[![DOI](https://zenodo.org/badge/229812591.svg)](https://zenodo.org/badge/latestdoi/229812591)
[![CDash](./archive/cdash.png)](https://my.cdash.org/index.php?project=nc4fortran)

![ci](https://github.com/geospace-code/nc4fortran/workflows/ci/badge.svg)
![ci_meson](https://github.com/geospace-code/nc4fortran/workflows/ci_meson/badge.svg)

Simple, robust, thin, object-oriented NetCDF4 polymorphic read/write interface.
For HDF5 see [h5fortran](https://github.com/geospace-code/h5fortran).
Designed for easy use as a Meson "subproject" or CMake "ExternalProject" using **static** or **shared** linking.
Uses Fortran 2008 `submodule` for clean template structure.
nc4fortran abstracts away the messy parts of NetCDF4 so that you can read/write various types/ranks of data with a single command.
In distinction from other high-level NetCDF4 interfaces, nc4fortran works to deduplicate code, using polymorphism wherever feasible, with an extensive test suite.

Polymorphic API with read/write for types int32, int64, real32, real64 with rank:

* scalar (0-D)
* 1-D .. 7-D

Also:

* read/write **character** variables.
* read/write character, int, float, double attributes

Mismatched datatypes are coerced as per standard Fortran rules.
For example, reading a float NetCDF4 variable into an integer Fortran variable:  42.3 => 42

Tested on systems with NetCDF4 including:

* MacOS
* Ubuntu 18.04 / 20.04
* Windows Subsystem for Linux
* Windows Cygwin

## Build

Requirements:

* modern Fortran compiler: examples: GCC &ge; 7 or Intel oneAPI &ge; 2021
* NetCDF4 Fortran library
  * Mac / Homebrew: `brew install gcc netcdf`
  * Linux: `apt install gfortran libnetcdf-dev libnetcdff-dev`
  * Windows Subsystem for Linux: `apt install gfortran libnetcdf-dev libnetcdff-dev`
  * Windows Cygwin `libnetcdf-fortran-devel`

Note that some precompiled NetCDF4 libraries include C / C++ without Fortran.
Platforms that currently do **not** have Fortran NetCDF4 libraries, and thus will **not** work with nc4fortran unless you compile NetCDF library for Fortran include:

* Cygwin
* Conda
* MSYS2

Build this NetCDF OO Fortran interface with Meson or CMake.
The library `libnc4fortran.a` is built, link it into your program as usual.

### CMake

```sh
cmake -B build
cmake --build build

# optional
ctest --test-dir build
```

To specify a particular NetCDF library, use

```sh
cmake -DNetCDF_ROOT=/path/to/netcdff -B build
```

or set environment variable `NetCDF_ROOT=/path/to/netcdff`

To use nc4fortran as a CMake ExternalProject do like:

```cmake
include(FetchContent)

FetchContent_Declare(nc4fortran_proj
  GIT_REPOSITORY https://github.com/geospace-code/nc4fortran.git
  GIT_TAG v1.3.0)

FetchContent_MakeAvailable(nc4fortran_proj)

# ------------------------------------------------------
# whatever your program is
add_executable(myProj main.f90)
target_link_libraries(myProj nc4fortran::nc4fortran)
```

### Meson

To build nc4fortran as a standalone project

```sh
meson build

meson test -C build
```

To include nc4fortran as a Meson subproject, in the master project meson.build (that uses nc4fortran) have like:

```meson
nc4_proj = subproject('nc4fortran')
nc4_interface = nc4_proj.get_variable('nc4_interface')

my_exe = executable('myexe', 'main.f90', dependencies: nc4_interface)
```

and have a file in the master project `subprojects/nc4fortran.wrap` containing:

```ini
[wrap-git]
directory = nc4fortran
url = https://github.com/geospace-code/nc4fortran.git
revision = head
```

## Usage

All examples assume:

```fortran
use nc4fortran, only: netcdf_file
type(netcdf_file) :: hf
```

* gzip compression may be applied for rank &ge; 2 arrays by setting `comp_lvl` to a value between 1 and 9.
  Shuffle filter is automatically applied for better compression
* string attributes may be applied to any variable at time of writing or later.

`integer, intent(out) :: ierr` is optional.
It will be non-zero if error detected.
This value should be checked, particularly for write operations to avoid missing error conditions.
If `ierr` is omitted, nc4fortran will `error stop` on error.

### Create new NetCDF file, with variable "value1"

```fortran
call hf%open('test.nc', action='w')

call hf%write('value1', 123.)

call hf%close()
```

### Check if variable exists

This will not raise error stop, even if the file isn't opened, but it will print a message to stderr.

```fortran
logical :: exists

exists = hf%exist('fooname')
```

### Add/append variable "value1" to existing NetCDF file "test.nc"

* if file `test.nc` exists, add a variable to it
* if file `test.nc` does not exist, create it and add a variable to it.

```fortran
call hf%open('test.nc', action='rw')

call hf%write('value1', 123.)

call hf%close()
```

### Read scalar, 3-D array of unknown size

```fortran
call ncf%open('test.nc', action='r')

integer, allocatable :: dims(:)
real, allocatable :: A(:,:,:)

call ncf%shape('foo', dims)
allocate(A(dims(1), dims(2), dims(3)))
call ncf%read('foo', A)

call ncf%close()
```

## Permissive syntax

We make the ncf%open(..., action=...) like Fortran open()

* overwrite (truncate) existing file: open with `action='w'`
* append to existing file or create file: `action='rw'`

## Notes

* The first character of the filename should be a character, NOT whitespace to avoid file open/creation errors.
* Using compilers like PGI or Flang may require first compiling the NetCDF library yourself.
* Polymorphic array rank is implemented by explicit code internally. We could have used pointers, but the code is simple enough to avoid the risk associated with explicit array pointers. Also, `select rank` support requires Gfortran-10 or Intel Fortran 2020, so we didn't want to make too-new compiler restriction.

# Object-oriented Fortran NetCDF4 interface

[![DOI](https://zenodo.org/badge/229812591.svg)](https://zenodo.org/badge/latestdoi/229812591)
![ci](https://github.com/geospace-code/nc4fortran/workflows/ci/badge.svg)
[![ci_windows](https://github.com/geospace-code/nc4fortran/actions/workflows/ci_windows.yml/badge.svg)](https://github.com/geospace-code/nc4fortran/actions/workflows/ci_windows.yml)
[![ci_fpm](https://github.com/geospace-code/nc4fortran/actions/workflows/ci_fpm.yml/badge.svg)](https://github.com/geospace-code/nc4fortran/actions/workflows/ci_fpm.yml)
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

Datatypes are coerced as per standard Fortran rules.
For example, reading a float NetCDF4 variable into an integer Fortran variable:  42.3 => 42

Tested on systems with NetCDF4 including:

* MacOS
* Linux
* Windows

See [API](./API.md) for usage.

## Build

Requirements:

* modern Fortran compiler: examples: GCC &ge; 7 or Intel oneAPI &ge; 2021
* NetCDF4 Fortran library
  * Mac / Homebrew: `brew install gcc netcdf`
  * Linux: `apt install gfortran libnetcdf-dev libnetcdff-dev`
  * Windows Subsystem for Linux: `apt install gfortran libnetcdf-dev libnetcdff-dev`
  * Windows Cygwin `libnetcdf-fortran-devel`

Note that some precompiled NetCDF4 libraries include C / C++ without Fortran.

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
)

FetchContent_MakeAvailable(nc4fortran_proj)

# ------------------------------------------------------
# whatever your program is
add_executable(myProj main.f90)
target_link_libraries(myProj nc4fortran::nc4fortran)
```

### Fortran Package Manager (fpm)

```sh
fpm build
fpm test
fpm install
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
nc4_interface = nc4_proj.get_variable('netcdf_interface')

my_exe = executable('myexe', 'main.f90', dependencies: nc4_interface)
```

and have a file in the master project `subprojects/nc4fortran.wrap` containing:

```ini
[wrap-git]
directory = nc4fortran
url = https://github.com/geospace-code/nc4fortran.git
```

# NetCDF

[![Actions Status](https://github.com/scivision/netcdf4fortran/workflows/ci_cmake/badge.svg)](https://github.com/scivision/netcdf4fortran/actions)
[![Actions Status](https://github.com/scivision/netcdf4fortran/workflows/ci_meson/badge.svg)](https://github.com/scivision/netcdf4fortran/actions)

These examples write and read a NetCDF file from Fortran.

## Prereqs

* Linux: libnetcdff-dev
* Homebrew: netcdf

## Build

```meson
meson build

meson test -C build
```

OR

```cmake
cmake -B build

cmake --build build

cmake --build build --target test
```

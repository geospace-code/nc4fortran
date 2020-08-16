# nc4ortran Example project

It's easiest to use CMake with nc4fortran, since HDF5 consists of many library files and headers.
From the nc4fortran/ directory, build the examples (or change to the Examples/ directory):

```sh
cmake -B Examples/build -S Examples
cmake --build Examples/build
```

which creates examples under the Examples/build direcotry

If you installed nc4fortran previously, you can use that version by:

```sh
cmake -B Examples/build -S Examples -Dnc4fortran_DIR=~/libs/nc4fortran/lib/cmake/nc4fortran
```

## Examples

Example 1 and 2 show the object-oriented interface of nc4fortran, which may offer faster performance if more than one variable is being read or written.

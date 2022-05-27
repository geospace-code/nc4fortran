# nc4ortran Examples

From the nc4fortran/ directory, specify the nc4fortran install like:

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/nc4fortran
cmake --build build
cmake --install build

cmake -B Examples/build -S Examples -Dnc4fortran_ROOT=~/nc4fortran
```

## Examples

Example 1 and 2 show the object-oriented interface of nc4fortran, which may offer faster performance if more than one variable is being read or written.

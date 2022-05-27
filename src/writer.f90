submodule (nc4fortran:write) writer
!! Note: for HDF5-based NetCDF4 file, nf90_enddef is implicit by nf90_put_var

implicit none (type, external)

contains


module procedure nc_write_1d
include "writer.inc"
end procedure nc_write_1d

module procedure nc_write_2d
include "writer.inc"
end procedure nc_write_2d

module procedure nc_write_3d
include "writer.inc"
end procedure nc_write_3d

module procedure nc_write_4d
include "writer.inc"
end procedure nc_write_4d

module procedure nc_write_5d
include "writer.inc"
end procedure nc_write_5d

module procedure nc_write_6d
include "writer.inc"
end procedure nc_write_6d

module procedure nc_write_7d
include "writer.inc"
end procedure nc_write_7d


end submodule writer

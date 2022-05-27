submodule (nc4fortran:read) reader

implicit none (type, external)

contains

module procedure nc_read_1d
include "reader.inc"
end procedure nc_read_1d


module procedure nc_read_2d
include "reader.inc"
end procedure nc_read_2d


module procedure nc_read_3d
include "reader.inc"
end procedure nc_read_3d


module procedure nc_read_4d
include "reader.inc"
end procedure nc_read_4d


module procedure nc_read_5d
include "reader.inc"
end procedure nc_read_5d


module procedure nc_read_6d
include "reader.inc"
end procedure nc_read_6d


module procedure nc_read_7d
include "reader.inc"
end procedure nc_read_7d


end submodule reader

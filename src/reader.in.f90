submodule (nc4fortran:read) reader
!! This submodule is for reading 0-D..7-D data

implicit none (type, external)

contains

module procedure nc_read_scalar
@reader_template@
end procedure nc_read_scalar


module procedure nc_read_1d
@reader_template@
end procedure nc_read_1d


module procedure nc_read_2d
@reader_template@
end procedure nc_read_2d


module procedure nc_read_3d
@reader_template@
end procedure nc_read_3d


module procedure nc_read_4d
@reader_template@
end procedure nc_read_4d


module procedure nc_read_5d
@reader_template@
end procedure nc_read_5d


module procedure nc_read_6d
@reader_template@
end procedure nc_read_6d


module procedure nc_read_7d
@reader_template@
end procedure nc_read_7d


end submodule reader

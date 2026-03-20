# --- Fortran compile flags

set(nc4fortran_fflags)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")

list(APPEND nc4fortran_fflags
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug,RelWithDebInfo>>:-warn>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-traceback;-check;-debug>"
)

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")

list(APPEND nc4fortran_fflags
"$<$<COMPILE_LANGUAGE:Fortran>:-fimplicit-none>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug,RelWithDebInfo>>:-Wall>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-Wextra;-fcheck=all;-Werror=array-bounds>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Release>>:-fno-backtrace>"
)

endif()

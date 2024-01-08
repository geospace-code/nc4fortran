# --- C compile flags
if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU|^Intel")
  add_compile_options(
  "$<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Debug>>:-Wextra>"
  "$<$<COMPILE_LANGUAGE:C>:-Wall>"
  "$<$<COMPILE_LANGUAGE:C>:-Werror=implicit-function-declaration>"
  )
elseif(CMAKE_C_COMPILER_ID MATCHES "MSVC")
  add_compile_options("$<$<COMPILE_LANGUAGE:C>:/W3>")
endif()

if(WIN32)
  if(CMAKE_C_COMPILER_ID MATCHES "^Intel|MSVC")
    add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Debug>>:/Od>)
  endif()
elseif(CMAKE_C_COMPILER_ID MATCHES "^Intel")
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Debug>>:-O0>)
endif()

# --- Fortran compile flags
if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")

add_compile_options(
"$<$<COMPILE_LANGUAGE:Fortran>:-warn>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-traceback;-check;-debug>"
)

if(WIN32)
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:/Od>)
else()
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-O0>)
endif()

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")

add_compile_options(
"$<$<COMPILE_LANGUAGE:Fortran>:-Wall;-fimplicit-none;-Wno-maybe-uninitialized>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-Wextra;-fcheck=all;-Werror=array-bounds>"
"$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Release>>:-fno-backtrace>"
)

endif()

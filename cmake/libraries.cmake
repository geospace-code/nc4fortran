set(names netcdfC netcdfFortran hdf5 zlib)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)

foreach(n ${names})
  foreach(t url sha256)
    string(JSON ${n}_${t} GET ${_libj} ${n} ${t})
  endforeach()
endforeach()

cmake_minimum_required(VERSION 2.8)
project("libPGAPACK" C)

find_package(MPI)

if (MPI_C_FOUND)
message(STATUS "mpi found")
else()
  file(COPY include/fakempi_h DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include)
  file(RENAME ${CMAKE_CURRENT_BINARY_DIR}/include/fakempi_h ${CMAKE_CURRENT_BINARY_DIR}/include/mpi.h)
  file(COPY ${CMAKE_CURRENT_BINARY_DIR}/include/mpi.h DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/include)
  add_definitions(-DFAKE_MPI)
endif()

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/include")
include_directories("${CMAKE_CURRENT_BINARY_DIR}/include")
file(GLOB_RECURSE PGAPACK_SOURCES "source/*.c")

add_definitions(-DWL=32)
add_library(libPGAPACK ${PGAPACK_SOURCES})
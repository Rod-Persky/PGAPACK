cmake_minimum_required(VERSION 2.8)
project("PGAPACK" C)

find_package(MPI)
if (MPI_FOUND)
  option(MPI_PGAPACK_USEMPI "Enable PGAPACK MPI (All depending will require MPI)" OFF)
else()
  message(STATUS "MPI_PGAPACK_USEMPI: MPI is not available in current environment")
endif()

# Sources
file(GLOB_RECURSE PGAPACK_SOURCES "source/*.c")

# Include Directories
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/include")
include_directories("${CMAKE_CURRENT_BINARY_DIR}/include")

# Output
add_library(PGAPACK ${PGAPACK_SOURCES})
add_definitions(-DWL=32)

# Depending on presence of MPI change some options

if (MPI_PGAPACK_USEMPI)
  message(STATUS "PGAPACK: MPI enabled")
  
  # Remove fake MPI
  file(REMOVE include/mpi.h)
  list(REMOVE_ITEM PGAPACK_SOURCES "source/mpi_stub.c")
  
  # Extra includes / links
  include_directories(${MPI_INCLUDE_PATH})
  target_link_libraries(PGAPACK ${MPI_LIBRARIES})
  
  # Change compiler
  set(CMAKE_COMPILE_FLAGS ${CMAKE_COMPILE_FLAGS} ${MPI_COMPILE_FLAGS})
  set(CMAKE_LINK_FLAGS    ${CMAKE_LINK_FLAGS}    ${MPI_LINK_FLAGS})
  
else()
  message(STATUS "PGAPACK: MPI not enabled")
  
  file(COPY include/fakempi_h DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include)
  file(RENAME ${CMAKE_CURRENT_BINARY_DIR}/include/fakempi_h ${CMAKE_CURRENT_BINARY_DIR}/include/mpi.h)
  file(COPY ${CMAKE_CURRENT_BINARY_DIR}/include/mpi.h DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/include)
  
  add_definitions(-DFAKE_MPI)
endif()


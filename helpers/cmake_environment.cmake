if(WIN32)

  file(TO_NATIVE_PATH "${BIOFORMATS_EP_BIN_DIR}" WINDOWS_BIN_DIR)
  file(TO_NATIVE_PATH "${BIOFORMATS_EP_PYTHON_DIR}" WINDOWS_PYTHON_DIR)
  set(ENV{PATH} "${WINDOWS_BIN_DIR};${BIOFORMATS_WINDOWS_DIR};$ENV{PATH}")
  set(ENV{CMAKE_PROGRAM_PATH} "${WINDOWS_PYTHON_DIR}\\scripts;$ENV{CMAKE_PROGRAM_PATH}")
  file(GLOB python_dirs LIST_DIRECTORIES true "${BIOFORMATS_EP_PYTHON_DIR}/*/site-packages")
  foreach(dir ${python_dirs})
    if(ENV{PYTHONPATH})
      set(ENV{PYTHONPATH} "${dir};$ENV{PYTHONPATH}")
    else()
      set(ENV{PYTHONPATH} "${dir}")
    endif()
  endforeach()

else()

  set(ENV{PATH} "${BIOFORMATS_EP_BIN_DIR}:${BIOFORMATS_EP_PYTHON_DIR}:$ENV{PATH}")
  set(ENV{CMAKE_PROGRAM_PATH} "${BIOFORMATS_EP_PYTHON_DIR}/bin:$ENV{CMAKE_PROGRAM_PATH}")
  if(APPLE)
    set(ENV{DYLD_FALLBACK_LIBRARY_PATH} "${BIOFORMATS_EP_LIB_DIR}:$ENV{DYLD_FALLBACK_LIBRARY_PATH}")
  else()
    set(ENV{LD_LIBRARY_PATH} "${BIOFORMATS_EP_LIB_DIR}:$ENV{LD_LIBRARY_PATH}")
  endif()
  file(GLOB python_dirs LIST_DIRECTORIES true "${BIOFORMATS_EP_PYTHON_DIR}/*/*/site-packages")
  foreach(dir ${python_dirs})
    if(ENV{PYTHONPATH})
      set(ENV{PYTHONPATH} "${dir}:$ENV{PYTHONPATH}")
    else()
      set(ENV{PYTHONPATH} "${dir}")
    endif()
  endforeach()

endif()

if(WIN32)
  # Windows compiler and linker flags

  file(TO_NATIVE_PATH "${BIOFORMATS_EP_INCLUDE_DIR}" WINDOWS_INCLUDE_DIR)
  file(TO_NATIVE_PATH "${BIOFORMATS_EP_LIB_DIR}" WINDOWS_LIB_DIR)

  set(EP_CXXFLAGS "${EP_CXXFLAGS} \"/I${WINDOWS_INCLUDE_DIR}\"")
  set(EP_LDFLAGS)
  set(ENV{INCLUDE} "${WINDOWS_INCLUDE_DIR};$ENV{INCLUDE}")
  set(ENV{LIB} "${WINDOWS_LIB_DIR};$ENV{LIB}")
else()
  # Unix compiler and linker flags
  set(ENV{AR} "${CMAKE_AR}")
  set(ENV{CC} "${CMAKE_C_COMPILER}")
  set(ENV{CXX} "${CMAKE_CXX_COMPILER}")
  set(ENV{LD} "${CMAKE_LINKER}")
  set(ENV{NM} "${CMAKE_NM}")
  set(ENV{OBJDUMP} "${CMAKE_OBJDUMP}")
  set(ENV{OBJCOPY} "${CMAKE_OBJCOPY}")
  set(ENV{RANLIB} "${CMAKE_RANLIB}")
  set(ENV{STRIP} "${CMAKE_STRIP}")

  set(EP_CXXFLAGS "${EP_CXXFLAGS} \"-I${BIOFORMATS_EP_INCLUDE_DIR}\"")
  set(EP_LDFLAGS "${EP_LDFLAGS} \"-L${BIOFORMATS_EP_LIB_DIR}\"")
endif()

string(REPLACE "^^" ";" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

if (CMAKE_VERBOSE_MAKEFILE AND CMAKE_GENERATOR MATCHES "Ninja")
  set(MAKE_VERBOSE -v)
endif()

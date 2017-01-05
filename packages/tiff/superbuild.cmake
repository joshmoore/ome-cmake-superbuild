# tiff superbuild

# Options to build from git (defaults to source zip if unset)
set(tiff-head OFF CACHE BOOL "Force building libtiff from current CVS head")

# Current stable release.
set(RELEASE_URL "http://download.osgeo.org/libtiff/tiff-4.0.7.tar.gz")
set(RELEASE_HASH "SHA512=941357bdd5f947cdca41a1d31ae14b3fadc174ae5dce7b7981dbe58f61995f575ac2e97a7cc4fcc435184012017bec0920278263490464644f2cdfad9a6c5ddc")

# Current development branch (defaults for head option).
set(CVS_REPOSITORY ":pserver:cvsanon@cvs.maptools.org:/cvs/maptools/cvsroot")
set(CVS_MODULE "libtiff")

# Set dependency list
ome_add_dependencies(tiff THIRD_PARTY_DEPENDENCIES zlib)

if(tiff-head)
  set(EP_SOURCE_DOWNLOAD
    CVS_REPOSITORY "${CVS_REPOSITORY}"
    CVS_MODULE "${CVS_MODULE}")
  message(STATUS "Building libtiff from CVS (URL ${CVS_REPOSITORY}, module ${CVS_MODULE})")
else()
  set(EP_SOURCE_DOWNLOAD
    URL "${RELEASE_URL}"
    URL_HASH "${RELEASE_HASH}")
endif()

# Notes: Using custom CMake build for tiff; this has been submitted
# upstream and may be included in a future release.  If so, the
# files copied in the patch step may be dropped.

list(APPEND CONFIGURE_OPTIONS -Wno-dev --no-warn-unused-cli)
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  ${EP_SOURCE_DOWNLOAD}
  SOURCE_DIR "${EP_SOURCE_DIR}"
  BINARY_DIR "${EP_BINARY_DIR}"
  INSTALL_DIR ""
  CONFIGURE_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    "-DCONFIGURE_OPTIONS=${CONFIGURE_OPTIONS}"
    -P "${GENERIC_CMAKE_CONFIGURE}"
  BUILD_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${GENERIC_CMAKE_BUILD}"
  INSTALL_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${GENERIC_CMAKE_INSTALL}"
  TEST_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${GENERIC_CMAKE_TEST}"
  DEPENDS
    ${EP_PROJECT}-prerequisites
)

cmake_minimum_required(VERSION 3.16)

project(SDL3_Emscripten_Build LANGUAGES C CXX)

# This CMakeLists.txt is designed for Emscripten builds ONLY
# Purpose: Build SDL3, SDL3_ttf, SDL3_image as static libraries (.a) for WebAssembly
# No executable targets are included - this is for library-only builds

# Ensure we're building for Emscripten
if(NOT EMSCRIPTEN)
    message(FATAL_ERROR "This CMakeLists.txt is intended for Emscripten builds only. Use emcmake to configure.")
endif()

# Set build type if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Force static library builds for Emscripten
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries" FORCE)
set(SDL_SHARED OFF CACHE BOOL "Build SDL3 shared library" FORCE)
set(SDL_STATIC ON CACHE BOOL "Build SDL3 static library" FORCE)

# Configure SDL3 options
set(SDL_TEST OFF CACHE BOOL "Build SDL3 tests" FORCE)
set(SDL_EXAMPLES OFF CACHE BOOL "Build SDL3 examples" FORCE)

# Configure installation paths
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation directory" FORCE)
set(CMAKE_INSTALL_LIBDIR "lib" CACHE PATH "Library installation directory" FORCE)
set(CMAKE_INSTALL_INCLUDEDIR "include" CACHE PATH "Header installation directory" FORCE)

message(STATUS "=================================================")
message(STATUS "Building SDL3 libraries for Emscripten/WebAssembly")
message(STATUS "=================================================")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")

# Build SDL3 core library
message(STATUS "Configuring SDL3 core library...")
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../External/SDL SDL_build)

# Note: In this unified build, SDL_ttf and SDL_image should be able to find SDL3::SDL3
# target directly from the build tree. This differs from External/build.sh which
# performs separate builds and installs SDL3 before building extensions.
# Set CMAKE_PREFIX_PATH for consistency, though it may not be strictly necessary
# in a unified build where all targets are in the same build tree.
set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}/lib/cmake" CACHE PATH "CMake prefix path" FORCE)

# Build SDL3_ttf
message(STATUS "Configuring SDL3_ttf library...")
set(SDLTTF_VENDORED ON CACHE BOOL "Use vendored dependencies for SDL_ttf" FORCE)
set(SDLTTF_INSTALL ON CACHE BOOL "Install SDL_ttf" FORCE)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../External/SDL_ttf SDL_ttf_build)

# Build SDL3_image
message(STATUS "Configuring SDL3_image library...")
set(SDLIMAGE_VENDORED ON CACHE BOOL "Use vendored dependencies for SDL_image" FORCE)
set(SDLIMAGE_DEPS_SHARED OFF CACHE BOOL "Build image dependencies as shared" FORCE)
set(SDLIMAGE_AVIF OFF CACHE BOOL "Disable AVIF support" FORCE)
set(SDLIMAGE_INSTALL ON CACHE BOOL "Install SDL_image" FORCE)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../External/SDL_image SDL_image_build)

# Build SDL3_mixer
message(STATUS "Configuring SDL3_mixer library...")
set(SDLMIXER_VENDORED ON CACHE BOOL "Use vendored dependencies for SDL_mixer" FORCE)
set(SDLMIXER_DEPS_SHARED OFF CACHE BOOL "Build mixer dependencies as shared" FORCE)
set(SDLMIXER_MP3_MPG123 OFF CACHE BOOL "Disable MPG123 (use dr_mp3 fallback)" FORCE)
set(SDLMIXER_INSTALL ON CACHE BOOL "Install SDL_mixer" FORCE)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../External/SDL_mixer SDL_mixer_build)

message(STATUS "")
message(STATUS "=================================================")
message(STATUS "Configuration complete!")
message(STATUS "")
message(STATUS "Build with: emmake cmake --build <build_dir>/")
message(STATUS "Install with: emmake cmake --install <build_dir>/")
message(STATUS "")
message(STATUS "Output libraries will be in:")
message(STATUS "  <build_dir>/install/lib/libSDL3.a")
message(STATUS "  <build_dir>/install/lib/libSDL3_ttf.a")
message(STATUS "  <build_dir>/install/lib/libSDL3_image.a")
message(STATUS "  <build_dir>/install/lib/libSDL3_mixer.a")
message(STATUS "=================================================")

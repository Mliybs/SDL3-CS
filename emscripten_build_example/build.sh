#!/bin/bash

# Simple build script for SDL3 Emscripten libraries
# This script automates the build process described in README.md

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${BUILD_DIR}/install"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}SDL3 Emscripten Build Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if emsdk is activated
if ! command -v emcc &> /dev/null; then
    echo -e "${RED}Error: Emscripten SDK (emsdk) not found!${NC}"
    echo "Please install and activate emsdk first:"
    echo "  git clone https://github.com/emscripten-core/emsdk.git"
    echo "  cd emsdk"
    echo "  ./emsdk install latest"
    echo "  ./emsdk activate latest"
    echo "  source ./emsdk_env.sh"
    exit 1
fi

echo -e "${GREEN}✓${NC} Emscripten SDK found: $(emcc --version | head -n1)"
echo ""

# Check if git submodules are initialized
if [ ! -f "${SCRIPT_DIR}/../External/SDL/CMakeLists.txt" ]; then
    echo -e "${YELLOW}Git submodules not initialized. Initializing...${NC}"
    cd "${SCRIPT_DIR}/.."
    git submodule update --init --recursive
    cd "${SCRIPT_DIR}"
    echo ""
fi

echo -e "${GREEN}✓${NC} Git submodules initialized"
echo ""

# Parse command line arguments
BUILD_TYPE="${1:-Release}"
# Use nproc on Linux, sysctl on macOS, or fallback to 4 as default
JOBS="${2:-$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)}"

echo "Build configuration:"
echo "  Build type: ${BUILD_TYPE}"
echo "  Parallel jobs: ${JOBS}"
echo "  Build directory: ${BUILD_DIR}"
echo "  Install directory: ${INSTALL_DIR}"
echo ""

# Configure
echo -e "${YELLOW}Configuring...${NC}"
emcmake cmake -B "${BUILD_DIR}" -S "${SCRIPT_DIR}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"
echo ""

# Build
echo -e "${YELLOW}Building...${NC}"
emmake cmake --build "${BUILD_DIR}" -j"${JOBS}"
echo ""

# Install
echo -e "${YELLOW}Installing...${NC}"
emmake cmake --install "${BUILD_DIR}"
echo ""

# Summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Output libraries:"
if [ -f "${INSTALL_DIR}/lib/libSDL3.a" ]; then
    echo -e "  ${GREEN}✓${NC} ${INSTALL_DIR}/lib/libSDL3.a"
fi
if [ -f "${INSTALL_DIR}/lib/libSDL3_ttf.a" ]; then
    echo -e "  ${GREEN}✓${NC} ${INSTALL_DIR}/lib/libSDL3_ttf.a"
fi
if [ -f "${INSTALL_DIR}/lib/libSDL3_image.a" ]; then
    echo -e "  ${GREEN}✓${NC} ${INSTALL_DIR}/lib/libSDL3_image.a"
fi
if [ -f "${INSTALL_DIR}/lib/libSDL3_mixer.a" ]; then
    echo -e "  ${GREEN}✓${NC} ${INSTALL_DIR}/lib/libSDL3_mixer.a"
fi
echo ""
echo "Headers installed in: ${INSTALL_DIR}/include/"
echo "CMake configs in: ${INSTALL_DIR}/lib/cmake/"
echo ""

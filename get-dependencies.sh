#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    fluidsynth     \
    pipewire-audio \
    pipewire-jack  \
    portmidi       \
    sdl3_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building DOOM64EXUltra..."
echo "---------------------------------------------------------------"
REPO="https://github.com/StevenSYS/DOOM64EXUltra"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./DOOM64EXUltra
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -S ./DOOM64EXUltra -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-Wno-implicit-function-declaration"
cmake --build build -j$(nproc)
mv -v build/DOOM64EXUltra build/doom64ex-ultra.wad ./AppDir/bin

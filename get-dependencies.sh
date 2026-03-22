#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    fluidsynth     \
    libdecor       \
    pipewire-audio \
    pipewire-jack  \
    portmidi       \
    sdl3           \
    sdl3_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package
#make-aur-package sdl3_mixer-git

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of DOOM64EXUltra..."
echo "---------------------------------------------------------------"
REPO="https://github.com/StevenSYS/DOOM64EXUltra"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./DOOM64EXUltra
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./DOOM64EXUltra
cmake . \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-Wno-implicit-function-declaration"
make -j$(nproc)
mv -v DOOM64EXUltra ../AppDir/bin
mv -v doom64ex-ultra.wad ../AppDir/bin

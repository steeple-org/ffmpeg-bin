#!/bin/bash

set -ex

export BUILD_DIR=$PWD
export SOURCE_DIR=$BUILD_DIR/sources
export TMP_DIR=$(mktemp -d)
# OTHER ENV THAT HAS TO BE SET:
#  - OUTPUT_FILE

apt update -qq && apt -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev

pushd $SOURCE_DIR
./configure
make
make install DESTDIR=$TMP_DIR
popd

mkdir $TMP_DIR/DEBIAN
cp $BUILD_DIR/control $TMP_DIR/DEBIAN

chown root:root "$TMP_DIR/DEBIAN/control"

dpkg-deb --build $TMP_DIR $BUILD_DIR/$OUTPUT_FILE

#!/usr/bin/env bash

set -e

USER="$(id -u)"
if [[ "${USER}" != "0" ]] ; then
	echo "error: run as root"
	exit 1
fi

echo "Install PTXdist depencencies..."
dnf config-manager --set-enabled crb
dnf install curl g++ ncurses-devel ncurses flex bison texinfo patch
echo ""

echo "Create temporary working directory..."
WORKDIR="$(mktemp -d)"
pushd ${WORKDIR} > /dev/null
echo "workdir: ${WORKDIR}"
echo ""

echo "Install PTXdist..."
PTXDIST_TAG=Update-2024.12.0
curl -fSL -s -o ptxdist.tar.gz "https://github.com/WAGO/ptxdist/archive/refs/tags/${PTXDIST_TAG}.tar.gz"
tar -xf ptxdist.tar.gz
pushd "ptxdist-${PTXDIST_TAG}" > /dev/null
./configure
make -j
make install
popd > /dev/null
echo ""

echo "Install Toolchain..."
curl -fSL -s -o toolchain.tar.gz https://github.com/WAGO/gcc-toolchain/releases/download/gcc-toolchain-2022.08-wago.1/gcc-linaro.toolchain-2022.08-wago.1-arm-linux-gnueabihf.tar.gz
mkdir -p /opt
tar -xf toolchain.tar.gz -C /opt 
echo ""

echo "Install SDK dependencies"
dnf config-manager --set-enabled extras
dnf install git git-lfs bc perl-Parse-Yapp python python-devel python3-pip python3-setuptools autoconf perl-FindBin perl-CPAN pkg-config libtool lzop gmp-devel libmpc-devel libxslt xmlstarlet  gettext-devel
echo ""

echo "Remove temporary working directory.."
popd > /dev/null
rm -rf "${WORKDIR}"
echo ""

echo "Done"


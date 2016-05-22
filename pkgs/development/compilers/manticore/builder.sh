#!/bin/bash

source $stdenv/setup
echo "Building Manticore research compiler."
set -xe

PATH=$smlnj/bin:$PATH

mkdir -p $out/bin

# Manticore seems to use the MLB files from the build tree,
# so for now we copy the whole build tree into the store:
cd $out/
tar xf $src
mv pmlc-* repo_checkout
cd repo_checkout/
# TODO: At the very least, this could probably be cut down to a subset
# of the repo.

echo "Building manticore version $version"
# For some reason autoconf isn't getting this:
sed -i "s/@REVISION@/$version/" ./src/tools/mc/driver/version-fn_sml.in

${autoconf}/bin/autoheader -Iconfig
${autoconf}/bin/autoconf -Iconfig
./configure --prefix=$out
make build -j
make install

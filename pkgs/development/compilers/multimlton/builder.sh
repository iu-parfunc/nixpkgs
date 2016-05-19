#!/bin/bash

source $stdenv/setup
export PATH=$PATH:${mlton}/bin/

export LD_LIBRARY_PATH=${gmp}/lib:$LD_LIBRARY_PATH

export CPATH=$CPATH:"-I${gmp}/include"

set -xe 
tar xf $src
cd multiMLton-1971b0f74f0db4dce9bad077a9c79ee158933510/trunk
mkdir $out

make all-no-docs

ls build/bin/

set +x

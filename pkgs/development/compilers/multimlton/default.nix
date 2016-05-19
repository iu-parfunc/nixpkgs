{ stdenv, fetchurl, patchelf, gmp, mlton }:

let
  version = "20140310";

  usr_prefix = if stdenv.isDarwin then "usr/local" else "usr";

  dynamic_linker =
    if stdenv.isx86_64 then "${stdenv.glibc.out}/lib/ld-linux-x86-64.so.2"
                       else "${stdenv.glibc.out}/lib/ld-linux.so.2";
in

stdenv.mkDerivation rec {
  name = "multimlton-${version}";
  src =
    fetchurl {
      url = "https://github.com/kayceesrk/multiMLton/archive/1971b0f74f0db4dce9bad077a9c79ee158933510.tar.gz";
      sha256 = "0rzcb61x6nixr0kcjm66mn4asippczvpdq7cik9fxplsy5kf2npc";
    };

  sourceRoot = "multiMLton-1971b0f74f0db4dce9bad077a9c79ee158933510/trunk";
#  sourceRoot = "trunk";

  buildInputs = [ gmp ] ++ stdenv.lib.optional stdenv.isLinux patchelf;

  builder = ./builder.sh;

  inherit stdenv mlton gmp;
# coreutils autoconf automake 

/*
  makeFlags = [ "all-no-docs" ];

  configurePhase = ''
    pwd 
    ls

    # Fix paths in the source.
    find . -type f | grep -v -e '\.tgz''$' | xargs sed -i "s@/usr/bin/env bash@$(type -p bash)@"

    substituteInPlace $(pwd)/Makefile --replace '/bin/cp' $(type -p cp)
    substituteInPlace bin/mlton-script --replace gcc cc
    substituteInPlace bin/regression --replace gcc cc
#    substituteInPlace lib/mlnlffi-lib/Makefile --replace gcc cc
#    substituteInPlace mlnlffigen/gen-cppcmd --replace gcc cc
    substituteInPlace runtime/Makefile --replace gcc cc
#    substituteInPlace ../${usr_prefix}/bin/mlton --replace gcc cc

    # Fix paths in the binary distribution.
    BIN_DIST_DIR="$(pwd)/../${usr_prefix}"
    for f in "bin/mlton" "lib/mlton/platform" "lib/mlton/static-library" ; do
      substituteInPlace "$BIN_DIST_DIR/$f" --replace '/${usr_prefix}/bin/env bash' $(type -p bash)
    done

    substituteInPlace $(pwd)/../${usr_prefix}/bin/mlton --replace '/${usr_prefix}/lib/mlton' $(pwd)/../${usr_prefix}/lib/mlton
  '';

  preBuild = ''
    # To build the source we have to put the binary distribution in the $PATH.
    export PATH="$PATH:$(pwd)/../${usr_prefix}/bin/"

    # Let the builder execute the binary distribution.
    chmod u+x $(pwd)/../${usr_prefix}/bin/mllex
    chmod u+x $(pwd)/../${usr_prefix}/bin/mlyacc
    chmod u+x $(pwd)/../${usr_prefix}/bin/mlton

    # So the builder runs the binary compiler with gmp.
    export LD_LIBRARY_PATH=${gmp.out}/lib:$LD_LIBRARY_PATH

  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Patch ELF interpreter.
    patchelf --set-interpreter ${dynamic_linker} $(pwd)/../${usr_prefix}/lib/mlton/mlton-compile
    for e in mllex mlyacc ; do
      patchelf --set-interpreter ${dynamic_linker} $(pwd)/../${usr_prefix}/bin/$e
    done
  '';

  doCheck = true;

  installTargets = [ "install-no-docs" ];

  postInstall = ''
    # Fix path to mlton libraries.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace '/${usr_prefix}/lib/mlton' $out/lib/mlton

    # Path to libgmp.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace "-link-opt '-lm -lgmp'" "-link-opt '-lm -lgmp -L${gmp.out}/lib'"

    # Path to gmp.h.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace "-cc-opt '-O1 -fno-common'" "-cc-opt '-O1 -fno-common -I${gmp.dev}/include'"

    # Path to the same cc used in the build; needed at runtime.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace "gcc='gcc'" "gcc='"$(type -p cc)"'"

    # Copy files to final positions.
    cp -r $(pwd)/install/${usr_prefix}/bin $out
    cp -r $(pwd)/install/${usr_prefix}/lib $out
    cp -r $(pwd)/install/${usr_prefix}/man $out
  '';

*/

  meta = {
    description = "Parallel, open-source, whole-program, optimizing Standard ML compiler";
    longDescription = ''
      Parallel version of MLton.

      MLton is an open source, whole-program optimizing compiler for the Standard ML programming language.
      MLton aims to produce fast executables, and to encourage rapid prototyping and modular programming
      by eliminating performance penalties often associated with the use of high-level language features.
      MLton development began in 1997, and continues to this day with a growing worldwide community of
      developers and users, who have helped to port MLton to a number of platforms.
      Description taken from http://en.wikipedia.org/wiki/Mlton .
    '';

    homepage = http://multimlton.cs.purdue.edu/mML/Welcome.html; 
    license = "bsd";
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin"];
  };
}

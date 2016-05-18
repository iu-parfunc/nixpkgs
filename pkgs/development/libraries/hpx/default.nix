{ stdenv, fetchurl, perl, gcc
, enableDebug ? false
}:

with stdenv.lib;

let hpxVersion = "3.0.0";
#    pkgs = import nixpkgs;
in stdenv.mkDerivation rec {
  name = "hpx-${hpxVersion}";

  src = fetchurl {
    url = "http://hpx.crest.iu.edu/release/${name}.tar.gz";
    sha256 = "07l58hvnn0miy45ahvq2aa98cwy65bfgjfs9km4vhk480m6r544m";
  };

  enableParallelBuilding = true;
  
  preConfigure = ''
    cd hpx/
  '';

  nativeBuildInputs = [ stdenv ];

# "--enable-shared"    
  dontDisableStatic = true;
  # Weirdly, --enable-static can't go in configureFlagsArray or gcc is sad:
  configureFlags = [ "--enable-shared" "--enable-static" ];
  configureFlagsArray =
     [ "CFLAGS=-g -O3 -fPIC " # -flto
#       "LDFLAGS=-flto"
# NOTE: We can't add -flto yet.  gcc-ar and gcc-ranlib are not exposed
# by the gcc-wrappers package.
#       ("AR="+ gcc + "/bin/gcc-ar")
     ] ++ optional enableDebug [ "--enable-debug" ];
     
  meta = {
    homepage = https://hpx.crest.iu.edu/;
    description = "Open source High Performance paralleX implementation";
    longDescription = "HPX-5 (High Performance ParalleX) is an open source, portable, performance-oriented runtime developed at CREST (Indiana University). HPX-5 provides a distributed programming model allowing programs to run unmodified on systems from a single SMP to large clusters and supercomputers with thousands of nodes.
HPX-5 supports a wide variety of Intel and ARM platforms. It is being used by a broad range of scientific applications enabling scientists to write code that performs and scales better than contemporary runtimes.";
  };
  
}

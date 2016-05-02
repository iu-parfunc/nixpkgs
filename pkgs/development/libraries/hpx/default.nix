{stdenv, fetchurl, perl }:

let hpxVersion = "2.2.0";

in stdenv.mkDerivation rec {       
  name = "hpx-${hpxVersion}";

  src = fetchurl {
    url = http://hpx.crest.iu.edu/release/hpx-2.2.0.tar.gz;
    sha256 = "01sc85ifwdg87jvcgkkqmjg09j2h1d9i1y5vb3lifhrq6za399bs";
  };

  enableParallelBuilding = true;
  
  preConfigure = ''
    cd hpx/
  '';

  nativeBuildInputs = [ stdenv ];

  meta = {
    homepage = https://hpx.crest.iu.edu/;
    description = "Open source High Performance paralleX implementation";
    longDescription = "HPX-5 (High Performance ParalleX) is an open source, portable, performance-oriented runtime developed at CREST (Indiana University). HPX-5 provides a distributed programming model allowing programs to run unmodified on systems from a single SMP to large clusters and supercomputers with thousands of nodes.
HPX-5 supports a wide variety of Intel and ARM platforms. It is being used by a broad range of scientific applications enabling scientists to write code that performs and scales better than contemporary runtimes.";
  };
  
}


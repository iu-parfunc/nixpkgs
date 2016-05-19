{ stdenv, fetchurl, coreutils, autoconf, automake, smlnj }:

stdenv.mkDerivation rec {
  name = "manticore-${version}";
  version = "2016-03-08";
  builder = ./builder.sh;
  src = fetchurl {
    # trunk branch as of 2016-03-08
    url = "https://smlnj-gitlab.cs.uchicago.edu/manticore/pmlc/repository/archive.tar.gz?ref=e88675010e18825e888fdefd2f7129c7b4459c08";
    sha256 = "1nzvmdz8pj935dk05qqw7ychmzpi8rzwxss0k8gjswcxp2f3vl98";
  };
  inherit stdenv coreutils autoconf automake smlnj;

  meta = {
    description = "a parallel, pure variant of Standard ML";

    longDescription = '' 
      Manticore is a high-level parallel programming language aimed at
      general-purpose applications running on multi-core
      processors. Manticore supports parallelism at multiple levels:
      explicit concurrency and coarse-grain parallelism via CML-style
      constructs and fine-grain parallelism via various light-weight
      notations, such as parallel tuple expressions and NESL/Nepal-style
      parallel array comprehensions.  
    '';

    homepage = http://manticore.cs.uchicago.edu/;
  };
}

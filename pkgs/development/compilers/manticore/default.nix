{ stdenv, fetchurl, coreutils, autoconf, automake, smlnj }:

stdenv.mkDerivation rec {
  name = "manticore-${version}";
  version = "2016-05-21";
  builder = ./builder.sh;
  src = fetchurl {
    # trunk branch as of date = $version
    url = "https://smlnj-gitlab.cs.uchicago.edu/manticore/pmlc/repository/archive.tar.gz?ref=9af030cec4c85c32ea2da5897344715d89457a68";
    sha256 = "1phpfn7ns2h59613fcby11w0bgy60mkq11zzayj4zdpnx3nm15if";
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

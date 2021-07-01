{ stdenv, pkgs, libX11, libXinerama, libXft }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "notusknot";
    repo = "dwm";
    sha256 = "1907nqr2km4zdl6q7kyi9b61wai85v5k7slqg73n5l9awwjvh3fy";
    rev = "7114d5e8e57bbf1f6b9de0afdc112eedba3f34fc";
  };

  buildInputs = [ libX11 libXinerama libXft ];
  
  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out DESTDIR="" install
    runHook postInstall
  '';
}

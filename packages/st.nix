{ stdenv, pkgs, libX11, libXinerama, libXft, fontconfig, pkg-config, ncurses, freetype }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-st-${version}";
  version = "0.8.4";

  src = pkgs.fetchFromGitHub {
    owner = "notusknot";
    repo = "st";
    sha256 = "1dg5swr86fvbkvqvy5s8k4mw90igk99q204sf2k7zvzr8a6braak";
    rev = "039efe4b37269e1a55e80761f9e3a4d58d35cb3c";
  };
  
  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  
  buildInputs = [
    libX11
    libXft
    fontconfig
    ncurses
  ];

  buildPhase = ''make'';
  installPhase = ''
    runHook preInstall
    TERMINFO=$out/share/terminfo make PREFIX=$out DESTDIR="" install
    runHook postInstall
  '';
}

self: super: rec {
    nativeBuildInputs = [ super.pkgs.unzip ];

    unpackCmd = ''
        unzip $curSrc
        find . -name "*.pkg" -print -exec 7zz x {} \;
        find . -name "Payload~" -print -exec 7zz x {} \;
    '';

    sourceRoot = "./";

    installPhase = ''
        find . -name '*.otf' -exec install -m444 -Dt $out/share/fonts/opentype {} \;
    '';

    sf-mono = super.stdenv.mkDerivation
        {
        pname = "sf-mono";
        version = "1.0";

        src = super.pkgs.fetchurl {
            url = "https://github.com/epk/SF-Mono-Nerd-Font/releases/download/v15.0d5e1/SF-Mono-Nerd-Font.zip";
            sha256 = "sha256-hiH+QShU2yhGUixlYZ5jXIlo9kszQZELUoapXEaqxhg=";
        };

        inherit nativeBuildInputs unpackCmd sourceRoot installPhase;
    };
}

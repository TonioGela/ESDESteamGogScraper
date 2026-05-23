{
  pkgs ? import (import ./npins).nixpkgs { },
}:
let
  pythonEnv = pkgs.python312.withPackages (
    ps: with ps; [
      requests
      beautifulsoup4
      pytubefix
      fuzzywuzzy
      levenshtein
    ]
  );
in
pkgs.stdenv.mkDerivation {
  pname = "esde-steam-gog-scraper";
  version = "0.1.0";
  src = ./src;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  dontConfigure = true;
  dontBuild = true;
  passthru = { inherit pythonEnv; };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/esde-steam-gog-scraper $out/bin
    cp scrape.py gog.py steam.py gamelist.py pytubewrapper.py \
       $out/share/esde-steam-gog-scraper/

    makeWrapper ${pythonEnv}/bin/python $out/bin/esde-steam-gog-scraper \
      --add-flags "$out/share/esde-steam-gog-scraper/scrape.py"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Scrape game metadata and artwork from GOG.com or Steam for EmulationStation";
    homepage = "https://github.com/TonioGela/ESDESteamGogScraper";
    mainProgram = "esde-steam-gog-scraper";
    platforms = platforms.unix;
  };
}

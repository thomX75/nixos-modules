# Amiberry 7 directly from GitHub, built from source.
# https://github.com/thomX75/nixos-modules

# This is modified version of already packaged Amiberry by michaelshmitty.
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/am/amiberry/package.nix

{ config, pkgs, lib, ... }:

let

  amiberry-git = pkgs.stdenv.mkDerivation rec {
    pname = "amiberry";
    version = "7.0.4";

    src = pkgs.fetchFromGitHub {
      owner = "BlitterStudio";
      repo = "amiberry";
      rev = "v${version}";
      hash = "sha256-d4ys305+zlKb912B30UEoAm8eoou8IZNhfqi13WvuKQ=";
    };

    nativeBuildInputs = with pkgs; [
      cmake
      copyDesktopItems
      makeWrapper
    ];

    buildInputs = with pkgs; [
      enet
      flac
      libmpeg2
      libmpg123
      libpng
      libserialport
      portmidi
      SDL2
      SDL2_image
      SDL2_ttf
    ];

    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp amiberry $out/bin/
      cp -r data $out/
      install -Dm444 data/amiberry.png $out/share/icons/hicolor/256x256/apps/amiberry.png
      wrapProgram $out/bin/amiberry \
        --set-default AMIBERRY_DATA_DIR $out/data/
      runHook postInstall
    '';

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "amiberry";
        desktopName = "Amiberry";
        exec = "amiberry";
        comment = "Amiga emulator";
        icon = "amiberry";
        categories = [
          "System"
          "Emulator"
        ];
      })
    ];

    meta = with lib; {
      homepage = "https://github.com/BlitterStudio/amiberry";
      description = "Optimized Amiga emulator for Linux/macOS";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ thomX75 ];
      mainProgram = "amiberry";
    };
  };

in

{
  environment.systemPackages = with pkgs; [ amiberry-git ];
}
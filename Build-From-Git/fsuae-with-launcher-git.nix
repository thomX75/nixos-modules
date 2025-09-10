# FS-UAE and FS-UAE-Launcher merged into one module, build directly from GitHub.
# https://github.com/thomX75/nixos-modules

{ pkgs, lib, ... }:

let
  fsuae = pkgs.stdenv.mkDerivation rec {
    pname = "fs-uae";
    version = "3.2.35";
    src = pkgs.fetchurl {
      url = "https://github.com/FrodeSolheim/fs-uae/releases/download/v${version}/fs-uae-${version}.tar.xz";
      sha256 = "sha256-89PLjT3zSwsBJcRaWj4Yf/cQUL5dyEVcxFBcA4AmkRc=";
    };

    nativeBuildInputs = with pkgs; [
      autoreconfHook
      kdePackages.qtbase
      pkg-config
      strip-nondeterminism
      zip
    ];

    buildInputs = with pkgs; [
      freetype
      gettext
      glib
      gtk2
      libGL
      libGLU
      libmpeg2
      lua
      openal
      SDL2
      zlib
    ];

    strictDeps = true;

    dontWrapQtApps = true;

    postFixup = ''
      ${pkgs.strip-nondeterminism}/bin/strip-nondeterminism --type zip $out/share/fs-uae/fs-uae.dat
    '';
  };

  fsuae-launcher = pkgs.stdenv.mkDerivation rec {
    pname = "fs-uae-launcher";
    version = "3.2.20";
    src = pkgs.fetchurl {
      url = "https://github.com/FrodeSolheim/fs-uae-launcher/releases/download/v${version}/fs-uae-launcher-${version}.tar.xz";
      sha256 = "sha256-E0zKr18zeQ36RgDCEmgeCmFCndm/ks4SIeMngouIWQE=";
    };

    nativeBuildInputs = with pkgs; [
      gettext
      kdePackages.qtbase
      kdePackages.wrapQtAppsHook
      python3Packages.python
      python3Packages.pyopengl
    ];

    buildInputs = with pkgs.python3Packages; [
      pyqt6
      requests
      setuptools
    ];

    strictDeps = true;

    makeFlags = [ "prefix=$(out)" ];

    dontWrapQtApps = true;

    postPatch = ''
      substituteInPlace setup.py --replace-fail "distutils.core" "setuptools"
      # Fix timestamps older than 1980
      find . -exec touch -t 198001010000 {} +
    '';

    preFixup = ''
      wrapQtApp "$out/bin/fs-uae-launcher" --set PYTHONPATH "$PYTHONPATH"
      ln -s ${fsuae}/bin/fs-uae $out/bin
      ln -s ${fsuae}/bin/fs-uae-device-helper $out/bin
      ln -s ${fsuae}/share/fs-uae $out/share/fs-uae
    '';
  };

  fsuae-with-launcher = pkgs.symlinkJoin {
    name = "fs-uae-with-launcher";
    paths = [ fsuae fsuae-launcher ];
  };

in {
  environment.systemPackages = [ fsuae-with-launcher ];
}
